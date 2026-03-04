-- =====================================================
-- ORDER MANAGEMENT - DATABASE UPDATES
-- Features: Cancel Order & Return Order
-- =====================================================

-- 1. Add columns to Orders table for cancel and return tracking
ALTER TABLE Orders ADD cancel_reason NVARCHAR(500);
ALTER TABLE Orders ADD return_status NVARCHAR(50);  -- 'Đang chờ phê duyệt', 'Được phê duyệt', 'Từ chối'

-- 2. Update status values to match requirements
-- Current statuses: 'Chờ xác nhận', 'Đang giao', 'Hoàn tất', 'Đã hủy'
-- New return statuses will be added dynamically

-- 3. View current data
SELECT id, name, status, cancel_reason, return_status, updated_at 
FROM Orders 
ORDER BY id DESC;

-- =====================================================
-- NOTES:
-- =====================================================
-- User can CANCEL when: status = 'Chờ xác nhận'
-- User can RETURN when: status = 'Hoàn tất'
-- 
-- Cancel reasons:
-- - Đổi địa chỉ giao hàng
-- - Đổi phương thức thanh toán
-- - Muốn thay đổi sản phẩm
-- - Đặt nhầm đơn hàng
-- - Khác (nhập lý do)
--
-- Return flow:
-- 1. User clicks return -> return_status = 'Đang chờ phê duyệt'
-- 2. Admin approves -> return_status = 'Được phê duyệt'
-- 3. Admin rejects -> return_status = 'Từ chối'
-- =====================================================
