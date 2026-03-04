# 📦 Hướng Dẫn Quản Lý Đơn Hàng - Order Management System

## 🎯 Tổng Quan Chức Năng

Hệ thống quản lý đơn hàng với 2 tính năng chính:
1. **Hủy đơn hàng (Cancel Order)** - User
2. **Hoàn trả đơn hàng (Return Order)** - User + Admin approval

---

## 📋 Bước 1: Cập Nhật Database

### Chạy SQL Script

```sql
-- Thêm 2 cột mới vào bảng Orders
ALTER TABLE Orders ADD cancel_reason NVARCHAR(500);
ALTER TABLE Orders ADD return_status NVARCHAR(50);

-- Kiểm tra kết quả
SELECT id, name, status, cancel_reason, return_status, updated_at 
FROM Orders 
ORDER BY id DESC;
```

### Cấu Trúc Mới

| Cột | Kiểu | Mô tả |
|-----|------|-------|
| `cancel_reason` | NVARCHAR(500) | Lý do hủy đơn hàng |
| `return_status` | NVARCHAR(50) | Trạng thái hoàn trả: null, 'Đang chờ phê duyệt', 'Được phê duyệt', 'Từ chối' |

---

## 🔧 Bước 2: Kiểm Tra Code Đã Cập Nhật

### 2.1 Model: `Orders.java`

Đã thêm 2 fields mới:
```java
private String cancelReason;
private String returnStatus;
```

### 2.2 DAO: `OrdersDAO.java`

**Các phương thức mới:**

| Phương thức | Mô tả | Điều kiện |
|------------|-------|-----------|
| `cancelOrder(id, reason)` | Hủy đơn hàng | Status = 'Chờ xác nhận' |
| `requestReturn(id)` | Yêu cầu hoàn trả | Status = 'Hoàn tất' |
| `approveReturn(id)` | Admin phê duyệt | return_status = 'Đang chờ phê duyệt' |
| `rejectReturn(id)` | Admin từ chối | return_status = 'Đang chờ phê duyệt' |
| `canCancelOrder(id)` | Kiểm tra có thể hủy | - |
| `canReturnOrder(id)` | Kiểm tra có thể trả | - |

### 2.3 Servlet: `OrdersServlet.java`

**Các action handlers mới:**

- `action=cancel` → `cancelOrder()`
- `action=return` → `returnOrder()`
- `action=approveReturn` → `approveReturn()`
- `action=rejectReturn` → `rejectReturn()`

### 2.4 View: `orders.jsp`

**Thêm cột mới trong table:**
- Cột "Trạng thái hoàn trả" hiển thị return_status với màu sắc:
  - ⚠️ Đang chờ phê duyệt (vàng)
  - ✅ Được phê duyệt (xanh)
  - ❌ Từ chối (đỏ)

---

## 👤 Chức Năng User

### 🚫 Hủy Đơn Hàng

**Điều kiện:** Chỉ hủy được khi `status = 'Chờ xác nhận'`

**Lý do hủy đơn:**
1. Đổi địa chỉ giao hàng
2. Đổi phương thức thanh toán
3. Muốn thay đổi sản phẩm
4. Đặt nhầm đơn hàng
5. Tìm được giá tốt hơn
6. **Khác** (nhập lý do tự do)

**Flow:**
```
User click "Hủy đơn" 
→ Chọn lý do 
→ (Nếu chọn "Khác") Nhập text 
→ Xác nhận 
→ Status = "Đã hủy" 
→ cancel_reason lưu vào DB
```

**Giao diện:**
- Nút "Hủy đơn" chỉ hiển thị khi status = 'Chờ xác nhận'
- Modal có dropdown chọn lý do
- Nếu chọn "Khác" → hiện textarea để nhập
- Validate: Bắt buộc chọn lý do

### 🔄 Hoàn Trả Hàng

**Điều kiện:** Chỉ trả được khi `status = 'Hoàn tất'`

**Flow:**
```
User click "Hoàn trả" 
→ Xác nhận yêu cầu 
→ return_status = "Đang chờ phê duyệt" 
→ Chờ Admin xử lý
```

**Trạng thái hoàn trả:**
- 🟡 **Đang chờ phê duyệt** - Admin chưa xem
- 🟢 **Được phê duyệt** - Admin đồng ý
- 🔴 **Từ chối** - Admin từ chối

