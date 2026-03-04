-- Script thêm tác giả cho các sách còn thiếu
USE [BOOK_STORE]
GO

-- Thêm thêm tác giả
INSERT [dbo].[Author] ([name], [bio]) VALUES (N'Unknown Author', N'Author information not available');
INSERT [dbo].[Author] ([name], [bio]) VALUES (N'Farrah Whisenhunt', N'Design and lifestyle author');
INSERT [dbo].[Author] ([name], [bio]) VALUES (N'Jared Campbell', N'Travel writer and photographer');
GO

-- Liên kết các sách với tác giả
-- BOOK02-BOOK07: James Gosling (để test tìm kiếm)
INSERT [dbo].[Product_Author] ([product_sku], [author_id]) VALUES (N'BOOK02', 1);
INSERT [dbo].[Product_Author] ([product_sku], [author_id]) VALUES (N'BOOK03', 1);
INSERT [dbo].[Product_Author] ([product_sku], [author_id]) VALUES (N'BOOK04', 1);
GO

-- BOOK05-BOOK10: Unknown Author
INSERT [dbo].[Product_Author] ([product_sku], [author_id]) VALUES (N'BOOK05', 3);
INSERT [dbo].[Product_Author] ([product_sku], [author_id]) VALUES (N'BOOK06', 3);
INSERT [dbo].[Product_Author] ([product_sku], [author_id]) VALUES (N'BOOK07', 3);
INSERT [dbo].[Product_Author] ([product_sku], [author_id]) VALUES (N'BOOK08', 3);
INSERT [dbo].[Product_Author] ([product_sku], [author_id]) VALUES (N'BOOK09', 3);
INSERT [dbo].[Product_Author] ([product_sku], [author_id]) VALUES (N'BOOK10', 3);
GO

-- BOOK12-BOOK17: Unknown Author
INSERT [dbo].[Product_Author] ([product_sku], [author_id]) VALUES (N'BOOK12', 3);
INSERT [dbo].[Product_Author] ([product_sku], [author_id]) VALUES (N'BOOK13', 3);
INSERT [dbo].[Product_Author] ([product_sku], [author_id]) VALUES (N'BOOK14', 3);
INSERT [dbo].[Product_Author] ([product_sku], [author_id]) VALUES (N'BOOK15', 3);
INSERT [dbo].[Product_Author] ([product_sku], [author_id]) VALUES (N'BOOK16', 3);
INSERT [dbo].[Product_Author] ([product_sku], [author_id]) VALUES (N'BOOK17', 3);
GO

-- BOOK18: Jared Campbell
INSERT [dbo].[Product_Author] ([product_sku], [author_id]) VALUES (N'BOOK18', 5);
GO

-- BOOK19-BOOK20: Unknown Author
INSERT [dbo].[Product_Author] ([product_sku], [author_id]) VALUES (N'BOOK19', 3);
INSERT [dbo].[Product_Author] ([product_sku], [author_id]) VALUES (N'BOOK20', 3);
GO

-- Kiểm tra kết quả
PRINT '=== All books with authors ===';
SELECT 
    p.sku,
    p.name AS book_name,
    a.name AS author_name
FROM Product p
INNER JOIN Product_Author pa ON p.sku = pa.product_sku
INNER JOIN Author a ON pa.author_id = a.id
ORDER BY p.sku;
GO

-- Test tìm kiếm "james"
PRINT '=== Search test for "james" ===';
SELECT 
    p.sku,
    p.name AS book_name,
    a.name AS author_name
FROM Product p
INNER JOIN Product_Author pa ON p.sku = pa.product_sku
INNER JOIN Author a ON pa.author_id = a.id
WHERE LOWER(a.name) LIKE '%james%';
GO

PRINT 'Done! Now you should find books by James Gosling: BOOK01, BOOK02, BOOK03, BOOK04';
GO
