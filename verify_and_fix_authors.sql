-- Script kiểm tra và sửa dữ liệu Author
USE [BOOK_STORE]
GO

PRINT '=== STEP 1: Check existing authors ===';
SELECT * FROM Author;
GO

PRINT '=== STEP 2: Check existing Product_Author links ===';
SELECT * FROM Product_Author ORDER BY product_sku;
GO

PRINT '=== STEP 3: Books WITHOUT authors ===';
SELECT p.sku, p.name
FROM Product p
LEFT JOIN Product_Author pa ON p.sku = pa.product_sku
WHERE pa.product_sku IS NULL;
GO

PRINT '=== STEP 4: Add missing authors (if not exist) ===';
-- Thêm tác giả nếu chưa có
IF NOT EXISTS (SELECT 1 FROM Author WHERE name = N'Unknown Author')
    INSERT [dbo].[Author] ([name], [bio]) VALUES (N'Unknown Author', N'Author information not available');

IF NOT EXISTS (SELECT 1 FROM Author WHERE name = N'Farrah Whisenhunt')
    INSERT [dbo].[Author] ([name], [bio]) VALUES (N'Farrah Whisenhunt', N'Design and lifestyle author');

IF NOT EXISTS (SELECT 1 FROM Author WHERE name = N'Jared Campbell')
    INSERT [dbo].[Author] ([name], [bio]) VALUES (N'Jared Campbell', N'Travel writer and photographer');
GO

PRINT '=== STEP 5: Add missing Product_Author links ===';
-- Thêm liên kết nếu chưa có
-- BOOK02-BOOK04: James Gosling
IF NOT EXISTS (SELECT 1 FROM Product_Author WHERE product_sku = N'BOOK02' AND author_id = 1)
    INSERT [dbo].[Product_Author] ([product_sku], [author_id]) VALUES (N'BOOK02', 1);

IF NOT EXISTS (SELECT 1 FROM Product_Author WHERE product_sku = N'BOOK03' AND author_id = 1)
    INSERT [dbo].[Product_Author] ([product_sku], [author_id]) VALUES (N'BOOK03', 1);

IF NOT EXISTS (SELECT 1 FROM Product_Author WHERE product_sku = N'BOOK04' AND author_id = 1)
    INSERT [dbo].[Product_Author] ([product_sku], [author_id]) VALUES (N'BOOK04', 1);

-- Get Unknown Author ID
DECLARE @unknownAuthorId INT;
SELECT @unknownAuthorId = id FROM Author WHERE name = N'Unknown Author';

-- BOOK05-BOOK10, BOOK12-BOOK17, BOOK19-BOOK20: Unknown Author
IF NOT EXISTS (SELECT 1 FROM Product_Author WHERE product_sku = N'BOOK05')
    INSERT [dbo].[Product_Author] ([product_sku], [author_id]) VALUES (N'BOOK05', @unknownAuthorId);

IF NOT EXISTS (SELECT 1 FROM Product_Author WHERE product_sku = N'BOOK06')
    INSERT [dbo].[Product_Author] ([product_sku], [author_id]) VALUES (N'BOOK06', @unknownAuthorId);

IF NOT EXISTS (SELECT 1 FROM Product_Author WHERE product_sku = N'BOOK07')
    INSERT [dbo].[Product_Author] ([product_sku], [author_id]) VALUES (N'BOOK07', @unknownAuthorId);

IF NOT EXISTS (SELECT 1 FROM Product_Author WHERE product_sku = N'BOOK08')
    INSERT [dbo].[Product_Author] ([product_sku], [author_id]) VALUES (N'BOOK08', @unknownAuthorId);

IF NOT EXISTS (SELECT 1 FROM Product_Author WHERE product_sku = N'BOOK09')
    INSERT [dbo].[Product_Author] ([product_sku], [author_id]) VALUES (N'BOOK09', @unknownAuthorId);

IF NOT EXISTS (SELECT 1 FROM Product_Author WHERE product_sku = N'BOOK10')
    INSERT [dbo].[Product_Author] ([product_sku], [author_id]) VALUES (N'BOOK10', @unknownAuthorId);

IF NOT EXISTS (SELECT 1 FROM Product_Author WHERE product_sku = N'BOOK12')
    INSERT [dbo].[Product_Author] ([product_sku], [author_id]) VALUES (N'BOOK12', @unknownAuthorId);

IF NOT EXISTS (SELECT 1 FROM Product_Author WHERE product_sku = N'BOOK13')
    INSERT [dbo].[Product_Author] ([product_sku], [author_id]) VALUES (N'BOOK13', @unknownAuthorId);

IF NOT EXISTS (SELECT 1 FROM Product_Author WHERE product_sku = N'BOOK14')
    INSERT [dbo].[Product_Author] ([product_sku], [author_id]) VALUES (N'BOOK14', @unknownAuthorId);

IF NOT EXISTS (SELECT 1 FROM Product_Author WHERE product_sku = N'BOOK15')
    INSERT [dbo].[Product_Author] ([product_sku], [author_id]) VALUES (N'BOOK15', @unknownAuthorId);

IF NOT EXISTS (SELECT 1 FROM Product_Author WHERE product_sku = N'BOOK16')
    INSERT [dbo].[Product_Author] ([product_sku], [author_id]) VALUES (N'BOOK16', @unknownAuthorId);

IF NOT EXISTS (SELECT 1 FROM Product_Author WHERE product_sku = N'BOOK17')
    INSERT [dbo].[Product_Author] ([product_sku], [author_id]) VALUES (N'BOOK17', @unknownAuthorId);

IF NOT EXISTS (SELECT 1 FROM Product_Author WHERE product_sku = N'BOOK19')
    INSERT [dbo].[Product_Author] ([product_sku], [author_id]) VALUES (N'BOOK19', @unknownAuthorId);

IF NOT EXISTS (SELECT 1 FROM Product_Author WHERE product_sku = N'BOOK20')
    INSERT [dbo].[Product_Author] ([product_sku], [author_id]) VALUES (N'BOOK20', @unknownAuthorId);

-- BOOK18: Jared Campbell
DECLARE @jaredId INT;
SELECT @jaredId = id FROM Author WHERE name = N'Jared Campbell';

IF NOT EXISTS (SELECT 1 FROM Product_Author WHERE product_sku = N'BOOK18')
    INSERT [dbo].[Product_Author] ([product_sku], [author_id]) VALUES (N'BOOK18', @jaredId);
GO

PRINT '=== STEP 6: Verify - All books with authors ===';
SELECT 
    p.sku,
    p.name AS book_name,
    a.name AS author_name
FROM Product p
INNER JOIN Product_Author pa ON p.sku = pa.product_sku
INNER JOIN Author a ON pa.author_id = a.id
ORDER BY p.sku;
GO

PRINT '=== STEP 7: Test search "james" ===';
SELECT 
    p.sku,
    p.name AS book_name,
    a.name AS author_name
FROM Product p
INNER JOIN Product_Author pa ON p.sku = pa.product_sku
INNER JOIN Author a ON pa.author_id = a.id
WHERE LOWER(a.name) LIKE '%james%';
GO

PRINT '✅ Done! You should now find 4 books by James Gosling: BOOK01, BOOK02, BOOK03, BOOK04';
GO
