/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import db.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.CartItem;
import model.Orders;

/**
 *
 * @author ACER
 */
public class OrdersDAO extends DBContext {

    public List<Orders> getOrders() {
        List<Orders> list = new ArrayList<>();
        String sql = """
                SELECT 
                    o.id,                           
                    o.name,                      
                    o.phone,                     
                    o.address,                      
                    o.total,                        
                    o.datebuy,                   
                    o.updated_at,               
                    o.status,
                    o.cancel_reason,
                    o.return_status
                FROM Orders o
                ORDER BY o.datebuy DESC;
                """;

        try (PreparedStatement ps = this.getConnection().prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            
            System.out.println("=== DEBUG: Executing getOrders query ===");
            
            while (rs.next()) {
                Orders order = new Orders(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("phone"),
                        rs.getString("address"),
                        rs.getDouble("total"),
                        rs.getDate("datebuy"),
                        rs.getDate("updated_at"),
                        rs.getString("status")
                );
                order.setCancelReason(rs.getString("cancel_reason"));
                order.setReturnStatus(rs.getString("return_status"));
                list.add(order);
                System.out.println("DEBUG: Added order ID: " + order.getId());
            }
            
            System.out.println("DEBUG: Total orders found: " + list.size());

        } catch (SQLException e) {
            System.err.println("ERROR in getOrders: " + e.getMessage());
            e.printStackTrace();
            Logger.getLogger(OrdersDAO.class.getName()).log(Level.SEVERE, null, e);
        }
        return list;
    }

    public void deleteOrders(int id) {
        String sql = "DELETE FROM Orders WHERE id = ?";
        try {
            PreparedStatement ps = this.getConnection().prepareStatement(sql);
            {
                ps.setInt(1, id);
                ps.execute();
            }
        } catch (SQLException ex) {
            Logger.getLogger(OrdersDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

    }

    public void editOrders(int id, String status) throws SQLException {
        String sql = "UPDATE Orders SET status = ?, updated_at = GETDATE() WHERE id = ?";
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, id);
            ps.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(OrdersDAO.class.getName()).log(Level.SEVERE, null, ex);
            throw ex;
        }
    }

