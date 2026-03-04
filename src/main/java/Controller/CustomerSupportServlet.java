/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;


import dao.CustomerSupportDAO;
import dao.OrdersDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.CustomerSupport;
import model.Registration;

/**
 *
 * @author ASUS
 */
@WebServlet(name = "CustomerSupportServlet", urlPatterns = {"/support"})
public class CustomerSupportServlet extends HttpServlet {

    private CustomerSupportDAO supportDAO = new CustomerSupportDAO();

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
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        Registration user = (Registration) session.getAttribute("user");

        // Kiểm tra đăng nhập
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "view";
        }

        try {
            switch (action) {
                case "view":
                    viewSupportForm(request, response, user);
                    break;
                case "add":
                    addSupportRequest(request, response, user);
                    break;
                case "list":
                    listSupportRequests(request, response, user);
                    break;
                case "getTotal":
                    getOrderTotal(request, response);
                    break;
                case "updateStatus":
                    updateStatus(request, response, user);
                    break;
                case "delete":
                    deleteRequest(request, response, user);
                    break;
                default:
                    viewSupportForm(request, response, user);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/customerSupport.jsp").forward(request, response);
        }
    }

    /**
     * Hiển thị form yêu cầu hỗ trợ
     */
    private void viewSupportForm(HttpServletRequest request, HttpServletResponse response, Registration user)
            throws ServletException, IOException {
        String orderId = request.getParameter("orderId");
        request.setAttribute("currentUser", user);
        request.setAttribute("orderId", orderId);
        request.getRequestDispatcher("/WEB-INF/customerSupport.jsp").forward(request, response);
    }

    /**
     * Thêm yêu cầu hỗ trợ mới
     */
    private void addSupportRequest(HttpServletRequest request, HttpServletResponse response, Registration user)
            throws ServletException, IOException {
        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            String reason = request.getParameter("reason");
            double totalRefund = Double.parseDouble(request.getParameter("totalRefund"));
            String description = request.getParameter("description");
            String email = request.getParameter("email");

            // Kiểm tra xem đơn hàng đã có yêu cầu chưa
            if (supportDAO.hasExistingRequest(orderId, user.getUsername())) {
                request.setAttribute("message", "Đơn hàng này đã có yêu cầu hỗ trợ!");
                request.setAttribute("orderId", orderId);
                request.setAttribute("currentUser", user);
                request.getRequestDispatcher("/WEB-INF/customerSupport.jsp").forward(request, response);
                return;
            }

            // Tạo đối tượng CustomerSupport
            CustomerSupport support = new CustomerSupport();
            support.setOrderId(orderId);
            support.setUsername(user.getUsername());
            support.setReason(reason);
            support.setTotalRefund(totalRefund);
            support.setDescription(description);
            support.setEmail(email);

            // Thêm vào database
            boolean success = supportDAO.addSupportRequest(support);

            if (success) {
                // Cập nhật trạng thái đơn hàng thành "Đang chờ phê duyệt"
                OrdersDAO ordersDAO = new OrdersDAO();
                boolean orderUpdated = false;
                try {
                    orderUpdated = ordersDAO.requestReturn(orderId);
                    if (!orderUpdated) {
                        Logger.getLogger(CustomerSupportServlet.class.getName()).log(Level.WARNING,
                                "Order {0} status was not updated to ''Đang chờ phê duyệt''", orderId);
                        request.setAttribute("message", "Gửi yêu cầu thành công nhưng không thể cập nhật trạng thái đơn hàng!");
                        request.setAttribute("orderId", orderId);
                        request.setAttribute("currentUser", user);
                        request.getRequestDispatcher("/WEB-INF/customerSupport.jsp").forward(request, response);
                        return;
                    }
                } catch (SQLException e) {
                    Logger.getLogger(CustomerSupportServlet.class.getName()).log(Level.SEVERE,
                            "Error updating order status for order " + orderId, e);
                    request.setAttribute("message", "Lỗi khi cập nhật trạng thái đơn hàng: " + e.getMessage());
                    request.setAttribute("orderId", orderId);
                    request.setAttribute("currentUser", user);
                    request.getRequestDispatcher("/WEB-INF/customerSupport.jsp").forward(request, response);
                    return;
                }

                // Always redirect to orders page with success message, regardless of order status update
                response.sendRedirect(request.getContextPath() + "/orders?message=returnSuccess");
                return;
            } else {
                request.setAttribute("message", "Gửi yêu cầu thất bại!");
                request.setAttribute("orderId", orderId);
                request.setAttribute("currentUser", user);
                request.getRequestDispatcher("/WEB-INF/customerSupport.jsp").forward(request, response);
                return;
            }

        } catch (NumberFormatException e) {
            Logger.getLogger(CustomerSupportServlet.class.getName()).log(Level.SEVERE,
                    "Number format exception in addSupportRequest", e);
            request.setAttribute("message", "Dữ liệu không hợp lệ!");
            request.setAttribute("currentUser", user);
            request.getRequestDispatcher("/WEB-INF/customerSupport.jsp").forward(request, response);
        } catch (Exception e) {
            Logger.getLogger(CustomerSupportServlet.class.getName()).log(Level.SEVERE,
                    "Unexpected error in addSupportRequest", e);
            request.setAttribute("message", "Có lỗi xảy ra: " + e.getMessage());
            request.setAttribute("currentUser", user);
            request.getRequestDispatcher("/WEB-INF/customerSupport.jsp").forward(request, response);
        }
    }

    /**
     * Lấy danh sách yêu cầu hỗ trợ
     */
    private void listSupportRequests(HttpServletRequest request, HttpServletResponse response, Registration user)
            throws ServletException, IOException {
        List<CustomerSupport> list;

        // Nếu là admin, xem tất cả; nếu là user, chỉ xem của mình
        if (user.isIsAdmin()) {
            list = supportDAO.getAllSupportRequests();
        } else {
            list = supportDAO.getSupportRequestsByUsername(user.getUsername());
        }

        request.setAttribute("supportList", list);
        request.setAttribute("currentUser", user);
        request.setAttribute("activeTab", "list");
        request.getRequestDispatcher("/WEB-INF/customerSupport.jsp").forward(request, response);
    }

    /**
     * Lấy tổng tiền đơn hàng (AJAX)
     */
    private void getOrderTotal(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/plain;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            double total = supportDAO.getOrderTotal(orderId);
            out.print(total);
        } catch (Exception e) {
            response.getWriter().print("0");
        }
    }

    /**
     * Cập nhật trạng thái yêu cầu (Admin only)
     */
    private void updateStatus(HttpServletRequest request, HttpServletResponse response, Registration user)
            throws ServletException, IOException {
        if (!user.isIsAdmin()) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String status = request.getParameter("status");

            boolean success = supportDAO.updateSupportStatus(id, status);

            if (success) {
                request.setAttribute("message", "Cập nhật trạng thái thành công!");
            } else {
                request.setAttribute("message", "Cập nhật thất bại!");
            }

        } catch (Exception e) {
            request.setAttribute("message", "Có lỗi xảy ra: " + e.getMessage());
        }

        listSupportRequests(request, response, user);
    }

    /**
     * Xóa yêu cầu hỗ trợ (Admin only)
     */
    private void deleteRequest(HttpServletRequest request, HttpServletResponse response, Registration user)
            throws ServletException, IOException {
        if (!user.isIsAdmin()) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            boolean success = supportDAO.deleteSupportRequest(id);

            if (success) {
                request.setAttribute("message", "Xóa yêu cầu thành công!");
            } else {
                request.setAttribute("message", "Xóa thất bại!");
            }

        } catch (Exception e) {
            request.setAttribute("message", "Có lỗi xảy ra: " + e.getMessage());
        }

        listSupportRequests(request, response, user);
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
        processRequest(request, response);
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
        return "Customer Support Servlet";
    }// </editor-fold>

}
