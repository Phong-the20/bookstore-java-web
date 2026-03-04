# 🔧 Xóa JSP Cache để fix lỗi compile

## Vấn đề:
Tomcat đang dùng JSP compiled cũ (có `getProductDetail()`), chưa recompile file mới.

## Giải pháp:

### Cách 1: Xóa thư mục work của Tomcat (Khuyến nghị)

1. **Stop server** trong NetBeans
2. **Xóa thư mục work:**
   ```
   C:\Users\ASUS\Downloads\apache-tomcat-10.1.40-windows-x64\apache-tomcat-10.1.40\work\Catalina\localhost\Lib
   ```
3. **Restart server**

### Cách 2: Clean and Build + Undeploy

1. **Stop server**
2. **Right-click project** → **Clean and Build**
3. **Right-click project** → **Undeploy**
4. **Run project** lại

### Cách 3: Xóa thủ công trong NetBeans

1. Stop server
2. Vào thư mục:
   ```
   C:\Users\ASUS\Downloads\apache-tomcat-10.1.40-windows-x64\apache-tomcat-10.1.40\work
   ```
3. Xóa toàn bộ thư mục `Catalina`
4. Restart server

## Sau khi xóa cache:

1. Vào: `http://localhost:8080/Lib/ab`
2. Trang sẽ load thành công
3. Scroll xuống sẽ thấy pagination

## Nếu vẫn lỗi:

Kiểm tra file AllBook.jsp dòng 90 có đúng là:
```jsp
<a href="http://localhost:8080/Lib/ProductDetail?productId=<%=b.getSku_product()%>">
```

KHÔNG PHẢI:
```jsp
<a href="http://localhost:8080/Lib/ProductDetail?productId=<%=b.getProductDetail().getId()%>">
```