---

## 👨‍💼 Chức Năng Admin

### ✅ Phê Duyệt Hoàn Trả

**Khi nào hiển thị:**
- Chỉ admin thấy nút "Duyệt trả" và "Từ chối"
- Khi `return_status = 'Đang chờ phê duyệt'`

**Flow Approve:**
```
Admin click "Duyệt trả" 
→ Xác nhận 
→ return_status = "Được phê duyệt" 
→ User thấy trạng thái "Được phê duyệt"
```

**Flow Reject:**
```
Admin click "Từ chối" 
→ Xác nhận 
→ return_status = "Từ chối" 
→ User thấy trạng thái "Từ chối"
```

---

## 🎨 Giao Diện Chi Tiết

### Bảng Đơn Hàng

| STT | Mã đơn | Tên | SĐT | Địa chỉ | Tổng tiền | Ngày tạo | Ngày cập nhật | **Trạng thái** | **Trạng thái hoàn trả** | Hành động |
|-----|--------|-----|-----|---------|-----------|----------|---------------|----------------|------------------------|-----------|
| 1   | 115    | Nguyễn A | 0909... | Hà Nội | 500,000 | 01/11/2025 | 04/11/2025 | 🟢 Hoàn tất | 🟡 Đang chờ phê duyệt | [Chi tiết] [Hoàn trả] |

### Các Nút Hành Động

**User thường:**
- 🔵 **Chi tiết** - Luôn hiển thị
- 🔴 **Hủy đơn** - Chỉ khi status = 'Chờ xác nhận'
- 🟡 **Hoàn trả** - Chỉ khi status = 'Hoàn tất' VÀ chưa có return_status

**Admin:**
- 🔵 **Chi tiết** - Luôn hiển thị
- 🟠 **Sửa** - Đổi status đơn hàng
- 🟢 **Duyệt trả** - Khi return_status = 'Đang chờ phê duyệt'
- 🔴 **Từ chối** - Khi return_status = 'Đang chờ phê duyệt'

---

## 🚀 Hướng Dẫn Test

### Test 1: Hủy Đơn Hàng

1. Login với user thường
2. Tìm đơn hàng có status = "Chờ xác nhận"
3. Click nút "Hủy đơn"
4. Chọn lý do: "Đổi địa chỉ giao hàng"
5. Click "Xác nhận hủy"
6. ✅ Kết quả: Status = "Đã hủy", cancel_reason lưu vào DB

### Test 2: Hủy Đơn với Lý Do Khác

1. Click "Hủy đơn"
2. Chọn: "Khác (nhập lý do)"
3. Textarea hiện ra
4. Nhập: "Muốn mua ở shop khác giá rẻ hơn"
5. Click "Xác nhận hủy"
6. ✅ Kết quả: cancel_reason = text vừa nhập

### Test 3: Hoàn Trả Hàng (User)

1. Login với user thường
2. Tìm đơn hàng có status = "Hoàn tất"
3. Click nút "Hoàn trả"
4. Đọc thông báo → Click "Gửi yêu cầu hoàn trả"
5. ✅ Kết quả: return_status = "Đang chờ phê duyệt"

### Test 4: Phê Duyệt Hoàn Trả (Admin)

1. Login với tài khoản admin
2. Tìm đơn có return_status = "Đang chờ phê duyệt"
3. Click "Duyệt trả"
4. Click "Phê duyệt"
5. ✅ Kết quả: return_status = "Được phê duyệt"
6. Login user → Kiểm tra thấy status "Được phê duyệt"

### Test 5: Từ Chối Hoàn Trả (Admin)

1. Login admin
2. Click "Từ chối" trên đơn chờ duyệt
3. Click "Từ chối"
4. ✅ Kết quả: return_status = "Từ chối"

### Test 6: Kiểm Tra Điều Kiện

**Test không được hủy khi status khác "Chờ xác nhận":**
- Đơn "Đang giao" → Không có nút "Hủy đơn" ✅
- Đơn "Hoàn tất" → Không có nút "Hủy đơn" ✅
- Đơn "Đã hủy" → Không có nút "Hủy đơn" ✅

