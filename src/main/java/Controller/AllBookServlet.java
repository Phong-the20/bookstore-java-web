/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import dao.ProductDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Book;
import model.Category;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "AllBook", urlPatterns = {"/ab"})
public class AllBookServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AllBook</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AllBook at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ProductDAO dao = new ProductDAO();

        // 🧩 1. Lấy số trang từ URL (?page=2), mặc định là trang 1
        int page = 1;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) {
                    page = 1; // Không cho nhỏ hơn 1
                }
            } catch (NumberFormatException ex) {
                System.err.println("Invalid page parameter");
            }
        }

        // Nhận tham số
        String keyword = request.getParameter("keyword");
        String type = request.getParameter("type");
        String sortBy = request.getParameter("sortBy");
        List<Book> list;
        int totalBooks = 0;

        // Ưu tiên tìm kiếm trước - TÌM CẢ TÊN SÁCH VÀ TÊN TÁC GIẢ
        if (keyword != null && !keyword.trim().isEmpty()) {
            // Kiểm tra loại tìm kiếm
            if ("title".equals(type)) {
                // Tìm kiếm theo tiêu đề
                list = dao.searchBookByTitle(keyword.trim(), page);
                totalBooks = dao.getTotalBooksByTitle(keyword.trim());
            } else if ("author".equals(type)) {
                // Tìm kiếm theo tác giả
                list = dao.searchBookByAuthor(keyword.trim(), page);
                totalBooks = dao.getTotalBooksByAuthor(keyword.trim());
            } else {
                // Sử dụng universal search - tìm cả tên sách và tên tác giả
                list = dao.searchBooks(keyword.trim(), page);
                totalBooks = dao.getTotalBooksByKeyword(keyword.trim());
            }
        } else if ("title".equals(sortBy)) {
            list = dao.getBooksSortedByName(page);
            totalBooks = dao.getTotalBooks();
        } else if ("price".equals(sortBy)) {
            list = dao.getBooksSortedByPrice(page);
            totalBooks = dao.getTotalBooks();
        } else {
            list = dao.getAllBook(page);
            totalBooks = dao.getTotalBooks();
        }

        // 🧩 2. Tính tổng số trang
        int totalPages = (int) Math.ceil(totalBooks / 4.0); // 4 sách mỗi trang (để test)
        
        // Debug logging
        System.out.println("📊 Pagination Debug:");
        System.out.println("   Total Books: " + totalBooks);
        System.out.println("   Total Pages: " + totalPages);
        System.out.println("   Current Page: " + page);
        System.out.println("   Books in list: " + list.size());

        List<Category> categories = dao.getAllCategories();

        // 🧩 3. Truyền dữ liệu sang JSP
        request.setAttribute("list", list);
        request.setAttribute("categories", categories);
        request.setAttribute("keyword", keyword);
        request.setAttribute("type", type);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("/WEB-INF/User/AllBook.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
