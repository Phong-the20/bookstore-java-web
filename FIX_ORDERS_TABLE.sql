-- =====================================================
-- FIX ORDERS TABLE - Add Missing Columns
-- Run this AFTER creating the main database
-- =====================================================

USE [BOOK_STORE]
GO

-- Kiểm tra và thêm cột updated_at
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Orders') AND name = 'updated_at')
BEGIN
    ALTER TABLE Orders ADD updated_at DATE DEFAULT CAST(GETDATE() AS DATE);
    PRINT 'Added column: updated_at';
END
ELSE
BEGIN
    PRINT 'Column updated_at already exists';
END
GO

-- Kiểm tra và thêm cột cancel_reason
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Orders') AND name = 'cancel_reason')
BEGIN
    ALTER TABLE Orders ADD cancel_reason NVARCHAR(500);
    PRINT 'Added column: cancel_reason';
END
ELSE
BEGIN
    PRINT 'Column cancel_reason already exists';
END
GO

-- Kiểm tra và thêm cột return_status
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Orders') AND name = 'return_status')
BEGIN
    ALTER TABLE Orders ADD return_status NVARCHAR(50);
    PRINT 'Added column: return_status';
END
ELSE
BEGIN
    PRINT 'Column return_status already exists';
END
GO

-- Kiểm tra và thêm cột status
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Orders') AND name = 'status')
BEGIN
    ALTER TABLE Orders ADD status NVARCHAR(50) DEFAULT N'Chờ xác nhận';
    PRINT 'Added column: status';
END
ELSE
BEGIN
    PRINT 'Column status already exists';
END
GO

-- Cập nhật status và updated_at cho các đơn hàng hiện tại
UPDATE Orders 
SET status = CASE 
        WHEN status IS NULL OR status = '' THEN N'Chờ xác nhận'
        ELSE status
    END,
    updated_at = CASE 
        WHEN updated_at IS NULL THEN CAST(dateBuy AS DATE)
        ELSE updated_at
    END;
GO

PRINT '============================================';
PRINT 'Orders table updated successfully!';
PRINT '============================================';

-- Kiểm tra kết quả
SELECT 
    id, 
    name, 
    CONVERT(VARCHAR, dateBuy, 120) as dateBuy,
    status, 
    cancel_reason, 
    return_status, 
    CONVERT(VARCHAR, updated_at, 120) as updated_at
FROM Orders 
ORDER BY id DESC;
GO

-- Hiển thị cấu trúc bảng Orders
EXEC sp_help 'Orders';
GO
