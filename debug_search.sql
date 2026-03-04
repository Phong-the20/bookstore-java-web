-- Script debug tìm kiếm tác giả
USE [BOOK_STORE]
GO

PRINT '=== 1. KIỂM TRA DỮ LIỆU AUTHOR ===';
SELECT * FROM Author;
GO

PRINT '=== 2. KIỂM TRA LIÊN KẾT PRODUCT_AUTHOR ===';
SELECT * FROM Product_Author;
GO

PRINT '=== 3. KIỂM TRA SÁCH VỚI TÁC GIẢ (FULL JOIN) ===';
SELECT 
    p.sku,
    p.name AS book_name,
    pa.author_id,
    a.name AS author_name
FROM Product p
LEFT JOIN Product_Author pa ON p.sku = pa.product_sku
LEFT JOIN Author a ON pa.author_id = a.id
ORDER BY p.sku;
GO

PRINT '=== 4. TEST TÌM KIẾM "JAMES" (EXACT QUERY FROM CODE) ===';
SELECT 
    p.sku, 
    p.name AS product_name, 
    p.img,
    p.price AS price_vnd,
    p.quantity - COALESCE(SUM(od.quantity), 0) AS remaining_quantity,
    p.description,
    c.name AS category_name, 
    a.name AS author_name,
    COALESCE(SUM(od.quantity), 0) AS sold,
    pd.id AS detail_id
FROM Product p
LEFT JOIN Product_Author pa ON p.sku = pa.product_sku
LEFT JOIN Author a ON pa.author_id = a.id
LEFT JOIN Category c ON p.category_id = c.id
LEFT JOIN OrderDetails od ON p.sku = od.sku
LEFT JOIN productDetail pd ON p.sku = pd.product_sku
WHERE LOWER(a.name) LIKE LOWER('%james%')
GROUP BY p.sku, p.name, p.img, c.name, a.name, p.price, p.quantity, p.description, pd.id;
GO

PRINT '=== 5. TEST TÌM KIẾM "JAMES" (SIMPLE VERSION) ===';
SELECT 
    p.sku,
    p.name AS book_name,
    a.name AS author_name
FROM Product p
LEFT JOIN Product_Author pa ON p.sku = pa.product_sku
LEFT JOIN Author a ON pa.author_id = a.id
WHERE a.name LIKE '%james%' OR a.name LIKE '%James%' OR a.name LIKE '%JAMES%';
GO

PRINT '=== 6. KIỂM TRA AUTHOR CÓ TÊN CHỨA "JAMES" ===';
SELECT * FROM Author WHERE name LIKE '%james%' OR name LIKE '%James%' OR name LIKE '%JAMES%';
GO
