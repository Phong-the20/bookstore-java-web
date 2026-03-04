package Controller;


import dao.OrderDetailsDAO;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.OrderDetails;
import model.Registration;

@WebServlet(name = "OrderDetailsServlet", urlPatterns = {"/orderdetails"})
public class OrderDetailsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Registration user = (Registration) request.getSession().getAttribute("user");

        // Nếu chưa đăng nhập → quay lại login
        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        try {
            // 1️⃣ Lấy order id từ URL
            String orderIdStr = request.getParameter("id");
            if (orderIdStr == null || orderIdStr.isEmpty()) {
                response.sendRedirect("orders"); // nếu không có id thì quay về danh sách
                return;
            }

            int orderId = Integer.parseInt(orderIdStr);

            // 2️⃣ Gọi DAO để lấy chi tiết đơn hàng
            OrderDetailsDAO dao = new OrderDetailsDAO();
            List<OrderDetails> orderDetailsList = dao.getOrderDetailsByOrderId(orderId);

            if (orderDetailsList == null || orderDetailsList.isEmpty()) {
                request.setAttribute("message", "Không tìm thấy chi tiết đơn hàng cho ID = " + orderId);
            } else {
                // 3️⃣ Gán list vào request
                request.setAttribute("orderDetails", orderDetailsList);

                // 4️⃣ Lấy thông tin đơn hàng (chỉ 1 bản ghi — phần chung)
                OrderDetails first = orderDetailsList.get(0);
                request.setAttribute("order", first);
            }

            if (user.isIsAdmin()) {
                RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/orders/orderdetails.jsp");
                rd.forward(request, response);
            } // Nếu là user → vào trang chi tiết user
            else {
                RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/orders/orderdetails.jsp");
                rd.forward(request, response);
            }
        } catch (Exception e) {
            response.getWriter().println("Lỗi: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
