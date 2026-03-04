USE [master]
GO

-- Drop database if exists (optional, for clean restart)
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'BOOK_STORE')
DROP DATABASE [BOOK_STORE];
GO

/****** Object:  Database [BOOK_STORE]    Script Date: 10/13/2025 ******/
CREATE DATABASE [BOOK_STORE]
 CONTAINMENT = NONE
  ON  PRIMARY 
( NAME = N'BOOK_STORE', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\BOOK_STORE.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'BOOK_STORE_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\BOOK_STORE_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [BOOK_STORE] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [BOOK_STORE].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [BOOK_STORE] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [BOOK_STORE] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [BOOK_STORE] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [BOOK_STORE] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [BOOK_STORE] SET ARITHABORT OFF 
GO
ALTER DATABASE [BOOK_STORE] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [BOOK_STORE] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [BOOK_STORE] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [BOOK_STORE] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [BOOK_STORE] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [BOOK_STORE] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [BOOK_STORE] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [BOOK_STORE] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [BOOK_STORE] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [BOOK_STORE] SET  DISABLE_BROKER 
GO
ALTER DATABASE [BOOK_STORE] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [BOOK_STORE] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [BOOK_STORE] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [BOOK_STORE] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [BOOK_STORE] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [BOOK_STORE] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [BOOK_STORE] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [BOOK_STORE] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [BOOK_STORE] SET  MULTI_USER 
GO
ALTER DATABASE [BOOK_STORE] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [BOOK_STORE] SET DB_CHAINING OFF 
GO
ALTER DATABASE [BOOK_STORE] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [BOOK_STORE] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [BOOK_STORE] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [BOOK_STORE] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [BOOK_STORE] SET QUERY_STORE = OFF
GO
USE [BOOK_STORE]
GO
/****** Object:  Table [dbo].[Registration]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Registration](
	[id] [int] IDENTITY(1,1) NOT NULL, -- primary key
	[full_name] [nvarchar](100) NOT NULL,
	[username] [varchar](20) NOT NULL,
	[password] [varchar](64) NOT NULL,
	[email] [varchar](100) NULL,
	[isAdmin] [bit] NOT NULL,
	[address] [nvarchar](400) NULL, -- added address column
 CONSTRAINT [PK_Registration] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Add unique constraint on username
ALTER TABLE [dbo].[Registration] ADD CONSTRAINT [UQ_Registration_username] UNIQUE ([username]);
GO
/****** Object:  Table [dbo].[OrderDetails]    Script Date: 12/12/2022 7:07:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderDetails](
	[id] [int] IDENTITY(1,1) NOT NULL, -- primary key
	[sku] [varchar](10) NOT NULL,
	[order_id] [int] NOT NULL,
	[price] [float] NOT NULL,
	[quantity] [int] NOT NULL,
	[total] [float] NOT NULL,
 CONSTRAINT [PK_OrderDetails] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Orders]    Script Date: 12/12/2022 7:07:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders](
    [id] [int] IDENTITY(1,1) NOT NULL,
    [dateBuy] [datetime] NOT NULL,
    [total] [float] NULL,
    [name] [nvarchar](32) NULL,
    [phone] [varchar](20) NULL,
    [address] [nvarchar](400) NULL,
    [username] [varchar](20) NULL,
    [status] [nvarchar](50) NULL DEFAULT N'Chờ xác nhận',
    [updated_at] [datetime] NULL DEFAULT GETDATE(),
    [cancel_reason] [nvarchar](500) NULL,
    [return_status] [nvarchar](50) NULL,
 CONSTRAINT [PK_Order] PRIMARY KEY CLUSTERED 
(
    [id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Product]    Script Date: 12/12/2022 7:07:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Product](-- admin
	[sku] [varchar](10) NOT NULL,-- primary key
	[name] [nvarchar](50) NOT NULL,
	[description] [nvarchar](250) NULL,
	[quantity] [int] NOT NULL,
	[price] [float] NOT NULL, -- tiền đô
	[img] [varchar](255) NULL,
	[status] [bit] NOT NULL,
	[category_id] [int] NULL,
	[publisher_id] [int] NULL,
 CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED 
(
	[sku] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO




-- Thêm bảng Category
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Category](
	[id] [int] IDENTITY(1,1) NOT NULL, -- primary key
	[name] [nvarchar](50) NOT NULL,
    [created_at] [DATETIME] NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    [updated_at] [DATETIME]  NULL DEFAULT CAST(GETDATE() AS DATE),
 CONSTRAINT [PK_Category] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
-- Thêm bảng Author
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Author](
	[id] [int] IDENTITY(1,1) NOT NULL, -- primary key
	[name] [nvarchar](100) NOT NULL,
	[bio] [nvarchar](500) NULL,
 CONSTRAINT [PK_Author] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
-- Bảng liên kết Product_Author (nhiều-nhiều)
CREATE TABLE [dbo].[Product_Author]( -- chưa hiểu lắm
	[product_sku] [varchar](10) NOT NULL,
	[author_id] [int] NOT NULL,
 CONSTRAINT [PK_Product_Author] PRIMARY KEY CLUSTERED 
(
	[product_sku] ASC,
	[author_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
-- Thêm bảng Publisher
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Publisher]( -- nhà xuất bản
	[id] [int] IDENTITY(1,1) NOT NULL, -- primary key
	[name] [nvarchar](100) NOT NULL,
	[address] [nvarchar](200) NULL,
 CONSTRAINT [PK_Publisher] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
-- Thêm bảng Review
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Review](
	[id] [int] IDENTITY(1,1) NOT NULL, -- primary key
	[product_sku] [varchar](10) NOT NULL,
	[username] [varchar](20) NOT NULL,
	[rating] [int] NOT NULL CHECK ([rating] BETWEEN 1 AND 5),
	[comment] [nvarchar](500) NULL,
	[created_date] [datetime] DEFAULT GETDATE(),
 CONSTRAINT [PK_Review] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
-- Thêm bảng Promotion
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Promotion](
	[id] [int] IDENTITY(1,1) NOT NULL, -- primary key
	[code] [varchar](20) NOT NULL UNIQUE,  -- Mã khuyến mãi
	[discount_percent] [float] NOT NULL,  -- Phần trăm giảm
	[start_date] [datetime] NOT NULL,
	[end_date] [datetime] NOT NULL,
	[description] [nvarchar](250) NULL,
	[status] [bit] NOT NULL DEFAULT 1,  -- 1: active, 0: inactive
 CONSTRAINT [PK_Promotion] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
-- Insert dữ liệu mẫu cho registration (updated with address directly)
INSERT [dbo].[Registration] ([full_name], [username], [password], [email], [isAdmin], [address]) VALUES (N'Administrator', N'administrator', N'984afce66eeeecb03a1d14201a695683', N'administrator@gmail.com', 1, N'USA')
GO
INSERT [dbo].[Registration] ([full_name], [username], [password], [email], [isAdmin], [address]) VALUES (N'Duy Duc', N'duyduc', N'9a63b17805ab754ba47b773a159b2087', N'duyduc@gmail.com', 0, N'UK')
GO
INSERT [dbo].[Registration] ([full_name], [username], [password], [email], [isAdmin], [address]) VALUES (N'Gia Linh', N'gialinh', N'9ca1ce29a1fb17f9f0335498eb7b0a8c', N'gialinh@gmail.com', 0, N'Canada')
GO
INSERT [dbo].[Registration] ([full_name], [username], [password], [email], [isAdmin], [address]) VALUES (N'Ha Anh', N'haanhh', N'd5ebb32d8fe46d32912c0a1fe52398cd', N'haanhh@gmail.com', 0, N'Australia')
GO
INSERT [dbo].[Registration] ([full_name], [username], [password], [email], [isAdmin], [address]) VALUES (N'Ha Thanh', N'hathanh', N'a835b4a335fb5c68da05c3348fb3f7a3', N'hathanh@gmail.com', 0, N'France')
GO
INSERT [dbo].[Registration] ([full_name], [username], [password], [email], [isAdmin], [address]) VALUES (N'Khanh Tieu Nhi', N'khanhkk', N'bf9868da35a7d0d1a5e57599d4ffc243', N'khanhkk@gmail.com', 0, N'Germany')
GO
INSERT [dbo].[Registration] ([full_name], [username], [password], [email], [isAdmin], [address]) VALUES (N'Khanh Dai Ca', N'khanhkt', N'902292a66ce39bcbaa2252bd83eef86a', N'khanhkt@gmail.com', 1, N'Japan')
GO
INSERT [dbo].[Registration] ([full_name], [username], [password], [email], [isAdmin], [address]) VALUES (N'Lan Anh Nguyen', N'lananh', N'444a959eccae1d564cad3adb5e8593a2', N'lananh@gmail.com', 0, N'Spain')
GO
INSERT [dbo].[Registration] ([full_name], [username], [password], [email], [isAdmin], [address]) VALUES (N'La Phuong Anh', N'laphuonganh', N'afc76803994314558683ef2740b240d2', N'laphuonganh@gmail.com', 0, N'Italy')
GO
INSERT [dbo].[Registration] ([full_name], [username], [password], [email], [isAdmin], [address]) VALUES (N'Linh Nguyen', N'linhnguyen', N'3590d4cbb8316b5ad7c0a49516cdbe8b', N'linhnguyen@gmail.com', 0, N'Netherlands')
GO
INSERT [dbo].[Registration] ([full_name], [username], [password], [email], [isAdmin], [address]) VALUES (N'Mia Nguyen', N'maianh', N'6c56872c574873b738ab0ce90bf1f08b', N'maianh@gmail.com', 0, N'Sweden')
GO
INSERT [dbo].[Registration] ([full_name], [username], [password], [email], [isAdmin], [address]) VALUES (N'Minh Anh', N'minhanh', N'955453d8734955894266d3d37e737851', N'minhanh@gmail.com', 0, N'Austria')
GO
INSERT [dbo].[Registration] ([full_name], [username], [password], [email], [isAdmin], [address]) VALUES (N'Minh Thy', N'minhthy', N'f9cc717c833859ba5ab973a3486016c7', N'minhthy@gmail.com', 0, N'Switzerland')
GO
INSERT [dbo].[Registration] ([full_name], [username], [password], [email], [isAdmin], [address]) VALUES (N'The Anh', N'theanh', N'0fccec7e3d852c9586c4ea0e24327d52', N'theanh@gmail.com', 0, N'Ireland')
GO
INSERT [dbo].[Registration] ([full_name], [username], [password], [email], [isAdmin], [address]) VALUES (N'Thien Minh', N'thienminh', N'a5bfb3d2ddc4ba1f367395536defd136', N'thienminh@gmail.com', 0, N'Denmark')
GO
INSERT [dbo].[Registration] ([full_name], [username], [password], [email], [isAdmin], [address]) VALUES (N'Tue Anh', N'tueanh', N'86a866117a321a14ee9ac1f37badddee', N'tueanh@gmail.com', 1, N'Finland')
GO
INSERT [dbo].[Registration] ([full_name], [username], [password], [email], [isAdmin], [address]) VALUES (N'Tue Minh', N'tueminh', N'2c661231f5750c6f126be4f45bbbda2a', N'tueminh@gmail.com', 0, N'Norway')
GO




SET IDENTITY_INSERT [dbo].[Orders] ON 
GO
INSERT [dbo].[Orders] ([id], [dateBuy], [total], [name], [phone], [address], [username]) 
VALUES 
(114, CAST(N'2022-12-12T19:03:05.347' AS DateTime), 1, N'Administrator', N'0934968395', N'HCM.C, Vietnam', N'administrator'),
(115, CAST(N'2022-12-12T19:04:09.177' AS DateTime), 0, N'Duy Duc', N'09349686986', N'HCM.C, Vietnam', N'duyduc'),
(116, CAST(N'2023-01-10T09:45:22.000' AS DateTime), 2, N'Gia Linh', N'0912345678', N'Hanoi, Vietnam', N'gialinh'),
(117, CAST(N'2023-02-02T14:30:00.000' AS DateTime), 1, N'Ha Anh', N'0987654321', N'Hue, Vietnam', N'haanhh'),
(118, CAST(N'2023-03-15T08:00:00.000' AS DateTime), 0, N'Ha Thanh', N'0978123456', N'Da Nang, Vietnam', N'hathanh'),
(119, CAST(N'2023-04-01T17:12:00.000' AS DateTime), 8, N'Khanh Tieu Nhi', N'0909888777', N'Berlin, Germany', N'khanhkk'),
(120, CAST(N'2023-05-10T10:20:00.000' AS DateTime), 0, N'Khanh Dai Ca', N'0911999333', N'Tokyo, Japan', N'khanhkt'),
(121, CAST(N'2023-06-06T11:15:00.000' AS DateTime), 5, N'Lan Anh Nguyen', N'0933000111', N'Madrid, Spain', N'lananh'),
(122, CAST(N'2023-07-22T09:25:00.000' AS DateTime), 0, N'La Phuong Anh', N'0909111222', N'Rome, Italy', N'laphuonganh'),
(123, CAST(N'2023-08-01T13:30:00.000' AS DateTime), 0, N'Linh Nguyen', N'0977888999', N'Amsterdam, Netherlands', N'linhnguyen'),
(124, CAST(N'2023-09-09T18:00:00.000' AS DateTime), 0, N'Mia Nguyen', N'0911222333', N'Stockholm, Sweden', N'maianh'),
(125, CAST(N'2023-10-10T07:45:00.000' AS DateTime), 0, N'Minh Anh', N'0966554433', N'Vienna, Austria', N'minhanh'),
(126, CAST(N'2023-11-20T20:00:00.000' AS DateTime), 0, N'Minh Thy', N'0909777666', N'Zurich, Switzerland', N'minhthy'),
(127, CAST(N'2023-12-24T09:00:00.000' AS DateTime), 0, N'The Anh', N'0909777555', N'Dublin, Ireland', N'theanh'),
(128, CAST(N'2024-01-15T10:00:00.000' AS DateTime), 0, N'Thien Minh', N'0933666777', N'Copenhagen, Denmark', N'thienminh'),
(129, CAST(N'2024-02-14T08:00:00.000' AS DateTime), 0, N'Tue Anh', N'0988222111', N'Helsinki, Finland', N'tueanh'),
(130, CAST(N'2024-03-05T19:30:00.000' AS DateTime), 0, N'Tue Minh', N'0933999444', N'Oslo, Norway', N'tueminh');
GO

SET IDENTITY_INSERT [dbo].[Orders] OFF
GO

GO
SET IDENTITY_INSERT [dbo].[OrderDetails] ON 
GO
INSERT [dbo].[OrderDetails] ([id], [sku], [order_id], [price], [quantity], [total]) VALUES (150, N'BOOK04', 114, 7, 1, 7)
GO
INSERT [dbo].[OrderDetails] ([id], [sku], [order_id], [price], [quantity], [total]) VALUES (151, N'BOOK02', 114, 10, 1, 10)
GO
INSERT [dbo].[OrderDetails] ([id], [sku], [order_id], [price], [quantity], [total]) VALUES (152, N'BOOK01', 115, 12, 1, 12)
GO
SET IDENTITY_INSERT [dbo].[OrderDetails] OFF
GO
SET IDENTITY_INSERT [dbo].[Orders] ON 
GO
SET IDENTITY_INSERT [dbo].[Orders] OFF
GO

GO
INSERT [dbo].[Product] ([sku], [name], [description], [quantity], [price], [img], [status], [category_id], [publisher_id]) VALUES (N'BOOK01', N'Social Book', N'Exploring social dynamics in modern society', 100, 12, N'https://product.hstatic.net/1000266609/product/img-01_2__large.jpg', 1, 1, NULL)
GO
INSERT [dbo].[Product] ([sku], [name], [description], [quantity], [price], [img], [status], [category_id], [publisher_id]) VALUES (N'BOOK02', N'Screen Book', N'A guide to digital screens and their daily impact', 90, 10, N'https://product.hstatic.net/1000266609/product/img-02_1_.jpg', 1, 1, NULL)
GO
INSERT [dbo].[Product] ([sku], [name], [description], [quantity], [price], [img], [status], [category_id], [publisher_id]) VALUES (N'BOOK03', N'The Forbidden Ascent', N'An adventurous climb to uncharted peaks', 35, 7, N'https://bookcoverhub.com/wp-content/uploads/elementor/thumbs/Minimalist-Book-Book-Cover-Ebook-Cover-paperback-hardcover-Amazon-KDP-Kindle-cover-Book-Cover-hub-Book-Cover-Artist-Book-Cover-designer-4-qs9x8lx1630kttkkxrv1911tv45umx4c5g6lfx0bvs.jpg', 1, 1, NULL)
GO
INSERT [dbo].[Product] ([sku], [name], [description], [quantity], [price], [img], [status], [category_id], [publisher_id]) VALUES (N'BOOK04', N'Electric Book', N'Technology-driven tales of electric dreams', 81, 7, N'https://product.hstatic.net/1000266609/product/img-03_1__large.jpg', 1, 1, NULL)
GO
INSERT [dbo].[Product] ([sku], [name], [description], [quantity], [price], [img], [status], [category_id], [publisher_id]) VALUES (N'BOOK05', N'Black Eco Book', N'Shadows of ecological crises and solutions', 89, 10, N'https://product.hstatic.net/1000266609/product/img-12_4a6c1c0877b4411fb96704c04a40cee2.jpg', 1, 1, NULL)
GO
INSERT [dbo].[Product] ([sku], [name], [description], [quantity], [price], [img], [status], [category_id], [publisher_id]) VALUES (N'BOOK06', N'Mill Book', N'Industrial heritage and mill stories', 94, 10, N'https://product.hstatic.net/1000266609/product/img-11_large.jpg', 1, 1, NULL)
GO
INSERT [dbo].[Product] ([sku], [name], [description], [quantity], [price], [img], [status], [category_id], [publisher_id]) VALUES (N'BOOK07', N'Yellow Eco Book', N'Bright paths to sustainable green living', 90, 12, N'https://product.hstatic.net/1000266609/product/img-06_234c18b0f0ba4a159a53542d1868b9dc.jpg', 1, 1, NULL)
GO
INSERT [dbo].[Product] ([sku], [name], [description], [quantity], [price], [img], [status], [category_id], [publisher_id]) VALUES (N'BOOK08', N'Notes Book', N'Personal reflections and life notes', 10, 11, N'https://product.hstatic.net/1000266609/product/img-07.jpg', 1, 2, NULL)
GO
INSERT [dbo].[Product] ([sku], [name], [description], [quantity], [price], [img], [status], [category_id], [publisher_id]) VALUES (N'BOOK09', N'Paper Book', N'Art and history of paper in culture', 2, 13, N'https://product.hstatic.net/1000266609/product/img-09_1024x1024.jpg', 0, 2, NULL)
GO
INSERT [dbo].[Product] ([sku], [name], [description], [quantity], [price], [img], [status], [category_id], [publisher_id]) VALUES (N'BOOK10', N'Photo Book', N'Visual stories through photography', 5, 45, N'https://product.hstatic.net/1000266609/product/img-08_7832bcc109ad4efe9a1d21b379668346_1024x1024.jpg', 1, 2, NULL)
GO
INSERT [dbo].[Product] ([sku], [name], [description], [quantity], [price], [img], [status], [category_id], [publisher_id]) VALUES (N'BOOK11', N'Yeu tren tung ngon tay', N'Love through subtle gestures', 0, 55, N'https://inthienhang.com/wp-content/uploads/2020/03/mau-bia-sach-dep.jpg', 1, 2, NULL)
GO
INSERT [dbo].[Product] ([sku], [name], [description], [quantity], [price], [img], [status], [category_id], [publisher_id]) VALUES (N'BOOK12', N'The Sun, the Moon, the Stars', N'Poetic journey through celestial emotions', 50, 25, N'https://hpconnect.vn/wp-content/uploads/2019/08/tam-quan-trong-cua-viec-thiet-ke-bia-sach-dep.jpg', 1, 2, NULL)
GO
INSERT [dbo].[Product] ([sku], [name], [description], [quantity], [price], [img], [status], [category_id], [publisher_id]) VALUES (N'BOOK13', N'De men phieu luu ky', N'The adventurous chronicle of a little goat', 30, 20, N'https://thanhnien.mediacdn.vn/Uploaded/minhnguyet/2022_05_08/bia-sach2-9886.jpg', 1, 2, NULL)
GO
INSERT [dbo].[Product] ([sku], [name], [description], [quantity], [price], [img], [status], [category_id], [publisher_id]) VALUES (N'BOOK14', N'Finance basics', N'Essential guide to personal finance fundamentals', 40, 35, N'https://marketplace.canva.com/EAFbWl4xunQ/2/0/1024w/canva-neutral-minimalist-aesthetic-finance-basics-for-women-guide-ebook-cover-NLo1dMhwsSw.jpg', 1, 2, NULL)
GO
INSERT [dbo].[Product] ([sku], [name], [description], [quantity], [price], [img], [status], [category_id], [publisher_id]) VALUES (N'BOOK15', N'How to sell your art online', N'Strategies for artists to sell digitally', 60, 15, N'https://marketplace.canva.com/EAGgJtub4zU/1/0/1024w/canva-beige-brown-how-to-sell-online-marketing-ebook-cover-5HjEYEkFD6E.jpg', 1, 2, NULL)
GO
INSERT [dbo].[Product] ([sku], [name], [description], [quantity], [price], [img], [status], [category_id], [publisher_id]) VALUES (N'BOOK16', N'Beautiful and Beloved', N'Heartwarming tales of enduring love', 20, 30, N'https://bookcoverzone.com/slir/w400/png24-front/bookcover0050045.jpg', 1, 3, NULL)
GO
INSERT [dbo].[Product] ([sku], [name], [description], [quantity], [price], [img], [status], [category_id], [publisher_id]) VALUES (N'BOOK17', N'Dreams in the autumn', N'Reflective dreams of fall memories', 80, 18, N'https://bookcoverzone.com/slir/w400/png24-front/bookcover0009742.jpg', 1, 2, NULL)
GO
INSERT [dbo].[Product] ([sku], [name], [description], [quantity], [price], [img], [status], [category_id], [publisher_id]) VALUES (N'BOOK18', N'Jared campbell a visit to berlin', N'Jared Campbell''s Berlin journey account', 90, 12, N'https://bookcoverzone.com/slir/w400/png24-front/bookcover0005471.jpg', 1, 2, NULL)
GO
INSERT [dbo].[Product] ([sku], [name], [description], [quantity], [price], [img], [status], [category_id], [publisher_id]) VALUES (N'BOOK19', N'Vong Ngu', N'Labyrinth of loops and mysteries', 10, 22, N'https://www.izi-book.com/_next/image?url=%2Fassets%2Fimages%2Fcovers%2Fd165a0e1e9b32e5a8e3a7102465a5c65.jpg&w=3840&q=75', 0, 2, NULL)
GO
INSERT [dbo].[Product] ([sku], [name], [description], [quantity], [price], [img], [status], [category_id], [publisher_id]) VALUES (N'BOOK20', N'Love in the time', N'Timeless romance across eras', 5, 28, N'https://bloganchoi.com/wp-content/uploads/2019/05/bia-love-in-the-time-of-cholera-696x1139.jpg', 1, 2, NULL)
GO
-- Insert sample data for Category
INSERT [dbo].[Category] ([name],[created_at],[updated_at]) VALUES (N'Java Programming',CAST(GETDATE() AS DATE),null);
INSERT [dbo].[Category] ([name],[created_at],[updated_at]) VALUES (N'Web Development',CAST(GETDATE() AS DATE),null);
INSERT [dbo].[Category] ([name],[created_at],[updated_at]) VALUES (N'Design Patterns', CAST(GETDATE() AS DATE),null);
GO
-- Insert sample data for Author
INSERT [dbo].[Author] ([name], [bio]) VALUES (N'James Gosling', N'Father of the Java language');
INSERT [dbo].[Author] ([name], [bio]) VALUES (N'Rod Johnson', N'Creator of the Spring Framework');
GO
-- Insert liên kết mẫu cho Product_Author
INSERT [dbo].[Product_Author] ([product_sku], [author_id]) VALUES (N'BOOK01', 1);
INSERT [dbo].[Product_Author] ([product_sku], [author_id]) VALUES (N'BOOK11', 2);
GO
-- Insert dữ liệu mẫu cho Publisher
INSERT [dbo].[Publisher] ([name], [address]) VALUES (N'O''Reilly Media', N'Sebastopol, CA, USA');
INSERT [dbo].[Publisher] ([name], [address]) VALUES (N'Prentice Hall', N'Upper Saddle River, NJ, USA');
GO
-- Insert sample data for Review
INSERT [dbo].[Review] ([product_sku], [username], [rating], [comment]) VALUES (N'BOOK01', N'duyduc', 5, N'Good book, easy to understand!');
GO
INSERT [dbo].[Review] ([product_sku], [username], [rating], [comment]) VALUES (N'BOOK01', N'gialinh', 5, N'Good book, easy to understand!');
GO
INSERT [dbo].[Review] ([product_sku], [username], [rating], [comment]) VALUES (N'BOOK02', N'gialinh', 4, N'Helpful for beginners in web dev.');
GO
INSERT [dbo].[Review] ([product_sku], [username], [rating], [comment]) VALUES (N'BOOK03', N'haanhh', 3, N'Solid intro, but could be more examples.');
GO
INSERT [dbo].[Review] ([product_sku], [username], [rating], [comment]) VALUES (N'BOOK11', N'hathanh', 5, N'Beautiful romance, highly recommend!');
GO
INSERT [dbo].[Review] ([product_sku], [username], [rating], [comment]) VALUES (N'BOOK14', N'khanhkk', 4, N'Clear basics for finance newbies.');
GO
-- Insert sample data for Promotion
INSERT [dbo].[Promotion] ([code], [discount_percent], [start_date], [end_date], [description]) VALUES (N'DISCOUNT10', 10, '2025-10-01', '2025-12-31', N'10% off Java books');
GO
INSERT [dbo].[Promotion] ([code], [discount_percent], [start_date], [end_date], [description]) VALUES (N'WEBDEAL20', 20, '2025-11-01', '2025-11-30', N'20% discount on web development titles');
GO
INSERT [dbo].[Promotion] ([code], [discount_percent], [start_date], [end_date], [description]) VALUES (N'PATTERNS15', 15, '2025-10-15', '2025-11-15', N'15% off design patterns books');
GO
INSERT [dbo].[Promotion] ([code], [discount_percent], [start_date], [end_date], [description]) VALUES (N'ROMANCE25', 25, '2025-12-01', '2025-12-25', N'25% off romance novels for holidays');
GO


--trigger trong ngày cập nhật category
CREATE OR ALTER TRIGGER trg_Category_UpdateTime
ON Category
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Category
    SET updated_at = CAST(GETDATE() AS DATE)
    WHERE id IN (SELECT DISTINCT id FROM inserted);
END;
go

-- Cập nhật category_id cho các sản phẩm hiện có (ví dụ)
UPDATE [dbo].[Product] SET [category_id] = 1 WHERE [sku] IN (N'BOOK01', N'BOOK02', N'BOOK03', N'BOOK04', N'BOOK05', N'BOOK06', N'BOOK07');
UPDATE [dbo].[Product] SET [category_id] = 2 WHERE [sku] IN (N'BOOK08', N'BOOK09', N'BOOK10', N'BOOK11');
UPDATE [dbo].[Product] SET [category_id] = 3 WHERE [sku] IN (N'BOOK16');
GO
-- Cập nhật publisher_id cho các sản phẩm hiện có (ví dụ)
UPDATE [dbo].[Product] SET [publisher_id] = 1 WHERE [sku] IN (N'BOOK01', N'BOOK02');
UPDATE [dbo].[Product] SET [publisher_id] = 2 WHERE [sku] IN (N'BOOK11');
GO
ALTER TABLE [dbo].[OrderDetails]  WITH CHECK ADD  CONSTRAINT [FK_OrderDetails_Order] FOREIGN KEY([order_id])
REFERENCES [dbo].[Orders] ([id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[OrderDetails] CHECK CONSTRAINT [FK_OrderDetails_Order]
GO
ALTER TABLE [dbo].[OrderDetails]  WITH CHECK ADD  CONSTRAINT [FK_OrderDetails_Product] FOREIGN KEY([sku])
REFERENCES [dbo].[Product] ([sku])
GO
ALTER TABLE [dbo].[OrderDetails] CHECK CONSTRAINT [FK_OrderDetails_Product]
GO

-- Thêm FK cho Product - Category
ALTER TABLE [dbo].[Product]  WITH CHECK ADD  CONSTRAINT [FK_Product_Category] FOREIGN KEY([category_id])
REFERENCES [dbo].[Category] ([id])
GO
ALTER TABLE [dbo].[Product] CHECK CONSTRAINT [FK_Product_Category]
GO
-- FK cho Product_Author
ALTER TABLE [dbo].[Product_Author]  WITH CHECK ADD  CONSTRAINT [FK_Product_Author_Product] FOREIGN KEY([product_sku])
REFERENCES [dbo].[Product] ([sku])
GO
ALTER TABLE [dbo].[Product_Author] CHECK CONSTRAINT [FK_Product_Author_Product]
GO
ALTER TABLE [dbo].[Product_Author]  WITH CHECK ADD  CONSTRAINT [FK_Product_Author_Author] FOREIGN KEY([author_id])
REFERENCES [dbo].[Author] ([id])
GO
ALTER TABLE [dbo].[Product_Author] CHECK CONSTRAINT [FK_Product_Author_Author]
GO
-- Thêm FK cho Product - Publisher
ALTER TABLE [dbo].[Product]  WITH CHECK ADD  CONSTRAINT [FK_Product_Publisher] FOREIGN KEY([publisher_id])
REFERENCES [dbo].[Publisher] ([id])
GO
ALTER TABLE [dbo].[Product] CHECK CONSTRAINT [FK_Product_Publisher]
GO
-- FK cho Review
ALTER TABLE [dbo].[Review]  WITH CHECK ADD  CONSTRAINT [FK_Review_Product] FOREIGN KEY([product_sku])
REFERENCES [dbo].[Product] ([sku])
GO
ALTER TABLE [dbo].[Review] CHECK CONSTRAINT [FK_Review_Product]
GO
ALTER TABLE [dbo].[Review]  WITH CHECK ADD  CONSTRAINT [FK_Review_Registration] FOREIGN KEY([username])
REFERENCES [dbo].[Registration] ([username])
GO
ALTER TABLE [dbo].[Review] CHECK CONSTRAINT [FK_Review_Registration]
GO


ALTER DATABASE [BOOK_STORE] SET  READ_WRITE 
GO

------------------------------------------Phuoc --------------------------------------------------------------------------------
-- Thêm bảng ProductDetail (chứa chi tiết sách)
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[productDetail](
    [id] INT IDENTITY(1,1) NOT NULL, -- Khóa chính
    [product_sku] VARCHAR(10) NOT NULL, -- Khóa ngoại đến Product
    [book_name] NVARCHAR(200) NULL, -- Tên sách đầy đủ
    [format] NVARCHAR(50) NULL, -- Loại bìa: Paperback / Hardcover / Ebook
    [pages] INT NULL, -- Số trang
    [dimensions] NVARCHAR(50) NULL, -- Kích thước (vd: 15x20 cm)
    [publication_date] DATE NULL, -- Ngày xuất bản

 CONSTRAINT [PK_productDetail] PRIMARY KEY CLUSTERED 
(
    [id] ASC
) WITH (
    PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF,
    IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON,
    ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Thêm khóa ngoại liên kết với bảng Product
ALTER TABLE [dbo].[productDetail] WITH CHECK 
ADD CONSTRAINT [FK_productDetail_Product] FOREIGN KEY([product_sku])
REFERENCES [dbo].[Product] ([sku])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[productDetail] CHECK CONSTRAINT [FK_productDetail_Product]
GO

INSERT INTO [dbo].[productDetail]
    ([product_sku], [book_name], [format], [pages], [dimensions], [publication_date])
VALUES
(N'BOOK01', N'Social Book: Exploring Social Dynamics', N'Paperback', 320, N'15 x 23 cm', '2022-05-10'),
(N'BOOK02',  N'Screen Book: Digital Screens and Daily Impact', N'Hardcover', 280, N'14 x 21 cm', '2021-09-15'),
(N'BOOK03', N'The Forbidden Ascent', N'Paperback', 250, N'13 x 20 cm', '2020-12-01'),
(N'BOOK04',   N'Electric Book: Stories of Electric Dreams', N'Ebook', 180, N'N/A', '2023-03-20'),
(N'BOOK05',   N'Black Eco Book: Ecology and Sustainability', N'Paperback', 340, N'16 x 24 cm', '2022-08-25');
GO
---------------------------------- Phuoc cart--------------------------------------------
CREATE TABLE [dbo].[Cart] (
    [id] INT IDENTITY(1,1) PRIMARY KEY,
    [username] VARCHAR(20) NOT NULL,
    [created_date] DATETIME DEFAULT GETDATE(),
    [updated_date] DATETIME NULL,

    CONSTRAINT [FK_Cart_Registration] FOREIGN KEY ([username])
        REFERENCES [dbo].[Registration]([username])
        ON DELETE CASCADE
);

CREATE TABLE [dbo].[CartItem] (
    [id] INT IDENTITY(1,1) PRIMARY KEY,
    [cart_id] INT NOT NULL,
    [product_sku] VARCHAR(10) NOT NULL,
    [quantity] INT NOT NULL CHECK ([quantity] > 0),

    CONSTRAINT [UQ_CartItem_Cart_Product] UNIQUE ([cart_id], [product_sku]),

    CONSTRAINT [FK_CartItem_Cart] FOREIGN KEY ([cart_id])
        REFERENCES [dbo].[Cart]([id])
        ON DELETE CASCADE,

    CONSTRAINT [FK_CartItem_Product] FOREIGN KEY ([product_sku])
        REFERENCES [dbo].[Product]([sku])
        ON DELETE CASCADE
);

INSERT INTO Cart (username)
VALUES ('duyduc');  -- tên user đã có trong bảng Registration
INSERT INTO CartItem (cart_id, product_sku, quantity)
VALUES 
    (1, 'BOOK01', 2),  -- Sách BOOK01, số lượng 2
    (1, 'BOOK03', 1),  -- Sách BOOK03, số lượng 1
    (1, 'BOOK07', 3);  -- Sách BOOK07, số lượng 3

	ALTER TABLE [dbo].[Product]
ADD [language] NVARCHAR(50) NULL;
GO

UPDATE [dbo].[Product]
SET [language] = N'English'
WHERE [sku] IN ('BOOK01', 'BOOK02', 'BOOK03', 'BOOK04', 'BOOK05');

UPDATE [dbo].[Product]
SET [language] = N'Vietnamese'
WHERE [sku] IN ('BOOK13', 'BOOK19', 'BOOK20');
	---------------------------------------------------------------------------------------------------------------------------
	---------------------------------Tinh lol----------------------------------------------------------------
	ALTER TABLE product
ADD created_product date;
---------------------------------------------------------------------------------------------------------------------------------
-------------------------TDat----------------------------
--Thêm bảng nhiều nhiều để quản lý mã giảm giá
CREATE TABLE UserPromotion (
    username VARCHAR(20),
    promotion_id INT,
    PRIMARY KEY (username, promotion_id),
    FOREIGN KEY (username) REFERENCES Registration(username),
    FOREIGN KEY (promotion_id) REFERENCES Promotion(id)
);
GO
CREATE TABLE [dbo].[ReturnRequest] (
    [id] INT IDENTITY(1,1) PRIMARY KEY,
    [order_id] INT NOT NULL,
    [username] VARCHAR(20) NOT NULL,
    [reason] NVARCHAR(255) NOT NULL,
    [total_refund] FLOAT NOT NULL,
    [description] NVARCHAR(500) NULL,
    [email] VARCHAR(100) NOT NULL,
    [status] NVARCHAR(50) DEFAULT 'Pending', -- Pending | Approved | Rejected
    [request_date] DATETIME DEFAULT GETDATE(),
    CONSTRAINT [FK_ReturnRequest_Orders] FOREIGN KEY ([order_id]) REFERENCES [dbo].[Orders]([id]),
    CONSTRAINT [FK_ReturnRequest_Registration] FOREIGN KEY ([username]) REFERENCES [dbo].[Registration]([username])
);
GO


