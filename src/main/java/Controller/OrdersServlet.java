/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;


import dao.CartDAO;
import dao.OrdersDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Cart;
import model.CartItem;
import model.Orders;
import model.Registration;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "Orders", urlPatterns = {"/orders"})
public class OrdersServlet extends HttpServlet {

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
            out.println("<title>Servlet Orders</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet Orders at " + request.getContextPath() + "</h1>");
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

        String view = request.getParameter("view");
        String message = request.getParameter("message");
        
        // Set message attribute if exists
        if (message != null) {
            request.setAttribute("message", message);
        }
        
        if ("order".equals(view) || view == null || view.isEmpty()) {
            OrdersDAO dao = new OrdersDAO();
            List<Orders> orderList = dao.getOrders();
            request.setAttribute("orderList", orderList);
            
            // Handle returnSuccess message
            String messageParam = request.getParameter("message");
            if ("returnSuccess".equals(messageParam)) {
                request.setAttribute("successMessage", "Yêu cầu hoàn trả đã được gửi thành công! Đơn hàng đang ở trạng thái chờ phê duyệt.");
            }
            
            request.getRequestDispatcher("/WEB-INF/orders/orders.jsp").forward(request, response);

        } else if ("confirm".equals(view)) {
            // ✅ Lấy session trước
            jakarta.servlet.http.HttpSession session = request.getSession();

            Registration user = (Registration) session.getAttribute("user");
            if (user == null) {
                response.sendRedirect("login");
                return;
            }

            //  lấy từ session
            List<CartItem> list = (List<CartItem>) session.getAttribute("listCartItem");

// nếu session không có => lấy lại từ DB
            if (list == null) {
                CartDAO cartDao = new CartDAO();
                Cart cart = cartDao.getCart(user.getUsername());
                if (cart != null) {
                    list = cartDao.cartAll(cart.getId());
                    session.setAttribute("listCartItem", list);
                }
            }

// nếu vẫn null hoặc rỗng
            if (list == null || list.isEmpty()) {
                request.setAttribute("message", "Giỏ hàng trống, không thể đặt hàng!");
                request.getRequestDispatcher("/WEB-INF/Product/cart.jsp").forward(request, response);
                return;
            }

// ✅ Tính tổng tiền
            double total = 0;
            for (CartItem item : list) {
                total += item.getProduct().getPrice() * item.getQuantity();
            }

            request.setAttribute("cartList", list);
            request.setAttribute("total", total);

            request.getRequestDispatcher("/WEB-INF/User/purchase.jsp").forward(request, response);
        }

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

