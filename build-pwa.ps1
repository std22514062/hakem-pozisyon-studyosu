# Hakem Pozisyon Stüdyosu — kurulabilir web uygulamasını (PWA) üretir.
# Kaynak: pozisyon-studyosu.html (uygulamanın kendisi) + pwa-src/ (manifest, servis çalışanı, yükleme düğmesi, ikon)
# Çıktı:  docs/ klasörü (GitHub Pages bu klasörü yayınlar) ve pwa.zip (Netlify Drop için)
# Kullanım: powershell -ExecutionPolicy Bypass -File build-pwa.ps1
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$src = Join-Path $root 'pozisyon-studyosu.html'
$ps = Join-Path $root 'pwa-src'
$out = Join-Path $root 'docs'
$enc = New-Object System.Text.UTF8Encoding($false)

if (Test-Path $out) { Remove-Item -Recurse -Force $out }
New-Item -ItemType Directory -Force (Join-Path $out 'icons') | Out-Null

# 1) index.html: kaynağın baş kısmı <head>'e, uygulama gövdesi <body>'ye
$s = [System.IO.File]::ReadAllText($src, $enc)
$cut = $s.IndexOf('<div class="app">')
if ($cut -lt 0) { throw 'pozisyon-studyosu.html içinde <div class="app"> bulunamadı' }
$headPart = $s.Substring(0, $cut) -replace '<meta name="claude:[^>]*>\r?\n?', ''
$bodyPart = $s.Substring($cut)
# herkese açık sürümde gerçek oyuncu isimleri varsayılan olarak kapalı (Görünüm menüsünden açılabilir)
$bodyPart = $bodyPart.Replace('<input type="checkbox" id="names" checked>', '<input type="checkbox" id="names">')
$build = (Get-Date).ToString('yyyyMMddHHmmss')
$head = @"
<!doctype html>
<html lang="tr">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover">
<meta name="description" content="Pozisyonu anlat, 3D canlandır, IFAB 2026/27 kurallarına göre değerlendir.">
<meta name="theme-color" content="#0e1411">
<meta name="color-scheme" content="light dark">
<meta name="mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
<meta name="apple-mobile-web-app-title" content="Hakem Stüdyo">
<link rel="manifest" href="manifest.webmanifest">
<link rel="icon" href="icons/icon.svg" type="image/svg+xml">
<link rel="icon" href="icons/icon-192.png" sizes="192x192" type="image/png">
<link rel="apple-touch-icon" href="icons/apple-touch-icon.png">
$headPart
<link rel="stylesheet" href="pwa.css?v=$build">
</head>
<body>
"@
$html = $head + $bodyPart.TrimEnd() + "`n<script src=`"pwa.js?v=$build`"></script>`n</body>`n</html>`n"
# pwa.js / pwa.css sorgu parametresiyle çağrıldığı için önbellek listesinde de aynı adla olmalı
[System.IO.File]::WriteAllText((Join-Path $out 'index.html'), $html, $enc)

# 2) servis çalışanı (her derlemede yeni sürüm adı → kullanıcılara güncelleme gider)
$sw = [System.IO.File]::ReadAllText((Join-Path $ps 'sw.js'), $enc).Replace('__BUILD__', $build).Replace("'./pwa.js', './pwa.css'", "'./pwa.js?v=$build', './pwa.css?v=$build'")
[System.IO.File]::WriteAllText((Join-Path $out 'sw.js'), $sw, $enc)
foreach ($f in 'manifest.webmanifest', 'pwa.js', 'pwa.css') { Copy-Item (Join-Path $ps $f) (Join-Path $out $f) }
Copy-Item (Join-Path $ps 'icons\icon.svg') (Join-Path $out 'icons\icon.svg')
Set-Content -Path (Join-Path $out '.nojekyll') -Value '' -NoNewline

# 3) PNG ikonlar (sarı + kırmızı kart, yeşil zemin)
Add-Type -AssemblyName System.Drawing
function New-Icon([int]$size, [string]$path, [bool]$full) {
  $bmp = New-Object System.Drawing.Bitmap $size, $size
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode = 'AntiAlias'; $g.Clear([System.Drawing.Color]::Transparent)
  $k = $size / 512.0
  $green = [System.Drawing.Color]::FromArgb(13, 107, 71); $dark = [System.Drawing.Color]::FromArgb(10, 86, 57)
  $rr = { param($x, $y, $w, $h, $r) $p = New-Object System.Drawing.Drawing2D.GraphicsPath; $d = 2 * $r
    $p.AddArc($x, $y, $d, $d, 180, 90); $p.AddArc($x + $w - $d, $y, $d, $d, 270, 90); $p.AddArc($x + $w - $d, $y + $h - $d, $d, $d, 0, 90); $p.AddArc($x, $y + $h - $d, $d, $d, 90, 90); $p.CloseFigure(); $p }
  $bg = if ($full) { $p = New-Object System.Drawing.Drawing2D.GraphicsPath; $p.AddRectangle((New-Object System.Drawing.RectangleF 0, 0, $size, $size)); $p } else { & $rr 0 0 $size $size (112 * $k) }
  $g.FillPath((New-Object System.Drawing.SolidBrush $green), $bg)
  $g.SetClip($bg); $g.FillRectangle((New-Object System.Drawing.SolidBrush $dark), 0, 360 * $k, $size, 152 * $k); $g.ResetClip()
  # maskable ikonda içerik güvenli alanda (%80) kalsın
  $sc = if ($full) { 0.8 } else { 1.0 }; $off = (1 - $sc) * $size / 2
  $card = { param($cx, $cy, $ang, $col)
    $st = $g.Save(); $g.TranslateTransform($off + $cx * $k * $sc, $off + $cy * $k * $sc); $g.RotateTransform($ang)
    $w = 150 * $k * $sc; $h = 214 * $k * $sc
    $g.FillPath((New-Object System.Drawing.SolidBrush $col), (& $rr (-$w / 2) (-$h / 2) $w $h (20 * $k * $sc))); $g.Restore($st) }
  & $card 205 203 -10 ([System.Drawing.Color]::FromArgb(242, 194, 48))
  & $card 303 237 8 ([System.Drawing.Color]::FromArgb(211, 49, 61))
  $g.Dispose(); $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png); $bmp.Dispose()
}
New-Icon 192 (Join-Path $out 'icons\icon-192.png') $false
New-Icon 512 (Join-Path $out 'icons\icon-512.png') $false
New-Icon 512 (Join-Path $out 'icons\maskable-512.png') $true
New-Icon 180 (Join-Path $out 'icons\apple-touch-icon.png') $true

# 4) Netlify Drop için zip
$zip = Join-Path $root 'pwa.zip'
if (Test-Path $zip) { Remove-Item -Force $zip }
Add-Type -AssemblyName System.IO.Compression, System.IO.Compression.FileSystem
$za = [System.IO.Compression.ZipFile]::Open($zip, 'Create')
try {
  foreach ($f in Get-ChildItem -Recurse -File $out) {
    $name = $f.FullName.Substring($out.Length + 1).Replace('\', '/')   # sunucular düz eğik çizgi bekler
    [void][System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($za, $f.FullName, $name)
  }
} finally { $za.Dispose() }
"Derlendi: sürüm $build -> $out ve $zip"