**Test không được hoàn trả khi status khác "Hoàn tất":**
- Đơn "Chờ xác nhận" → Không có nút "Hoàn trả" ✅
- Đơn "Đang giao" → Không có nút "Hoàn trả" ✅
- Đơn "Đã hủy" → Không có nút "Hoàn trả" ✅

---

## 📊 SQL Queries Hữu Ích

### Xem tất cả đơn hàng với trạng thái

```sql
SELECT 
    id, 
    name, 
    status, 
    cancel_reason, 
    return_status,
    updated_at
FROM Orders
ORDER BY updated_at DESC;
```

### Lọc đơn đang chờ phê duyệt hoàn trả

```sql
SELECT * FROM Orders
WHERE return_status = N'Đang chờ phê duyệt'
ORDER BY updated_at DESC;
```

### Thống kê lý do hủy đơn

```sql
SELECT 
    cancel_reason, 
    COUNT(*) as so_lan
FROM Orders
WHERE cancel_reason IS NOT NULL
GROUP BY cancel_reason
ORDER BY so_lan DESC;
```

### Xem đơn hàng đã bị hủy

```sql
SELECT * FROM Orders
WHERE status = N'Đã hủy'
ORDER BY updated_at DESC;
```

---

## ⚠️ Lưu Ý Quan Trọng

### 1. Trạng Thái Đơn Hàng

Hệ thống sử dụng 4 trạng thái chính:
- 🟡 **Chờ xác nhận** - Mới tạo, có thể hủy
- 🔵 **Đang giao** - Đang vận chuyển
- 🟢 **Hoàn tất** - Đã nhận hàng, có thể hoàn trả
- 🔴 **Đã hủy** - Đã hủy bỏ

### 2. Quy Tắc Nghiệp Vụ

| Hành động | Điều kiện status | Thêm điều kiện |
|-----------|-----------------|----------------|
| Hủy đơn | Chờ xác nhận | - |
| Hoàn trả | Hoàn tất | return_status = null hoặc rỗng |
| Phê duyệt hoàn trả | Bất kỳ | return_status = 'Đang chờ phê duyệt' |
| Từ chối hoàn trả | Bất kỳ | return_status = 'Đang chờ phê duyệt' |

### 3. Validation

- **Cancel reason** bắt buộc phải chọn
- Nếu chọn "Khác" → Bắt buộc nhập text
- Admin không thể hủy đơn đang giao

### 4. Bảo Mật

- Chỉ admin mới thấy nút phê duyệt/từ chối
- User chỉ thấy nút hủy/hoàn trả của mình
- Check quyền ở servlet level

---

## 🔍 Troubleshooting

### Lỗi: Không thấy nút "Hủy đơn"

**Nguyên nhân:** Status không phải "Chờ xác nhận"

**Giải pháp:**
```sql
UPDATE Orders 
SET status = N'Chờ xác nhận' 
WHERE id = [order_id];
```

### Lỗi: Không thấy nút "Hoàn trả"

**Nguyên nhân:** 
1. Status không phải "Hoàn tất", HOẶC
2. Đã có return_status (đang chờ hoặc đã xử lý)

**Giải pháp:**
```sql
UPDATE Orders 
SET status = N'Hoàn tất', 
    return_status = NULL 
WHERE id = [order_id];
```

### Lỗi: Admin không thấy nút "Duyệt trả"

**Nguyên nhân:** return_status không phải "Đang chờ phê duyệt"

**Giải pháp:**
```sql
UPDATE Orders 
SET return_status = N'Đang chờ phê duyệt' 
WHERE id = [order_id];
```

### Lỗi: OrdersDAO cannot be resolved

**Nguyên nhân:** IDE chưa compile lại

**Giải pháp:**
1. Clean & Build project
2. Restart IDE
3. Check package name: `dao.OrdersDAO`

---

## 📞 Liên Hệ & Hỗ Trợ

Nếu gặp vấn đề, kiểm tra theo thứ tự:

1. ✅ Database đã chạy SQL thêm 2 cột chưa?
2. ✅ Code đã compile thành công chưa?
3. ✅ Đăng nhập đúng quyền (user/admin)?
4. ✅ Status đơn hàng đúng điều kiện chưa?
5. ✅ Có lỗi trong console/log không?

---

**Phiên bản:** 1.0  
**Ngày tạo:** 04/11/2025  
**Framework:** Java Servlet/JSP + SQL Server
