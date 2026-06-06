$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'Continue'

$root = 'C:\Users\daka\vscode\build-blog\build-transcripts'
$sessionsDir = Join-Path $root 'Sessions'

# Gather id -> asset_id from both manifests
$map = @{}
foreach ($mf in @('manifest.json','manifest_more.json')) {
    $p = Join-Path $root $mf
    if (Test-Path $p) {
        $data = Get-Content $p -Raw | ConvertFrom-Json
        foreach ($rec in $data) {
            if ($rec.id -and $rec.asset_id) { $map[$rec.id] = $rec.asset_id }
        }
    }
}

Write-Output ("Sessions with asset_id: " + $map.Count)

$results = @()
foreach ($id in ($map.Keys | Sort-Object)) {
    $asset = $map[$id]
    $dir = Join-Path $sessionsDir $id
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
    $final = Join-Path $dir ($id + '_slides.pptx')

    $rec = [ordered]@{ id = $id; asset = $asset; status = ''; bytes = 0; ctype = '' }

    if (Test-Path $final) {
        $rec.status = 'already_exists'
        $rec.bytes  = (Get-Item $final).Length
        $results += (New-Object PSObject -Property $rec)
        Write-Output ("{0,-10} SKIP (exists, {1} KB)" -f $id, [math]::Round($rec.bytes/1KB))
        continue
    }

    $url = "https://medius.microsoft.com/video/asset/PPT/$asset"
    $tmp = Join-Path $dir 'slides_download.tmp'
    try {
        $resp = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 240 -OutFile $tmp -PassThru
        $ctype = [string]$resp.Headers['Content-Type']
        $rec.ctype = $ctype
        $bytes = [System.IO.File]::ReadAllBytes($tmp)
        $isZip = ($bytes.Length -gt 4 -and $bytes[0] -eq 0x50 -and $bytes[1] -eq 0x4B)
        if ($ctype -match 'presentation' -and $isZip -and $bytes.Length -gt 10000) {
            Move-Item -Path $tmp -Destination $final -Force
            $rec.status = 'ok'
            $rec.bytes  = $bytes.Length
            Write-Output ("{0,-10} OK   ({1} KB)" -f $id, [math]::Round($bytes.Length/1KB))
        } else {
            Remove-Item $tmp -Force -ErrorAction SilentlyContinue
            $rec.status = 'no_pptx'
            Write-Output ("{0,-10} NO PPTX (ctype={1} bytes={2})" -f $id, $ctype, $bytes.Length)
        }
    } catch {
        if (Test-Path $tmp) { Remove-Item $tmp -Force -ErrorAction SilentlyContinue }
        $rec.status = 'error'
        Write-Output ("{0,-10} ERROR: {1}" -f $id, $_.Exception.Message)
    }
    $results += (New-Object PSObject -Property $rec)
}

$slidesManifest = Join-Path $root 'slides_manifest.json'
$results | ConvertTo-Json -Depth 4 | Set-Content -Path $slidesManifest -Encoding UTF8

Write-Output ""
Write-Output "=== SUMMARY ==="
$results | Group-Object status | ForEach-Object { Write-Output ("{0,-16} {1}" -f $_.Name, $_.Count) }
Write-Output ("manifest: " + $slidesManifest)
