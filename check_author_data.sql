-- Script kiểm tra dữ liệu Author
USE [BOOK_STORE]
GO

PRINT '=== CHECKING AUTHOR DATA ===';
GO

-- 1. Kiểm tra bảng Author
PRINT 'Authors in database:';
SELECT id, name, bio FROM Author;
GO

-- 2. Kiểm tra bảng Product_Author
PRINT 'Product-Author relationships:';
SELECT product_sku, author_id FROM Product_Author;
GO

-- 3. Kiểm tra sách có tác giả
PRINT 'Books with authors:';
SELECT 
    p.sku,
    p.name AS book_name,
    a.name AS author_name
FROM Product p
LEFT JOIN Product_Author pa ON p.sku = pa.product_sku
LEFT JOIN Author a ON pa.author_id = a.id
ORDER BY p.sku;
GO

-- 4. Test tìm kiếm theo tác giả 'james'
PRINT 'Search test for "james":';
SELECT 
    p.sku,
    p.name AS book_name,
    a.name AS author_name
FROM Product p
LEFT JOIN Product_Author pa ON p.sku = pa.product_sku
LEFT JOIN Author a ON pa.author_id = a.id
WHERE LOWER(a.name) LIKE LOWER('%james%');
GO
