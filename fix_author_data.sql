-- Script để fix dữ liệu Author và Product_Author
USE [BOOK_STORE]
GO

-- Xóa dữ liệu cũ nếu có
DELETE FROM Product_Author;
DELETE FROM Author WHERE id > 2; -- Giữ lại 2 author có sẵn
GO

-- Thêm các tác giả mới
SET IDENTITY_INSERT [dbo].[Author] ON;
GO

INSERT [dbo].[Author] ([id], [name], [bio]) VALUES (1, N'James Gosling', N'Father of the Java language');
INSERT [dbo].[Author] ([id], [name], [bio]) VALUES (2, N'Rod Johnson', N'Creator of the Spring Framework');
INSERT [dbo].[Author] ([id], [name], [bio]) VALUES (3, N'Farrah Whisenhunt', N'Author of design books');
INSERT [dbo].[Author] ([id], [name], [bio]) VALUES (4, N'Unknown Author', N'Various authors');
GO

SET IDENTITY_INSERT [dbo].[Author] OFF;
GO

-- Liên kết sách với tác giả
INSERT [dbo].[Product_Author] ([product_sku], [author_id]) VALUES (N'BOOK01', 1); -- James Gosling
INSERT [dbo].[Product_Author] ([product_sku], [author_id]) VALUES (N'BOOK02', 1); -- James Gosling
INSERT [dbo].[Product_Author] ([product_sku], [author_id]) VALUES (N'BOOK03', 3); -- Farrah Whisenhunt
INSERT [dbo].[Product_Author] ([product_sku], [author_id]) VALUES (N'BOOK04', 1); -- James Gosling
INSERT [dbo].[Product_Author] ([product_sku], [author_id]) VALUES (N'BOOK05', 4); -- Unknown
INSERT [dbo].[Product_Author] ([product_sku], [author_id]) VALUES (N'BOOK06', 4); -- Unknown
INSERT [dbo].[Product_Author] ([product_sku], [author_id]) VALUES (N'BOOK07', 4); -- Unknown
INSERT [dbo].[Product_Author] ([product_sku], [author_id]) VALUES (N'BOOK08', 4); -- Unknown
INSERT [dbo].[Product_Author] ([product_sku], [author_id]) VALUES (N'BOOK09', 4); -- Unknown
INSERT [dbo].[Product_Author] ([product_sku], [author_id]) VALUES (N'BOOK10', 4); -- Unknown
INSERT [dbo].[Product_Author] ([product_sku], [author_id]) VALUES (N'BOOK11', 2); -- Rod Johnson
INSERT [dbo].[Product_Author] ([product_sku], [author_id]) VALUES (N'BOOK12', 4); -- Unknown
INSERT [dbo].[Product_Author] ([product_sku], [author_id]) VALUES (N'BOOK13', 4); -- Unknown
INSERT [dbo].[Product_Author] ([product_sku], [author_id]) VALUES (N'BOOK14', 4); -- Unknown
INSERT [dbo].[Product_Author] ([product_sku], [author_id]) VALUES (N'BOOK15', 4); -- Unknown
INSERT [dbo].[Product_Author] ([product_sku], [author_id]) VALUES (N'BOOK16', 4); -- Unknown
INSERT [dbo].[Product_Author] ([product_sku], [author_id]) VALUES (N'BOOK17', 4); -- Unknown
INSERT [dbo].[Product_Author] ([product_sku], [author_id]) VALUES (N'BOOK18', 1); -- James Gosling
INSERT [dbo].[Product_Author] ([product_sku], [author_id]) VALUES (N'BOOK19', 4); -- Unknown
INSERT [dbo].[Product_Author] ([product_sku], [author_id]) VALUES (N'BOOK20', 4); -- Unknown
GO

-- Kiểm tra kết quả
SELECT 
    p.sku,
    p.name AS book_name,
    a.name AS author_name
FROM Product p
LEFT JOIN Product_Author pa ON p.sku = pa.product_sku
LEFT JOIN Author a ON pa.author_id = a.id
ORDER BY p.sku;
GO

PRINT 'Author data fixed successfully!';
GO
