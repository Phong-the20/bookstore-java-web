<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Registration"%>
<%@page import="model.CustomerSupport"%>
<%@page import="java.util.List"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@include file="includes/headerTotal.jsp" %>

<%
    Registration currentUser = (Registration) request.getAttribute("currentUser");
    if (currentUser == null) {
        currentUser = (Registration) session.getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
    }

    String orderId = request.getParameter("orderId");
    String activeTab = (String) request.getAttribute("activeTab");
    if (activeTab == null) {
        activeTab = (orderId != null) ? "form" : "list";
    }
    
    List<CustomerSupport> supportList = (List<CustomerSupport>) request.getAttribute("supportList");
%>

<!-- Banner -->
<div class="tg-innerbanner tg-haslayout tg-parallax tg-bginnerbanner" data-z-index="-100" 
     data-appear-top-offset="600" data-parallax="scroll" 
     data-image-src="${pageContext.request.contextPath}/assets/images/parallax/bgparallax-07.jpg"
     style="width:100%; background-size:cover; background-position:center;">
    <div class="container text-center">
        <div class="row">
            <div class="col-xs-12">
                <div class="tg-innerbannercontent">
                    <h1 style="margin-bottom: 20px; font-weight: bold;">Customer Support</h1>
                    <ol class="tg-breadcrumb">
                        <li><a href="${pageContext.request.contextPath}/home">home</a></li>
                        <li>Customer Support</li>
                    </ol>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Main Content -->
<main id="tg-main" class="tg-main tg-haslayout">
    <div class="tg-sectionspace tg-haslayout">
        <div class="container">
            <div class="row">
                <div class="col-xs-12 col-sm-10 col-sm-offset-1 col-md-8 col-md-offset-2 col-lg-8 col-lg-offset-2">
                    <h2 style="margin-bottom: 30px; text-align: center;">Submit Support Request</h2>
                            
                            <form action="${pageContext.request.contextPath}/support" method="post" id="supportForm">
                                <input type="hidden" name="action" value="add"/>
                                <input type="hidden" name="orderId" value="<%= orderId != null ? orderId : "" %>"/>
                                <input type="hidden" id="totalRefundHidden" name="totalRefund" value="0"/>

                                <div class="form-group" style="margin-bottom: 20px;">
                                    <label><span style="color: red;">*</span><strong>Order ID</strong></label>
                                    <input type="text" class="form-control" readonly 
                                           value="<%= orderId != null ? "Order #" + orderId : "No order selected" %>">
                                </div>

                                <div class="form-group" style="margin-bottom: 20px;">
                                    <label for="reason"><span style="color: red;">*</span><strong>Reason</strong></label>
                                    <select id="reason" name="reason" class="form-control" required>
                                        <option value="">-- Select Reason --</option>
                                        <option value="Sáº£n pháº©m bá»‹ lá»—i / hÆ° há»ng">Product Defect/Damaged</option>
                                        <option value="Giao sai sáº£n pháº©m">Wrong Product</option>
                                        <option value="KhÃ´ng Ä‘Ãºng mÃ´ táº£">Not as Described</option>
                                        <option value="Thiáº¿u phá»¥ kiá»‡n">Missing Accessories</option>
                                        <option value="KhÃ¡ch hÃ ng Ä‘á»•i Ã½">Change of Mind</option>
                                        <option value="KhÃ¡c">Other</option>
                                    </select>
                                </div>

                                <div class="form-group" style="margin-bottom: 20px;">
                                    <label for="totalRefundDisplay"><span style="color: red;">*</span><strong>Refund Amount</strong></label>
                                    <input type="text" id="totalRefundDisplay" class="form-control" 
                                           readonly placeholder="Loading..." style="font-weight: bold; color: #28a745;">
                                </div>

                                <div class="form-group" style="margin-bottom: 20px;">
                                    <label for="description"><span style="color: red;">*</span><strong>Description</strong></label>
                                    <textarea id="description" name="description" rows="4" class="form-control" 
                                              placeholder="Please describe your issue in detail..." required></textarea>
                                    <small class="text-muted">Vui lòng nhập ít nhất 10 ký tự</small>
                                </div>

                                <div class="form-group" style="margin-bottom: 20px;">
                                    <label for="email"><span style="color: red;">*</span><strong>Contact Email</strong></label>
                                    <input type="email" id="email" name="email" class="form-control" 
                                           readonly value="${currentUser.email}">
                                </div>

                                <div class="form-group text-center">
                                    <button type="submit" class="btn btn-primary btn-lg" style="padding: 12px 50px; font-size: 16px;">
                                        <i class="fa fa-paper-plane"></i> Submit Request
                                    </button>
                                </div>
                            </form>
                </div>
            </div>
        </div>
    </div>
</main>

<%@include file="includes/footer.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
// Load total refund
window.addEventListener('load', function() {
    const orderId = '<%= orderId != null ? orderId : "" %>';
    if (orderId && orderId !== '') {
        fetch('${pageContext.request.contextPath}/support?action=getTotal&orderId=' + orderId)
            .then(res => res.text())
            .then(data => {
                const total = parseFloat(data) || 0;
                document.getElementById('totalRefundDisplay').value = '$' + total.toFixed(2);
                document.getElementById('totalRefundHidden').value = total;
            })
            .catch(() => {
                document.getElementById('totalRefundDisplay').value = '$0.00';
                document.getElementById('totalRefundHidden').value = '0';
            });
    } else {
        document.getElementById('totalRefundDisplay').value = '$0.00';
        document.getElementById('totalRefundHidden').value = '0';
    }
});

// Show messages
<c:if test="${not empty message}">
if ('${message}' === 'success') {
    Swal.fire({ 
        icon: 'success', 
        title: 'Success!', 
        text: 'Your support request has been submitted successfully!', 
        timer: 3000,
        showConfirmButton: false
    });
} else {
    Swal.fire({ icon: 'error', title: 'Error!', text: '${message}' });
}
</c:if>

// Form validation
document.getElementById('supportForm').addEventListener('submit', function(e) {
    const reason = document.getElementById('reason').value;
    const description = document.getElementById('description').value;
    
    if (!reason) {
        e.preventDefault();
        Swal.fire({ 
            icon: 'warning', 
            title: 'Thiếu thông tin', 
            text: 'Vui lòng chọn lý do!',
            confirmButtonText: 'OK'
        });
        return false;
    }
    
    if (description.trim().length === 0) {
        e.preventDefault();
        Swal.fire({ 
            icon: 'warning', 
            title: 'Thiếu mô tả', 
            text: 'Vui lòng nhập mô tả chi tiết!',
            confirmButtonText: 'OK'
        });
        return false;
    }
    
    if (description.trim().length < 10) {
        e.preventDefault();
        Swal.fire({ 
            icon: 'warning', 
            title: 'Mô tả quá ngắn', 
            text: 'Vui lòng nhập ít nhất 10 ký tự!',
            confirmButtonText: 'OK'
        });
        return false;
    }
});
</script>
</body>
</html>
