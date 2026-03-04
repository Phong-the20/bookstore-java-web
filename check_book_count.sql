-- Kiểm tra số lượng sách trong database
USE [BOOK_STORE]
GO

PRINT '=== Tổng số sách trong database ===';
SELECT COUNT(*) AS total_books FROM Product;
GO

PRINT '=== Danh sách tất cả sách ===';
SELECT sku, name FROM Product ORDER BY sku;
GO

PRINT '=== Tính toán số trang (12 sách/trang) ===';
DECLARE @totalBooks INT;
SELECT @totalBooks = COUNT(*) FROM Product;
DECLARE @totalPages INT;
SET @totalPages = CEILING(@totalBooks / 12.0);
PRINT 'Total Books: ' + CAST(@totalBooks AS VARCHAR);
PRINT 'Total Pages: ' + CAST(@totalPages AS VARCHAR);
GO
