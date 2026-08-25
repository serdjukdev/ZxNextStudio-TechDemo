$verFile = "version.txt"
if (-Not (Test-Path $verFile)) { "100" | Out-File $verFile -Encoding ascii }

# Читаем и инкрементируем общее число
$total = [int](Get-Content $verFile) + 1
$total | Out-File $verFile -Encoding ascii

# Вычисляем Major и Minor
$major = [math]::Floor($total / 100)
$minor = $total % 100

# Формируем строку вида "v1.05"
$vString = "v{0}.{1:D2}" -f $major, $minor

# Преобразуем строку напрямую в байты ASCII и сохраняем
$asciiBytes = [System.Text.Encoding]::ASCII.GetBytes($vString)
[System.IO.File]::WriteAllBytes("$(Get-Location)/code/version.bin", $asciiBytes)

Write-Host "Version binary generated: $vString"
