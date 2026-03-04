/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;


import dao.CartDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.Cart;
import model.CartItem;
import model.Registration;

/**
 *
 * @author Asus
 */
@WebServlet(name = "Cart", urlPatterns = {"/cart"})
public class CartServlet extends HttpServlet {

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
        CartDAO cartDao = new CartDAO();//tao cartDao de chuan bi lay usercartID vi registration la id khac nen ko the lay theo duoc
        HttpSession session = request.getSession();
        Registration user = (Registration) session.getAttribute("user");//lay username

        if (user != null) {
            Cart cart = cartDao.getCart(user.getUsername());//truy cap username de lay usercartID

            List<CartItem> cartItem = cartDao.cartAll(cart.getId());//co ai thi tim list cartItem
            request.setAttribute("listCartItem", cartItem);//set vao vang vao cart.jsp
            session.setAttribute("listCartItem", cartItem); // Lưu vào session để dùng cho đặt hàng
            request.getRequestDispatcher("/WEB-INF/Product/cart.jsp").forward(request, response);

        } else {
            request.setAttribute("Error", "Please login to use the shopping cart");
            request.getRequestDispatcher("/assets/404errol.jsp").forward(request, response);
        }
        //Tai sao ko cho cart thanh session ?
        //Cho session o dau? o doPost?
        //ko dc vi khi doGet lay ra thi ko co ma dung
        //o doGet?
        // cx ko dc vi khi xem chi tiet sach va co add to cart cho do, nhung lai ko mo gio hang thi lam gi co session 🤔.
        //nen la ko cho vao sesion
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
        String status = request.getParameter("status");
        String quantity = request.getParameter("quantity");
        String sku = request.getParameter("sku");

        HttpSession session = request.getSession();
        Registration user = (Registration) session.getAttribute("user");
//        if (quantity!=null){
//            response.getWriter().write(quantity);
//        }
//        else{
//            response.getWriter().write("ko nhan");
//        }

//Kiem tra xem co dang nhap hay chua
        if (user != null) {
            CartDAO cartDAO = new CartDAO();
            Cart cart = cartDAO.getCart(user.getUsername());
            //kiem tra xem user da co cart hay chua, neu chua thi tao cart cho user
            if (cart == null) {
                cartDAO.creatCart(user.getUsername());
                cart = cartDAO.getCart(user.getUsername());
            }
            //kiem tra neu da co cart thi them sp vao cart
            if (cart != null) {
//                 response.getWriter().write(quantity+"and"+cart.getId()+"and"+sku);
                CartItem cartItem = cartDAO.getCartItem(cart.getId(), sku);

                //kiem tra xem san pham da ton tai trong gio hang chua
                //neu da co thi cong don(update) vao quantity
                if (status != null && status.equals("update")) {
                    //test xem có chạy ko
//                    System.out.println("✅ doPut() has been called!"); // in ra console server
//                    response.setContentType("text/plain;charset=UTF-8");
//                    response.getWriter().write("Server received PUT request");
//
//                    // Test thêm xem tham số có nhận đúng không
//                    System.out.println("quantity = " + request.getParameter("quantity"));
//                    System.out.println("sku = " + request.getParameter("sku"));                    
                    cartDAO.updateCartItem(cart.getId(), sku, Integer.parseInt(quantity));
                    cartDAO.updateCart(cart.getUsername());
                } else if (status != null && status.equals("delete")) {

//                    response.setContentType("text/plain;charset=UTF-8");
//                    response.getWriter().write("Server received PUT request");
                    int rs = cartDAO.deleteCartItem(cart.getId(), sku);
                    if (rs == 1) {
                        System.out.println("delete has been called!"); // in ra console server 
                    } else {
                        System.out.println("delete fails" + cart.getId() + sku); // in ra console server
                    }
                } else if (status != null && status.equals("add")) {
                    if (cartItem != null) {
                        int addQuantity = cartItem.getQuantity() + Integer.parseInt(quantity);
                        int rs = cartDAO.updateCartItem(cart.getId(), sku, addQuantity);
                        int rs2 = cartDAO.updateCart(cart.getUsername());
                        if (rs == 0 || rs2 == 0) {
                            System.out.println("Can't add =((");
                        } else {
                            System.out.println("Add succesfull 😘");
                            response.getWriter().write("Add succesfull 😘");
                        }
                    } //neu chua ton tai trong cart thi tao moi va insert vao
                    else if (cartItem == null) {
                        int rs = cartDAO.createCartItem(cart.getId(), sku, Integer.parseInt(quantity));
                        if (rs == 0) {
                            response.getWriter().write("Can't add2 =((" + rs);
                            System.out.println("Can't add 2 =((");
                        } else {

                            response.getWriter().write("Add succesfull 😊😊😊");

                            System.out.println("Create and Add succesfull 😊");
                        }
                    }
                } else {
                    // Trường hợp status null hoặc không hợp lệ
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("Invalid or missing 'status' parameter. Expected: 'add', 'update', or 'delete'");
                    System.out.println("⚠️ Invalid status parameter: " + status);
                }
            } else {
                response.getWriter().write("Loi cart ko ton tai, hien chua bt cach thong bao 😓");
            }
        } else {
            response.getWriter().write("Loi cart ko ton tai, hien chua bt cach thong bao 😓");

        }
    }

    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

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
