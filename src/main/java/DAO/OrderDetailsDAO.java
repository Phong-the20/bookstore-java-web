package dao;

import db.DBContext;
import java.sql.*;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.OrderDetails;

public class OrderDetailsDAO extends DBContext {

    // ✅ Lấy danh sách chi tiết theo mã đơn hàng
    public List<OrderDetails> getOrderDetailsByOrderId(int orderId) {
        List<OrderDetails> list = new ArrayList<>();
        String sql = """
            SELECT
                o.id,
                o.name,
                o.phone,
                o.address,
                o.total,
                o.status,
                p.name AS productName,
                od.quantity,
                od.price,
                (od.quantity * od.price) AS subTotal,
                o.dateBuy
            FROM Orders o
            JOIN OrderDetails od ON o.id = od.order_id
            JOIN Product p ON od.sku = p.sku
            WHERE o.id = ?;
        """;

        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                OrderDetails detail = new OrderDetails(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("phone"),
                        rs.getString("address"),
                        rs.getDouble("total"),
                        rs.getDate("dateBuy"),
                        rs.getString("status"),
                        rs.getString("productName"),
                        rs.getInt("quantity"),
                        rs.getDouble("price"),
                        rs.getDouble("subTotal")
                );
                list.add(detail);
            }

        } catch (SQLException ex) {
            Logger.getLogger(OrderDetailsDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }
}
