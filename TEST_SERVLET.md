# 🔍 Test Servlet Pagination

## Bước 1: Clean and Build
1. Right-click project → **Clean and Build**
2. Xem Output window có lỗi compile không
3. Nếu có lỗi, fix trước khi tiếp tục

## Bước 2: Restart Server
1. Stop server
2. Run project
3. Đợi server start xong

## Bước 3: Test URL
Vào: `http://localhost:8080/Lib/ab`

## Bước 4: Kiểm tra Console Log
Trong NetBeans Output window, tìm dòng:
```
📊 Pagination Debug:
   Total Books: 20
   Total Pages: 5
   Current Page: 1
   Books in list: 4
```

**Nếu KHÔNG thấy dòng này:**
→ Servlet KHÔNG chạy
→ Có thể đang dùng cache cũ hoặc lỗi compile

## Bước 5: Hard Refresh Browser
- Nhấn **Ctrl + Shift + R**
- Hoặc mở **Incognito window** (Ctrl + Shift + N)
- Vào lại: `http://localhost:8080/Lib/ab`

## Bước 6: Kiểm tra giá trị
Scroll xuống, xem hộp màu vàng:
```
TEST: totalPages = ?, currentPage = ?
```

**Các trường hợp:**

### A. totalPages = 5, currentPage = 1
✅ **ĐÚNG!** Pagination sẽ hiển thị bên dưới
- Nếu không thấy → Lỗi CSS hoặc JSP syntax

### B. totalPages = (rỗng), currentPage = (rỗng)
❌ **SAI!** Servlet không truyền giá trị
- Kiểm tra lỗi compile
- Kiểm tra browser cache

### C. totalPages = 0 hoặc 1
⚠️ **Ít sách!** Database có < 5 sách
- Thêm sách vào database
- Hoặc giảm page size xuống 2

## Bước 7: Nếu vẫn không hoạt động
Chụp ảnh:
1. NetBeans Output window (console log)
2. Browser page (có hộp màu vàng)
3. Browser Console (F12 → Console tab)
