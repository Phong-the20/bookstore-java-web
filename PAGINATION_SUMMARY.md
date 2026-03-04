# ✅ Đã thêm phân trang cho trang AllBook

## 📝 Tóm tắt thay đổi

### 1. **AllBookServlet.java** - Thêm logic phân trang
- Lấy parameter `page` từ URL (mặc định = 1)
- Gọi các method DAO với parameter `page`
- Tính `totalPages` = ceil(totalBooks / 12.0)
- Truyền `currentPage` và `totalPages` sang JSP

**Các trường hợp xử lý:**
- Tìm kiếm theo tiêu đề: `searchBookByTitle(keyword, page)` + `getTotalBooksByTitle(keyword)`
- Tìm kiếm theo tác giả: `searchBookByAuthor(keyword, page)` + `getTotalBooksByAuthor(keyword)`
- Tìm kiếm universal: `searchBooks(keyword, page)` + `getTotalBooksByKeyword(keyword)`
- Sắp xếp theo tên: `getBooksSortedByName(page)` + `getTotalBooks()`
- Sắp xếp theo giá: `getBooksSortedByPrice(page)` + `getTotalBooks()`
- Mặc định: `getAllBook(page)` + `getTotalBooks()`

### 2. **ProductDAO.java** - Thêm các method phân trang

**Method đếm tổng số sách:**
- `getTotalBooks()` - Đếm tất cả sách
- `getTotalBooksByTitle(String title)` - Đếm sách theo tiêu đề
- `getTotalBooksByAuthor(String author)` - Đếm sách theo tác giả
- `getTotalBooksByKeyword(String keyword)` - Đếm sách theo keyword

**Method lấy sách với phân trang (overload):**
- `getAllBook(int page)` - Lấy tất cả sách theo trang
- `searchBookByTitle(String title, int page)` - Tìm theo tiêu đề với phân trang
- `searchBookByAuthor(String author, int page)` - Tìm theo tác giả với phân trang
- `searchBooks(String keyword, int page)` - Tìm universal với phân trang
- `getBooksSortedByName(int page)` - Sắp xếp theo tên với phân trang
- `getBooksSortedByPrice(int page)` - Sắp xếp theo giá với phân trang

**SQL Pagination:**
```sql
OFFSET ? ROWS FETCH NEXT 12 ROWS ONLY
```
- Mỗi trang hiển thị **12 sách**
- OFFSET = (page - 1) * 12

### 3. **AllBook.jsp** - Thêm UI phân trang

**Style:**
- Nút tròn màu xanh lá (#4CAF50)
- Hover effect: nền xanh nhạt
- Active page: nền xanh, chữ trắng
- Disabled: màu xám, không click được

**Chức năng:**
- Nút Previous (◄): Chuyển về trang trước
- Các số trang: Click để chuyển trang
- Nút Next (►): Chuyển sang trang sau
- **Giữ nguyên các parameter:** keyword, type, sortBy khi chuyển trang

**Hiển thị:**
- Chỉ hiển thị khi `totalPages > 1`
- Nút Previous disabled khi ở trang 1
- Nút Next disabled khi ở trang cuối

## 🚀 Cách sử dụng

### Test phân trang:

1. **Xem tất cả sách:**
   ```
   http://localhost:8080/Lib/ab
   http://localhost:8080/Lib/ab?page=2
   ```

2. **Tìm kiếm với phân trang:**
   ```
   http://localhost:8080/Lib/ab?keyword=james&type=author
   http://localhost:8080/Lib/ab?keyword=james&type=author&page=2
   ```

3. **Sắp xếp với phân trang:**
   ```
   http://localhost:8080/Lib/ab?sortBy=title
   http://localhost:8080/Lib/ab?sortBy=price&page=2
   ```

## 📊 Thông số

- **Số sách mỗi trang:** 12
- **Tổng số sách:** Lấy từ database
- **Tổng số trang:** Math.ceil(totalBooks / 12.0)

## ✨ Tính năng

✅ Phân trang cho tất cả sách
✅ Phân trang cho tìm kiếm theo tiêu đề
✅ Phân trang cho tìm kiếm theo tác giả
✅ Phân trang cho tìm kiếm universal
✅ Phân trang cho sắp xếp theo tên
✅ Phân trang cho sắp xếp theo giá
✅ Giữ nguyên filter/search khi chuyển trang
✅ UI đẹp, responsive
✅ Disable nút khi ở trang đầu/cuối

## 🔧 Build và Test

1. **Clean and Build project**
2. **Restart server**
3. **Test các trang:**
   - Trang 1, 2, 3...
   - Previous/Next buttons
   - Tìm kiếm + phân trang
   - Sắp xếp + phân trang

## 📝 Notes

- Method cũ (không có parameter page) vẫn giữ nguyên để tương thích
- Sử dụng SQL Server syntax: `OFFSET ? ROWS FETCH NEXT ? ROWS ONLY`
- Pagination chỉ hiển thị khi có nhiều hơn 1 trang
- Style giống với trang Authors để đồng nhất UI