        if (action != null && action.equals("delete")) {
            deleteOrders(request, response);
        } else if (action != null && action.equals("edit")) {
            editOrders(request, response);
        } else if (action != null && action.equals("cancel")) {
            cancelOrder(request, response);
        } else if (action != null && action.equals("return")) {
            returnOrder(request, response);
        } else if (action != null && action.equals("approveReturn")) {
            approveReturn(request, response);
        } else if (action != null && action.equals("rejectReturn")) {
            rejectReturn(request, response);
        } else if (action != null && action.equals("confirm")) {
            String name = request.getParameter("fullname");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String totalParam = request.getParameter("total");

            jakarta.servlet.http.HttpSession session = request.getSession();
            Registration user = (Registration) session.getAttribute("user");
            if (user == null) {
                response.sendRedirect("login");
                return;
            }

            List<CartItem> cartItems = (List<CartItem>) session.getAttribute("listCartItem");
            if (cartItems == null || cartItems.isEmpty()) {
                response.sendRedirect("cart");
                return;
            }

            double total = 0;
            try {
                total = Double.parseDouble(totalParam);
            } catch (NumberFormatException e) {
                // Calculate total from cart items if not provided
                for (CartItem item : cartItems) {
                    total += item.getProduct().getPrice() * item.getQuantity();
                }
            }

            Orders order = new Orders();
            order.setName(name);
            order.setPhone(phone);
            order.setAddress(address);
            order.setTotal(total);

            OrdersDAO dao = new OrdersDAO();
            int rs = dao.confirmOrders(order, cartItems, user.getUsername());

            if (rs == 1) {
                // Xóa giỏ hàng sau khi đặt hàng thành công
                session.removeAttribute("listCartItem");
                response.sendRedirect(request.getContextPath() + "/orders");
            } else {
                response.sendRedirect(request.getContextPath() + "/login");
            }
        } else {
            // Default action - show orders list
            response.sendRedirect(request.getContextPath() + "/orders");
        }

    }

    private void deleteOrders(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        Orders order = new Orders();
        order.setId(id);

        OrdersDAO dao = new OrdersDAO();
        dao.deleteOrders(id);

        response.sendRedirect("orders");
    }

    private void editOrders(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String status = request.getParameter("status");

            OrdersDAO dao = new OrdersDAO();
            dao.editOrders(id, status);

            response.sendRedirect("orders");
        } catch (SQLException ex) {
            Logger.getLogger(OrdersServlet.class.getName()).log(Level.SEVERE, null, ex);
        }

    }

    private void cancelOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String cancelReason = request.getParameter("cancelReason");
            
            OrdersDAO dao = new OrdersDAO();
            
            // Check if order can be cancelled
            if (!dao.canCancelOrder(id)) {
                request.setAttribute("errorMessage", "Không thể hủy đơn hàng này. Chỉ có thể hủy đơn hàng đang ở trạng thái 'Chờ xác nhận'");
                request.getRequestDispatcher("/WEB-INF/orders/orders.jsp").forward(request, response);
                return;
            }
            
            boolean success = dao.cancelOrder(id, cancelReason);
            if (success) {
                request.setAttribute("successMessage", "Đã hủy đơn hàng thành công");
            } else {
                request.setAttribute("errorMessage", "Hủy đơn hàng thất bại");
            }
            
            response.sendRedirect("orders");
        } catch (SQLException ex) {
            Logger.getLogger(OrdersServlet.class.getName()).log(Level.SEVERE, null, ex);
            request.setAttribute("errorMessage", "Lỗi hệ thống: " + ex.getMessage());
            request.getRequestDispatcher("/WEB-INF/orders/orders.jsp").forward(request, response);
        }
    }

    private void returnOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            
            OrdersDAO dao = new OrdersDAO();
            
            // Check if order can be returned
            if (!dao.canReturnOrder(id)) {
                request.setAttribute("errorMessage", "Không thể trả hàng. Chỉ có thể trả đơn hàng đã hoàn tất");
                request.getRequestDispatcher("/WEB-INF/orders/orders.jsp").forward(request, response);
                return;
            }
            
            boolean success = dao.requestReturn(id);
            if (success) {
                request.setAttribute("successMessage", "Yêu cầu hoàn trả đã được gửi. Vui lòng chờ admin phê duyệt");
            } else {
                request.setAttribute("errorMessage", "Gửi yêu cầu hoàn trả thất bại");
            }
            
            response.sendRedirect("orders");
        } catch (SQLException ex) {
            Logger.getLogger(OrdersServlet.class.getName()).log(Level.SEVERE, null, ex);
            request.setAttribute("errorMessage", "Lỗi hệ thống: " + ex.getMessage());
            request.getRequestDispatcher("/WEB-INF/orders/orders.jsp").forward(request, response);
        }
    }

    private void approveReturn(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            
            OrdersDAO dao = new OrdersDAO();
            boolean success = dao.approveReturn(id);
            
            if (success) {
                request.setAttribute("successMessage", "Đã phê duyệt yêu cầu hoàn trả");
            } else {
                request.setAttribute("errorMessage", "Phê duyệt thất bại");
            }
            
            response.sendRedirect("orders");
        } catch (SQLException ex) {
            Logger.getLogger(OrdersServlet.class.getName()).log(Level.SEVERE, null, ex);
            request.setAttribute("errorMessage", "Lỗi hệ thống: " + ex.getMessage());
            request.getRequestDispatcher("/WEB-INF/orders/orders.jsp").forward(request, response);
        }
    }

    private void rejectReturn(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            
            OrdersDAO dao = new OrdersDAO();
            boolean success = dao.rejectReturn(id);
            
            if (success) {
                request.setAttribute("successMessage", "Đã từ chối yêu cầu hoàn trả");
            } else {
                request.setAttribute("errorMessage", "Từ chối thất bại");
            }
            
            response.sendRedirect("orders");
        } catch (SQLException ex) {
            Logger.getLogger(OrdersServlet.class.getName()).log(Level.SEVERE, null, ex);
            request.setAttribute("errorMessage", "Lỗi hệ thống: " + ex.getMessage());
            request.getRequestDispatcher("/WEB-INF/orders/orders.jsp").forward(request, response);
        }
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