    public int confirmOrders(Orders order, List<CartItem> cartItems, String username) {
        String sqlInsertOrder = """
        INSERT INTO Orders (dateBuy, name, phone, address, username, total, status, updated_at)
        VALUES (GETDATE(), ?, ?, ?, ?, ?, N'Chờ xác nhận', GETDATE())
    """;

        String sqlInsertDetail = """
        INSERT INTO OrderDetails (sku, order_id, price, quantity, total)
        VALUES (?, ?, ?, ?, ?)
    """;

        try (Connection con = this.getConnection()) {
            con.setAutoCommit(false); // Bắt đầu transaction

            // 1️⃣ Thêm đơn hàng chính
            PreparedStatement ps = con.prepareStatement(sqlInsertOrder, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, order.getName());
            ps.setString(2, order.getPhone());
            ps.setString(3, order.getAddress());
            ps.setString(4, username);
            ps.setDouble(5, order.getTotal());
            ps.executeUpdate();

            // 2️⃣ Lấy ID của đơn hàng vừa thêm
            ResultSet rs = ps.getGeneratedKeys();
            int orderId = 0;
            if (rs.next()) {
                orderId = rs.getInt(1);
            }

            // 3️⃣ Thêm chi tiết đơn hàng
            PreparedStatement psDetail = con.prepareStatement(sqlInsertDetail);
            for (CartItem item : cartItems) {
                psDetail.setString(1, item.getSku());
                psDetail.setInt(2, orderId);
                double price = item.getProduct().getPrice();
                int quantity = item.getQuantity();
                psDetail.setDouble(3, price);
                psDetail.setInt(4, quantity);
                psDetail.setDouble(5, price * quantity);
                psDetail.addBatch();
            }
            psDetail.executeBatch();

            con.commit();
            return 1;
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    /**
     * Cancel order with reason Only allowed when status = 'Chờ xác nhận'
     */
    public boolean cancelOrder(int orderId, String cancelReason) throws SQLException {
        String sql = "UPDATE Orders SET status = N'Đã hủy', cancel_reason = ?, updated_at = GETDATE() WHERE id = ? AND status = N'Chờ xác nhận'";
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setString(1, cancelReason);
            ps.setInt(2, orderId);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException ex) {
            Logger.getLogger(OrdersDAO.class.getName()).log(Level.SEVERE, null, ex);
            throw ex;
        }
    }

    /**
     * Request return for completed order Only allowed when status = 'Hoàn tất'
     */
    public boolean requestReturn(int orderId) throws SQLException {
        // First check if the order can be returned
        String checkSql = "SELECT status FROM Orders WHERE id = ?";
        try (PreparedStatement checkPs = this.getConnection().prepareStatement(checkSql)) {
            checkPs.setInt(1, orderId);
            ResultSet rs = checkPs.executeQuery();
            if (rs.next()) {
                String currentStatus = rs.getString("status");
                if (!"Hoàn tất".equals(currentStatus)) {
                    Logger.getLogger(OrdersDAO.class.getName()).log(Level.WARNING, 
                        "Order {0} cannot be returned because status is {1}, not ''Hoàn tất''", 
                        new Object[]{orderId, currentStatus});
                    return false;
                }
            } else {
                Logger.getLogger(OrdersDAO.class.getName()).log(Level.WARNING, 
                    "Order {0} not found", orderId);
                return false;
            }
        }
        
        String sql = "UPDATE Orders SET return_status = N'Đang chờ phê duyệt', updated_at = GETDATE() WHERE id = ?";
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, orderId);
            int rows = ps.executeUpdate();
            boolean success = rows > 0;
            
            if (!success) {
                Logger.getLogger(OrdersDAO.class.getName()).log(Level.WARNING, 
                    "Failed to update return status for order {0}. No rows affected.", orderId);
            }
            
            return success;
        } catch (SQLException ex) {
            Logger.getLogger(OrdersDAO.class.getName()).log(Level.SEVERE, 
                "Error updating return status for order " + orderId, ex);
            throw ex;
        }
    }

    /**
     * Admin approve return request
     */
    public boolean approveReturn(int orderId) throws SQLException {
        String sql = "UPDATE Orders SET return_status = N'Được phê duyệt', updated_at = GETDATE() WHERE id = ? AND return_status = N'Đang chờ phê duyệt'";
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, orderId);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException ex) {
            Logger.getLogger(OrdersDAO.class.getName()).log(Level.SEVERE, null, ex);
            throw ex;
        }
    }

    /**
     * Admin reject return request
     */
    public boolean rejectReturn(int orderId) throws SQLException {
        String sql = "UPDATE Orders SET return_status = N'Từ chối', updated_at = GETDATE() WHERE id = ? AND return_status = N'Đang chờ phê duyệt'";
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, orderId);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException ex) {
            Logger.getLogger(OrdersDAO.class.getName()).log(Level.SEVERE, null, ex);
            throw ex;
        }
    }

    /**
     * Check if order can be cancelled
     */
    public boolean canCancelOrder(int orderId) {
        String sql = "SELECT status FROM Orders WHERE id = ?";
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String status = rs.getString("status");
                return "Chờ xác nhận".equals(status);
            }
        } catch (SQLException ex) {
            Logger.getLogger(OrdersDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    /**
     * Check if order can be returned
     */
    public boolean canReturnOrder(int orderId) {
        String sql = "SELECT status FROM Orders WHERE id = ?";
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String status = rs.getString("status");
                return "Hoàn tất".equals(status);
            }
        } catch (SQLException ex) {
            Logger.getLogger(OrdersDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

}