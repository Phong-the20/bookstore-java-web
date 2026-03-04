# Script để đổi page size từ 12 → 4 trong ProductDAO.java

$file = "src\main\java\DAO\ProductDAO.java"

# Đọc nội dung file
$content = Get-Content $file -Raw

# Replace các pattern
$content = $content -replace 'OFFSET \? ROWS FETCH NEXT 12 ROWS ONLY', 'OFFSET ? ROWS FETCH NEXT 4 ROWS ONLY'
$content = $content -replace '\(page - 1\) \* 12', '(page - 1) * 4'

# Ghi lại file
$content | Set-Content $file -NoNewline

Write-Host "✅ Đã đổi page size từ 12 → 4 trong ProductDAO.java"
Write-Host "📝 Nhớ restart server sau khi chạy script này!"
