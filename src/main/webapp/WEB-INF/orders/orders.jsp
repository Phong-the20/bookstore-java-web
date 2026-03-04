<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/includes/headerTotal.jsp" />


    <body>
        <header id="tg-header" class="tg-header tg-haslayout">

        </header>

        <div class="tg-innerbanner tg-haslayout tg-parallax tg-bginnerbanner" 
             data-z-index="-100" data-appear-top-offset="600" 
             data-parallax="scroll" data-image-src="../images/parallax/bgparallax-07.jpg">
            <div class="container">
                <div class="tg-innerbannercontent">
                    <h1>Quản lý đơn hàng</h1>
                    <ol class="tg-breadcrumb">
                        <li><a href="#">Trang chủ</a></li>
                        <li class="tg-active">Đơn hàng</li>
                    </ol>
                </div>
            </div>
        </div>

        <main id="tg-main" class="tg-main tg-haslayout">
            <div class="tg-sectionspace tg-haslayout" style="padding-top: 50px;">
                <div class="container">
                    <div class="tg-products">
                        <div class="tg-productgrid">
                            <div class="row">
                                <table class="table table-bordered">
                                    <thead>
                                        <tr>
                                            <th>STT</th>
                                            <th>Mã đơn</th>
                                            <th>Họ và tên</th>
                                            <th>Số điện thoại</th>
                                            <th>Địa chỉ</th>
                                            <th>Tổng tiền</th>
                                            <th>Ngày tạo</th>
                                            <th>Ngày cập nhật</th>
                                            <th>Trạng thái</th>
                                            <th>Trạng thái hoàn trả</th>
                                            <th>Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="order" items="${orderList}" varStatus="st">
                                            <tr class="active-row">
                                                <td>${st.index + 1}</td>
                                                <td>${order.id}</td>
                                                <td>${order.name}</td>
                                                <td>${order.phone}</td>
                                                <td>${order.address}</td>
                                                <td>${order.total}</td>
                                                <td><fmt:formatDate value="${order.datebuy}" pattern="dd/MM/yyyy" /></td>
                                                <td><fmt:formatDate value="${order.updated_at}" pattern="dd/MM/yyyy" /></td>
                                                <td>
                                                    <span class="label ${order.status eq 'Chờ xác nhận' ? 'label-warning' : order.status eq 'Đang giao' ? 'label-info' : order.status eq 'Hoàn tất' ? 'label-success' : 'label-danger'}">
                                                        ${order.status}
                                                    </span>
                                                </td>
                                                <td>
                                                    <c:if test="${order.returnStatus != null}">
                                                        <span class="label ${order.returnStatus eq 'Đang chờ phê duyệt' ? 'label-warning' : order.returnStatus eq 'Được phê duyệt' ? 'label-success' : 'label-danger'}">
                                                            ${order.returnStatus}
                                                        </span>
                                                    </c:if>
                                                    <c:if test="${order.returnStatus == null}">-</c:if>
                                                </td>
                                                <td style="white-space: nowrap;">
                                                    <div style="display: flex; gap: 5px; flex-wrap: nowrap; align-items: center;">
                                                        <!-- Nút Chi tiết - Luôn hiển thị -->
                                                        <a href="${pageContext.request.contextPath}/orderdetails?id=${order.id}" class="btn btn-sm btn-primary" style="min-width: 85px;">Chi tiết</a>
                                                        
                                                        <c:choose>
                                                            <%-- Nếu là admin --%>
                                                            <c:when test="${sessionScope.user != null && sessionScope.user.isIsAdmin()}">
                                                                <button type="button" class="btn btn-sm btn-warning" data-toggle="modal" data-target="#edit${order.id}" style="min-width: 85px;">Sửa</button>
                                                                <%-- Admin: Nút xác nhận hoàn trả (dropdown) --%>
                                                                <c:if test="${order.returnStatus eq 'Đang chờ phê duyệt'}">
                                                                    <div class="btn-group" style="min-width: 85px;">
                                                                        <button type="button" class="btn btn-sm btn-info dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" style="width: 100%;">
                                                                            Xác nhận <span class="caret"></span>
                                                                        </button>
                                                                        <ul class="dropdown-menu" style="list-style: none; padding-left: 0; margin: 0;">
                                                                            <li style="list-style: none;">
                                                                                <a href="#" data-toggle="modal" data-target="#approveReturn${order.id}" style="color: #5cb85c; padding: 8px 20px; display: block; text-decoration: none;">
                                                                                    <i class="fa fa-check"></i> Duyệt
                                                                                </a>
                                                                            </li>
                                                                            <li role="separator" class="divider" style="margin: 5px 0;"></li>
                                                                            <li style="list-style: none;">
                                                                                <a href="#" data-toggle="modal" data-target="#rejectReturn${order.id}" style="color: #d9534f; padding: 8px 20px; display: block; text-decoration: none;">
                                                                                    <i class="fa fa-times"></i> Từ chối
                                                                                </a>
                                                                            </li>
                                                                        </ul>
                                                                    </div>
                                                                </c:if>
                                                            </c:when>

                                                            <%-- Nếu là user thường --%>
                                                            <c:otherwise>
                                                                <%-- Nút Hủy đơn - LUÔN HIỆN, disabled khi không phải "Chờ xác nhận" --%>
                                                                <c:choose>
                                                                    <c:when test="${order.status eq 'Chờ xác nhận'}">
                                                                        <button type="button" class="btn btn-sm btn-danger" data-toggle="modal" data-target="#cancel${order.id}" style="min-width: 85px;">Hủy đơn</button>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <button type="button" class="btn btn-sm btn-danger" disabled style="min-width: 85px; opacity: 0.5; cursor: not-allowed;">Hủy đơn</button>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                                
                                                                <%-- Nút Hoàn trả - Link đến Customer Support --%>
                                                                <c:choose>
                                                                    <c:when test="${order.status eq 'Hoàn tất' && (order.returnStatus == null || order.returnStatus eq '')}">
                                                                        <a href="${pageContext.request.contextPath}/support?orderId=${order.id}" class="btn btn-sm btn-warning" style="min-width: 85px;">Hoàn trả</a>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <button type="button" class="btn btn-sm btn-warning" disabled style="min-width: 85px; opacity: 0.5; cursor: not-allowed;">Hoàn trả</button>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </td>
                                            </tr>

                                            <!-- Modal Delete -->                           
                                        <div class="modal fade" id="delete${order.id}" tabindex="-1" role="dialog">
                                            <div class="modal-dialog">
                                                <div class="modal-content">
                                                    <form action="${pageContext.request.contextPath}/orders" method="post">
                                                        <input type="hidden" name="action" value="delete">
                                                        <input type="hidden" name="id" value="${order.id}">
                                                        <c:choose>
                                                            <c:when test="${order.status eq 'Đang giao'}">
                                                                <div class="modal-header">
                                                                    <h4>Không thể xóa đơn hàng đang giao!</h4>
                                                                </div>
                                                                <div class="modal-body">
                                                                    <button type="button" class="btn btn-default" data-dismiss="modal">OK</button>
                                                                </div>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <div class="modal-header">
                                                                    <h4>Bạn chắc chắn muốn xóa đơn hàng này?</h4>
                                                                </div>
                                                                <div class="modal-body">
                                                                    <button type="button" class="btn btn-default" data-dismiss="modal">Hủy</button>
                                                                    <button type="submit" class="btn btn-primary">Xác nhận</button>
                                                                </div>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>


                                        <!-- Modal Edit -->
                                        <div class="modal fade" id="edit${order.id}" tabindex="-1" role="dialog">
                                            <div class="modal-dialog">
                                                <div class="modal-content">
                                                    <div class="modal-header">
                                                        <h4>Bạn muốn sửa đơn hàng này?</h4>
                                                    </div>
                                                    <div class="modal-body">
                                                        <form action="${pageContext.request.contextPath}/orders" method="post">
                                                            <input type="hidden" name="action" value="edit">
                                                            <input type="hidden" name="id" value="${order.id}">
                                                            <div class="form-group">
                                                                <label>Trạng thái</label>
                                                                <select name="status" class="form-control" required>
                                                                    <option ${order.status eq 'Chờ xác nhận' ? 'selected' : ''}>Chờ xác nhận</option>
                                                                    <option ${order.status eq 'Đang giao' ? 'selected' : ''}>Đang giao</option>
                                                                    <option ${order.status eq 'Hoàn tất' ? 'selected' : ''}>Hoàn tất</option>
                                                                    <option ${order.status eq 'Đã hủy' ? 'selected' : ''}>Đã hủy</option>
                                                                </select>
                                                            </div>
                                                            <button type="submit" class="btn btn-primary">Xác nhận</button>
                                                            <button type="button" class="btn btn-default" data-dismiss="modal">Hủy</button>
                                                        </form>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Modal Cancel Order -->
                                        <div class="modal fade" id="cancel${order.id}" tabindex="-1" role="dialog">
                                            <div class="modal-dialog">
                                                <div class="modal-content">
                                                    <div class="modal-header">
                                                        <h4>Hủy đơn hàng #${order.id}</h4>
                                                    </div>
                                                    <div class="modal-body">
                                                        <form action="${pageContext.request.contextPath}/orders" method="post">
                                                            <input type="hidden" name="action" value="cancel">
                                                            <input type="hidden" name="id" value="${order.id}">
                                                            <div class="form-group">
                                                                <label>Lý do hủy đơn <span style="color:red">*</span></label>
                                                                <select name="cancelReason" id="cancelReasonSelect${order.id}" class="form-control" required onchange="toggleOtherReason(${order.id})">
                                                                    <option value="">-- Chọn lý do --</option>
                                                                    <option value="Đổi địa chỉ giao hàng">Đổi địa chỉ giao hàng</option>
                                                                    <option value="Đổi phương thức thanh toán">Đổi phương thức thanh toán</option>
                                                                    <option value="Muốn thay đổi sản phẩm">Muốn thay đổi sản phẩm</option>
                                                                    <option value="Đặt nhầm đơn hàng">Đặt nhầm đơn hàng</option>
                                                                    <option value="Tìm được giá tốt hơn">Tìm được giá tốt hơn</option>
                                                                    <option value="other">Khác (nhập lý do)</option>
                                                                </select>
                                                            </div>
                                                            <div class="form-group" id="otherReasonDiv${order.id}" style="display:none;">
                                                                <label>Nhập lý do khác</label>
                                                                <textarea name="otherReason" id="otherReasonText${order.id}" class="form-control" rows="3" placeholder="Vui lòng nhập lý do hủy đơn..."></textarea>
                                                            </div>
                                                            <div class="alert alert-warning">
                                                                <strong>Lưu ý:</strong> Chỉ có thể hủy đơn hàng khi đang ở trạng thái "Chờ xác nhận"
                                                            </div>
                                                            <button type="submit" class="btn btn-danger" onclick="return validateCancelForm(${order.id})">Xác nhận hủy</button>
                                                            <button type="button" class="btn btn-default" data-dismiss="modal">Đóng</button>
                                                        </form>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Modal Approve Return (Admin) -->
                                        <div class="modal fade" id="approveReturn${order.id}" tabindex="-1" role="dialog">
                                            <div class="modal-dialog">
                                                <div class="modal-content">
                                                    <div class="modal-header">
                                                        <h4>Phê duyệt hoàn trả đơn hàng #${order.id}</h4>
                                                    </div>
                                                    <div class="modal-body">
                                                        <form action="${pageContext.request.contextPath}/orders" method="post">
                                                            <input type="hidden" name="action" value="approveReturn">
                                                            <input type="hidden" name="id" value="${order.id}">
                                                            <p>Bạn xác nhận phê duyệt yêu cầu hoàn trả cho đơn hàng này?</p>
                                                            <div class="alert alert-success">
                                                                <strong>Khách hàng:</strong> ${order.name}<br>
                                                                <strong>Tổng tiền:</strong> ${order.total} VNĐ
                                                            </div>
                                                            <button type="submit" class="btn btn-success">Phê duyệt</button>
                                                            <button type="button" class="btn btn-default" data-dismiss="modal">Hủy</button>
                                                        </form>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Modal Reject Return (Admin) -->
                                        <div class="modal fade" id="rejectReturn${order.id}" tabindex="-1" role="dialog">
                                            <div class="modal-dialog">
                                                <div class="modal-content">
                                                    <div class="modal-header">
                                                        <h4>Từ chối hoàn trả đơn hàng #${order.id}</h4>
                                                    </div>
                                                    <div class="modal-body">
                                                        <form action="${pageContext.request.contextPath}/orders" method="post">
                                                            <input type="hidden" name="action" value="rejectReturn">
                                                            <input type="hidden" name="id" value="${order.id}">
                                                            <p>Bạn xác nhận từ chối yêu cầu hoàn trả cho đơn hàng này?</p>
                                                            <div class="alert alert-warning">
                                                                <strong>Khách hàng:</strong> ${order.name}<br>
                                                                <strong>Tổng tiền:</strong> ${order.total} VNĐ
                                                            </div>
                                                            <button type="submit" class="btn btn-danger">Từ chối</button>
                                                            <button type="button" class="btn btn-default" data-dismiss="modal">Hủy</button>
                                                        </form>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <!-- Pagination -->
                    <nav aria-label="Page navigation">
                        <ul class="pager">
                            <li><a href="?page=1">1</a></li>
                            <li><a href="?page=2">2</a></li>
                            <li><a href="?page=3">3</a></li>
                            <li><a href="?page=4">4</a></li>
                            <li><a href="?page=5">5</a></li>
                        </ul>
                    </nav>
                </div>
            </div>
        </main>

        <script>
            // Toggle "other reason" textarea when user selects "Khác"
            function toggleOtherReason(orderId) {
                var select = document.getElementById('cancelReasonSelect' + orderId);
                var otherDiv = document.getElementById('otherReasonDiv' + orderId);
                var otherText = document.getElementById('otherReasonText' + orderId);
                
                if (select.value === 'other') {
                    otherDiv.style.display = 'block';
                    otherText.required = true;
                } else {
                    otherDiv.style.display = 'none';
                    otherText.required = false;
                }
            }

            // Validate cancel form before submit (no confirm dialog)
            function validateCancelForm(orderId) {
                var select = document.getElementById('cancelReasonSelect' + orderId);
                var otherText = document.getElementById('otherReasonText' + orderId);
                
                if (select.value === '') {
                    alert('Vui lòng chọn lý do hủy đơn');
                    return false;
                }
                
                if (select.value === 'other') {
                    if (otherText.value.trim() === '') {
                        alert('Vui lòng nhập lý do hủy đơn');
                        otherText.focus();
                        return false;
                    }
                    // Set the cancel reason to the custom text
                    select.name = '';
                    otherText.name = 'cancelReason';
                }
                
                // Submit directly without confirm dialog
                return true;
            }
        </script>

        <%@include file="../includes/footer.jsp" %>