$files = Get-ChildItem -Path "src\main\java\Controller" -Filter "*.java"
foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    $content = $content -replace 'import dao\.', 'import DAO.'
    Set-Content -Path $file.FullName -Value $content -NoNewline
}
Write-Host "Fixed all imports in Controller folder"
