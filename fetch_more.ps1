$ProgressPreference='SilentlyContinue'
$ErrorActionPreference='Continue'
$root='C:\Users\daka\vscode\build-blog\build-transcripts'
$ids=@('BRK235')

function Get-MetaContent($html,$key){
  $m=[regex]::Match($html,'<meta[^>]*(?:property|name)="'+[regex]::Escape($key)+'"[^>]*content="([^"]*)"')
  if($m.Success){return $m.Groups[1].Value}
  $m=[regex]::Match($html,'<meta[^>]*content="([^"]*)"[^>]*(?:property|name)="'+[regex]::Escape($key)+'"')
  if($m.Success){return $m.Groups[1].Value}
  return ''
}

$results=@()
foreach($id in $ids){
  Write-Output "=== $id ==="
  $dir=Join-Path $root $id
  New-Item -ItemType Directory -Force -Path $dir | Out-Null
  $rec=[ordered]@{id=$id;url="https://build.microsoft.com/en-US/sessions/$id";title='';description='';asset_id='';caption_route='';caption_bytes=0;clean_chars=0;status='';note=''}
  try{
    $r=Invoke-WebRequest -Uri $rec.url -UseBasicParsing -TimeoutSec 40
    $html=$r.Content
    $rec.title=[System.Net.WebUtility]::HtmlDecode((Get-MetaContent $html 'og:title'))
    $rec.description=[System.Net.WebUtility]::HtmlDecode((Get-MetaContent $html 'og:description'))
    $am=[regex]::Match($html,'asset/Thumbnail/([A-Za-z0-9_-]{8,})')
    if($am.Success){$rec.asset_id=$am.Groups[1].Value}
  }catch{
    $rec.status='page_fetch_failed';$rec.note=$_.Exception.Message
    Write-Output "  page FAILED: $($_.Exception.Message)";$results+=(New-Object PSObject -Property $rec);continue
  }
  Write-Output "  title: $($rec.title)"
  Write-Output "  asset: $($rec.asset_id)"
  if(-not $rec.asset_id){
    $rec.status='no_asset';$rec.note='no Thumbnail asset id (session may have no recording)'
    Write-Output "  NO ASSET";$results+=(New-Object PSObject -Property $rec);continue
  }
  $vtt=$null
  try{
    $cr=Invoke-WebRequest -Uri "https://medius.microsoft.com/video/asset/CAPTION/$($rec.asset_id)" -UseBasicParsing -TimeoutSec 90
    $ct=[string]$cr.Headers['Content-Type']
    if($ct -match 'vtt' -and $cr.RawContentLength -gt 2000){$vtt=$cr.Content;$rec.caption_route='CAPTION';$rec.caption_bytes=$cr.RawContentLength;Write-Output "  CAPTION ok: $($cr.RawContentLength)"}
    else{Write-Output "  CAPTION ctype=$ct bytes=$($cr.RawContentLength)"}
  }catch{Write-Output "  CAPTION failed: $($_.Exception.Message)"}
  if(-not $vtt){
    $rec.status='no_transcript';$rec.note='CAPTION returned no usable VTT';$results+=(New-Object PSObject -Property $rec);continue
  }
  [System.IO.File]::WriteAllText((Join-Path $dir 'transcript_raw.vtt'),$vtt,(New-Object System.Text.UTF8Encoding $false))
  $raw=[regex]::Replace($vtt,'NOTE Confidence: [0-9.]+','')
  $raw=[regex]::Replace($raw,'NOTE language:[^ \r\n]+','')
  $texts=New-Object System.Collections.Generic.List[string]
  foreach($ln0 in ($raw -split "`n")){$ln=$ln0.Trim();if($ln -eq ''){continue};if($ln.StartsWith('WEBVTT')){continue};if($ln -eq 'NOTE'){continue};if($ln -match '-->'){continue};if($ln -match '^[0-9]+$'){continue};$ln=[regex]::Replace($ln,'<[^>]+>','').Trim();if($ln -ne ''){$texts.Add($ln)}}
  $out=New-Object System.Collections.Generic.List[string]
  foreach($t in $texts){if($out.Count -eq 0 -or $out[$out.Count-1] -ne $t){$out.Add($t)}}
  $full=[regex]::Replace(($out -join ' '),'\s+',' ').Trim()
  [System.IO.File]::WriteAllText((Join-Path $dir 'transcript_clean.txt'),$full,(New-Object System.Text.UTF8Encoding $false))
  $rec.clean_chars=$full.Length;$rec.status='ok'
  Write-Output "  clean chars: $($full.Length)"
  $results+=(New-Object PSObject -Property $rec)
}
$results | ConvertTo-Json -Depth 5 | Set-Content -Path (Join-Path $root 'manifest_more.json') -Encoding UTF8
Write-Output ""
Write-Output ($results | Format-Table id,status,caption_route,caption_bytes,clean_chars,title -AutoSize | Out-String)