-- Test đơn giản để kiểm tra tìm kiếm
USE [BOOK_STORE]
GO

-- Kiểm tra Author có tên "James Gosling"
PRINT '=== Authors in database ===';
SELECT id, name FROM Author;
GO

-- Kiểm tra sách của James Gosling
PRINT '=== Books by James Gosling ===';
SELECT 
    p.sku,
    p.name AS book_name,
    a.name AS author_name
FROM Product p
INNER JOIN Product_Author pa ON p.sku = pa.product_sku
INNER JOIN Author a ON pa.author_id = a.id
WHERE a.name = 'James Gosling';
GO

-- Test tìm kiếm với LIKE
PRINT '=== Search with LIKE james ===';
SELECT 
    p.sku,
    p.name AS book_name,
    a.name AS author_name
FROM Product p
INNER JOIN Product_Author pa ON p.sku = pa.product_sku
INNER JOIN Author a ON pa.author_id = a.id
WHERE LOWER(a.name) LIKE '%james%';
GO

-- Test tìm kiếm với LIKE (case insensitive)
PRINT '=== Search with LIKE JAMES (uppercase) ===';
SELECT 
    p.sku,
    p.name AS book_name,
    a.name AS author_name
FROM Product p
INNER JOIN Product_Author pa ON p.sku = pa.product_sku
INNER JOIN Author a ON pa.author_id = a.id
WHERE LOWER(a.name) LIKE LOWER('%JAMES%');
GO
