# 📚 Bookstore Management System

## 🧾 Introduction
Bookstore Management System is a Java Web application developed using Servlet & JSP following MVC architecture.
The system allows customers to browse books, place orders, cancel orders, and request returns.
Administrators can manage orders and approve return requests.
---

## 🛠 Tech Stack

- Java Servlet & JSP
- Maven
- Microsoft SQL Server
- Apache Tomcat
- NetBeans IDE

---

## 🚀 Setup Instructions

### 1️⃣ Database Setup

Import the file `BookStore.sql` into Microsoft SQL Server.

Make sure your SQL Server connection settings match the configuration in the project.

---

### 2️⃣ Build & Run

1. Open project in NetBeans
2. Clean & Build project
3. Deploy to Apache Tomcat
4. Start server
5. Access via: http://localhost:8080/Final_Project_PRJ301_GR4

---
## ⚠ Note

This project is configured to run locally using Apache Tomcat and Microsoft SQL Server.  
Please update the database connection settings before running.

---
## 📌 Business Rules

### Cancel Order
- Only available when order status = `Chờ xác nhận`
- User must provide a cancel reason

### Return Order
- Only available when order status = `Hoàn tất`
- Only if return_status is NULL
- Requires admin approval

### Admin Approval
- Only admin can approve return requests
- Only when return_status = `Đang chờ phê duyệt`

---

## 📂 Project Structure

```
src/
├── Controller/
├── DAO/
├── model/
└── webapp/
```

---

## ✨ Main Features

- 📖 Book listing with pagination
- 🔍 Search functionality
- 🛒 Order management
- ❌ Order cancellation with reason
- 🔁 Return request workflow
- 👨‍💼 Admin approval system

---

## 👨‍💻 Author

Student Project – PRJ301  
Developed as part of Java Web course.