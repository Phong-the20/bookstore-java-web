/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import DAO.AuthorsDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Authors;

/**
 *
 * lỗi 2 cách đầu cuối, emty trung trung sai dùng .trim() trùng tác giả là cook
 * không ddc số, kí tự đặc biệt
 *
 * @author ACER
 */
@WebServlet(name = "Authors", urlPatterns = {"/authors"})
public class AuthorsServlet extends HttpServlet {

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
            out.println("<title>Servlet Authors</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet Authors at " + request.getContextPath() + "</h1>");
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

        AuthorsDAO dao = new AuthorsDAO();

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

        // 🧩 2. Gọi DAO lấy danh sách tác giả theo trang
        List<Authors> authorList = dao.getAuthorList(page);

        // 🧩 3. Lấy tổng số dòng để tính tổng số trang
        int totalAuthors = dao.getTotalRows();
        int totalPages = (int) Math.ceil(totalAuthors / 10.0); // mỗi trang 10 tác giả

        // 🧩 4. Truyền dữ liệu sang JSP
        request.setAttribute("authorList", authorList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        // 🧩 5. Chuyển đến trang JSP
        request.getRequestDispatcher("/WEB-INF/authors.jsp").forward(request, response);
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
        String action = request.getParameter("action");

        if (action != null && action.equals("create")) {
            createAuthor(request, response);
        }
        if (action != null && action.equals("delete")) {
            deleteAuthor(request, response);
        }
        if (action != null && action.equals("edit")) {
            editAuthor(request, response);
        }
    }

    private void createAuthor(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy dữ liệu từ form
        String name = request.getParameter("name");
        String bio = request.getParameter("bio");

        // Tạo đối tượng model
        Authors author = new Authors();
        author.setName(name);
        author.setBio(bio);

        // Gọi DAO để lưu vào DB
        AuthorsDAO dao = new AuthorsDAO();
        dao.createAuthor(author);

        // Quay lại trang danh sách
        response.sendRedirect("authors");

    }

    private void deleteAuthor(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        Authors author = new Authors();
        author.setId(id);

        AuthorsDAO dao = new AuthorsDAO();
        dao.deleteAuthor(id);

        response.sendRedirect("authors");
    }

    private void editAuthor(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String bio = request.getParameter("bio");

        Authors author = new Authors();
        author.setId(id);
        author.setName(name);
        author.setBio(bio);

        AuthorsDAO dao = new AuthorsDAO();
        dao.editAuthor(author);

        response.sendRedirect("authors");
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
