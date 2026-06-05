$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'Continue'

$root = 'C:\Users\daka\vscode\build-blog\build-transcripts'
New-Item -ItemType Directory -Force -Path $root | Out-Null

$ids = @('BRK230','BRK232','BRK240','BRK241','BRK242','BRK243','BRK246','BRK250','BRK251','BRK252','BRKSP91','BRKSP94')

function Get-MetaContent($html, $key) {
    # match <meta property="KEY" content="...">  OR  <meta content="..." property="KEY">
    $m = [regex]::Match($html, '<meta[^>]*(?:property|name)="' + [regex]::Escape($key) + '"[^>]*content="([^"]*)"')
    if ($m.Success) { return $m.Groups[1].Value }
    $m = [regex]::Match($html, '<meta[^>]*content="([^"]*)"[^>]*(?:property|name)="' + [regex]::Escape($key) + '"')
    if ($m.Success) { return $m.Groups[1].Value }
    return ''
}

function Decode-Html($s) {
    if (-not $s) { return $s }
    return [System.Net.WebUtility]::HtmlDecode($s)
}

$manifest = @()

foreach ($id in $ids) {
    Write-Output "=== $id ==="
    $dir = Join-Path $root $id
    New-Item -ItemType Directory -Force -Path $dir | Out-Null

    $rec = [ordered]@{
        id = $id
        url = "https://build.microsoft.com/en-US/sessions/$id"
        title = ''
        description = ''
        asset_id = ''
        caption_route = ''
        caption_bytes = 0
        clean_chars = 0
        status = ''
        note = ''
    }

    # STEP 1: session page
    try {
        $r = Invoke-WebRequest -Uri $rec.url -UseBasicParsing -TimeoutSec 40
        $html = $r.Content
        $rec.title = Decode-Html (Get-MetaContent $html 'og:title')
        if (-not $rec.title) { $rec.title = Decode-Html (Get-MetaContent $html 'twitter:title') }
        $rec.description = Decode-Html (Get-MetaContent $html 'og:description')
        if (-not $rec.description) { $rec.description = Decode-Html (Get-MetaContent $html 'description') }
        $am = [regex]::Match($html, 'asset/Thumbnail/([A-Za-z0-9_-]{8,})')
        if ($am.Success) { $rec.asset_id = $am.Groups[1].Value }
    } catch {
        $rec.status = 'page_fetch_failed'
        $rec.note = $_.Exception.Message
        Write-Output "  page fetch FAILED: $($_.Exception.Message)"
        $manifest += (New-Object PSObject -Property $rec)
        continue
    }

    Write-Output "  title: $($rec.title)"
    Write-Output "  asset: $($rec.asset_id)"

    if (-not $rec.asset_id) {
        $rec.status = 'no_asset'
        $rec.note = 'no Thumbnail asset id found in page (session may not be recorded)'
        Write-Output "  NO ASSET ID"
        $manifest += (New-Object PSObject -Property $rec)
        continue
    }

    # STEP 2: CAPTION route
    $captionUrl = "https://medius.microsoft.com/video/asset/CAPTION/$($rec.asset_id)"
    $vtt = $null
    try {
        $cr = Invoke-WebRequest -Uri $captionUrl -UseBasicParsing -TimeoutSec 90
        $ctype = [string]$cr.Headers['Content-Type']
        if ($ctype -match 'vtt' -and $cr.RawContentLength -gt 2000) {
            $vtt = $cr.Content
            $rec.caption_route = 'CAPTION'
            $rec.caption_bytes = $cr.RawContentLength
            Write-Output "  CAPTION ok: $($cr.RawContentLength) bytes"
        } else {
            Write-Output "  CAPTION returned ctype=$ctype bytes=$($cr.RawContentLength) (too small / wrong type)"
        }
    } catch {
        Write-Output "  CAPTION failed: $($_.Exception.Message)"
    }

    # Fallback A: try TextTrack / other route on medius
    if (-not $vtt) {
        foreach ($route in @('TextTrack','CC','Transcript')) {
            try {
                $u2 = "https://medius.microsoft.com/video/asset/$route/$($rec.asset_id)"
                $cr2 = Invoke-WebRequest -Uri $u2 -UseBasicParsing -TimeoutSec 60
                $ct2 = [string]$cr2.Headers['Content-Type']
                if ($ct2 -match 'vtt' -and $cr2.RawContentLength -gt 2000) {
                    $vtt = $cr2.Content
                    $rec.caption_route = $route
                    $rec.caption_bytes = $cr2.RawContentLength
                    Write-Output "  fallback $route ok: $($cr2.RawContentLength) bytes"
                    break
                }
            } catch { }
        }
    }

    if (-not $vtt) {
        $rec.status = 'no_transcript'
        $rec.note = 'CAPTION and fallback routes returned no usable VTT'
        $manifest += (New-Object PSObject -Property $rec)
        continue
    }

    # save raw vtt
    $rawPath = Join-Path $dir 'transcript_raw.vtt'
    [System.IO.File]::WriteAllText($rawPath, $vtt, (New-Object System.Text.UTF8Encoding $false))

    # STEP 3: clean
    $raw = $vtt
    $raw = [regex]::Replace($raw, 'NOTE Confidence: [0-9.]+', '')
    $raw = [regex]::Replace($raw, 'NOTE language:[^ \r\n]+', '')
    $linesArr = $raw -split "`n"
    $texts = New-Object System.Collections.Generic.List[string]
    foreach ($ln0 in $linesArr) {
        $ln = $ln0.Trim()
        if ($ln -eq '') { continue }
        if ($ln.StartsWith('WEBVTT')) { continue }
        if ($ln -eq 'NOTE') { continue }
        if ($ln -match '-->') { continue }
        if ($ln -match '^[0-9]+$') { continue }
        $ln = [regex]::Replace($ln, '<[^>]+>', '').Trim()
        if ($ln -ne '') { $texts.Add($ln) }
    }
    $out = New-Object System.Collections.Generic.List[string]
    foreach ($t in $texts) {
        if ($out.Count -eq 0 -or $out[$out.Count-1] -ne $t) { $out.Add($t) }
    }
    $full = ($out -join ' ')
    $full = [regex]::Replace($full, '\s+', ' ').Trim()
    $cleanPath = Join-Path $dir 'transcript_clean.txt'
    [System.IO.File]::WriteAllText($cleanPath, $full, (New-Object System.Text.UTF8Encoding $false))
    $rec.clean_chars = $full.Length
    $rec.status = 'ok'
    Write-Output "  clean chars: $($full.Length)"

    $manifest += (New-Object PSObject -Property $rec)
}

$manifestPath = Join-Path $root 'manifest.json'
$manifest | ConvertTo-Json -Depth 5 | Set-Content -Path $manifestPath -Encoding UTF8
Write-Output ""
Write-Output "MANIFEST written: $manifestPath"
Write-Output ($manifest | Format-Table id,status,caption_route,caption_bytes,clean_chars,title -AutoSize | Out-String)
