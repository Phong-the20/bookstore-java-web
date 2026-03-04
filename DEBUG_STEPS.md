# 🔍 Các bước debug pagination

## Bước 1: Kiểm tra lỗi compile

1. **Clean and Build project** trong NetBeans
2. Xem tab **Output** - nếu có lỗi compile sẽ hiển thị ở đây
3. Nếu có lỗi về `ProductDAO`, kiểm tra:
   - Package declaration trong ProductDAO.java: `package dao;`
   - Import trong AllBookServlet.java: `import dao.ProductDAO;`

## Bước 2: Restart server

1. Stop server (nếu đang chạy)
2. Clean and Build project
3. Run project

## Bước 3: Kiểm tra trang web

Vào: `http://localhost:8080/Lib/ab`

### Bạn sẽ thấy:

**A. Debug Info Box (màu xám):**
```
Debug Pagination:
Total Pages: ?
Current Page: ?
Total Books: ? books displayed
```

**B. Pagination (nếu có):**
- Nút ◄ (Previous)
- Số trang: 1, 2, 3...
- Nút ► (Next)

## Bước 4: Kiểm tra console log

Trong NetBeans Output window, tìm dòng:
```
📊 Pagination Debug:
   Total Books: ?
   Total Pages: ?
   Current Page: ?
   Books in list: ?
```

## Các trường hợp:

### Trường hợp 1: Không thấy Debug Info Box
**Nguyên nhân:** Code không chạy, có lỗi compile hoặc server chưa restart
**Giải pháp:** 
- Kiểm tra lỗi compile
- Restart server
- Clear browser cache (Ctrl + F5)

### Trường hợp 2: Thấy Debug Info nhưng Total Pages = 0
**Nguyên nhân:** Method `getTotalBooks()` trả về 0
**Giải pháp:**
- Chạy `check_book_count.sql` để xem có bao nhiêu sách trong database
- Kiểm tra connection string database

### Trường hợp 3: Thấy Debug Info, Total Pages = 1
**Nguyên nhân:** Database có ít hơn 13 sách (12 sách/trang)
**Giải pháp:**
- Giảm số sách mỗi trang từ 12 → 4
- Hoặc thêm sách vào database

### Trường hợp 4: Total Pages > 1 nhưng không thấy pagination
**Nguyên nhân:** CSS không load hoặc điều kiện `c:if` sai
**Giải pháp:**
- Đã sửa điều kiện từ `> 1` → `>= 1`
- Kiểm tra browser console (F12) xem có lỗi CSS không

## Bước 5: Test pagination

Nếu thấy pagination:
1. Click số trang 2 → URL sẽ thành `/ab?page=2`
2. Click Next → Chuyển sang trang tiếp theo
3. Click Previous → Quay lại trang trước

## Nếu vẫn không hoạt động:

Chụp ảnh màn hình:
1. Trang web (có Debug Info Box)
2. NetBeans Output window (console log)
3. Browser Console (F12 → Console tab)

Và gửi cho tôi để debug tiếp!
