<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page import="model.Book"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="../includes/headerTotal.jsp" %>


<div class="tg-innerbanner tg-haslayout tg-parallax tg-bginnerbanner" data-z-index="-100" data-appear-top-offset="600" data-parallax="scroll" data-image-src="../images/parallax/bgparallax-07.jpg">
    <div class="container">
        <div class="row">
            <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                <div class="tg-innerbannercontent">
                    <h1 style="margin-bottom: 20px;">All Books</h1>
                    <ol class="tg-breadcrumb">
                        <li><a href="javascript:void(0);">Home Page</a></li>
                        <li class="tg-active">Book</li>
                    </ol>
                </div>
            </div>
        </div>
    </div>
</div>
<main id="tg-main" class="tg-main tg-haslayout">
    <div class="tg-sectionspace tg-haslayout">
        <div class="container">
            <div class="row">
                <div id="tg-twocolumns" class="tg-twocolumns">

                    <!-- PHẦN NỘI DUNG CHÍNH -->
                    <div class="col-xs-12 col-sm-8 col-md-8 col-lg-9 pull-right">
                        <div id="tg-content" class="tg-content">
                            <div class="tg-products">

                                <!-- THÔNG BÁO KẾT QUẢ TÌM KIẾM -->
                                <c:if test="${not empty keyword}">
                                    <div class="alert alert-info" style="margin-bottom: 20px;">
                                        <i class="fa fa-search"></i> 
                                        Kết quả tìm kiếm cho: <strong>"${keyword}"</strong> 
                                        - Tìm thấy <strong>${fn:length(list)}</strong> sản phẩm
                                        <a href="${pageContext.request.contextPath}/ab" class="btn btn-sm btn-default" style="margin-left: 10px;">
                                            <i class="fa fa-times"></i> Xóa tìm kiếm
                                        </a>
                                    </div>
                                </c:if>

                                <!-- FORM SẮP XẾP -->
                                <div class="tg-refinesearch mb-3">
                                    <form class="tg-formtheme tg-formsortshoitems" action="ab">
                                        <fieldset>
                                            <div class="form-group">
                                                <label>Sắp xếp theo:</label>
                                                <span class="tg-select" style="padding-left: 40px;">
                                                    <select name="sortBy" id="sortBy" onchange="this.form.submit()">
                                                        <option value="">---Chọn sắp xếp---</option>
                                                        <option value="title" ${sortBy == 'title' ? 'selected' : ''}>Tên sách</option>
                                                        <option value="price" ${sortBy == 'price' ? 'selected' : ''}>Đơn giá</option>
                                                    </select>
                                                </span>
                                            </div>
                                        </fieldset>
                                    </form>
                                </div>

                                <!-- DANH SÁCH SÁCH -->
                                <div class="row tg-productgrid">
                                    <%
                                        List<Book> list = (List<Book>) request.getAttribute("list");
                                        if (list != null && !list.isEmpty()) {
                                            for (Book b : list) {
                                    %>
                                    <div class="col-xs-6 col-sm-6 col-md-4 col-lg-3 mb-4">
                                        <div class="tg-postbook text-center" style="border: 1px solid #eee; padding: 10px; margin-bottom: 20px; border-radius: 10px; background: #fff; height: 100%;">
                                            <figure class="tg-featureimg">
                                                <div class="tg-bookimg">
                                                    <div class="tg-frontcover">
                                                        <img src="<%= b.getImg() %>" alt="<%= b.getImg() %>" style="width:180px; height:240px; object-fit:cover;">
                                                    </div>
                                                    <div class="tg-backcover">
                                                        <img src="<%= b.getImg() %>" alt="<%= b.getImg() %>" style="width:180px; height:240px; object-fit:cover;">
                                                    </div>
                                                </div>
                                            </figure>
                                            <div class="tg-postbookcontent mt-2">
                                                <ul class="tg-bookscategories" style="padding: 0; list-style: none;">
                                                    <li><a href="#"><%= b.getCategory_name() != null ? b.getCategory_name() : "Chưa có thể loại"%></a></li>
                                                </ul>
                                                <div class="tg-booktitle">
                                                    <h4 style="height: 40px; font-weight: bold;">
                                                        <a href="http://localhost:8080/Lib/ProductDetail?productId=<%=b.getSku_product()%>" style="text-align: center; color: #333; text-decoration: none;">
                                                            <%= b.getName_product()%>        
                                                        </a>
                                                    </h4>

                                                </div>
                                                <span class="tg-bookwriter d-block" style="text-align: left; margin-left: 0px;">
                                                    Tác giả: <%= b.getAuthor_name() != null ? b.getAuthor_name() : "Không rõ"%>
                                                </span>
                                                <span class="tg-bookwriter d-block" style="text-align: left; margin-left: 0px;">
                                                    Đã bán: <%= b.getQuantity_orderDetail()%>
                                                </span>
                                                <span class="tg-bookwriter d-block" style="text-align: left; margin-left: 0px;">
                                                    Còn: <%= b.getQuantity_product()%>
                                                </span>

                                                <span class="tg-bookprice d-block"><ins><%= String.format("%,.0f", b.getPrice_product())%> $</ins></span>
                                                <a class="tg-btn tg-btnstyletwo mt-2" >
                                                    <i class="fa fa-shopping-basket"></i>
                                                    <em class="quan1" data-sku="<%=b.getSku_product()%>" style="cursor: pointer">Thêm Vào Giỏ</em>
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                    <%
                                        }
                                    } else {
                                    %>
                                    <div class="col-12 text-center" style="padding: 60px 20px;">
                                        <c:choose>
                                            <c:when test="${not empty keyword}">
                                                <div class="alert alert-warning">
                                                    <i class="fa fa-exclamation-triangle fa-3x" style="margin-bottom: 15px;"></i>
                                                    <h3>Không tìm thấy kết quả</h3>
                                                    <p>Không tìm thấy sản phẩm nào khớp với từ khóa <strong>"${keyword}"</strong></p>
                                                    <p>Vui lòng thử lại với từ khóa khác hoặc 
                                                        <a href="${pageContext.request.contextPath}/ab" class="btn btn-primary">
                                                            <i class="fa fa-home"></i> Xem tất cả sản phẩm
                                                        </a>
                                                    </p>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <p>Không có sản phẩm nào.</p>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <% }%>
                                   
                                    <!-- 🌿 Pagination -->
                                    <div class="col-xs-12" style="margin-top: 30px;">
                                        <c:if test="${not empty totalPages and totalPages > 0}">
                                    <style>
                                        .pagination {
                                            display: flex;
                                            justify-content: center;
                                            gap: 8px;
                                            list-style: none;
                                            padding-left: 0;
                                            margin-top: 30px;
                                        }
                                        .pagination .page-link {
                                            color: #4CAF50;
                                            border: 1px solid #d9d9d9;
                                            border-radius: 50%;
                                            padding: 8px 15px;
                                            text-decoration: none;
                                            background-color: #fff;
                                            transition: all 0.2s ease-in-out;
                                            font-weight: 500;
                                        }
                                        .pagination .page-link:hover {
                                            background-color: #e9f5ec;
                                            border-color: #4CAF50;
                                            color: #4CAF50;
                                        }
                                        .pagination .active .page-link {
                                            background-color: #4CAF50;
                                            color: #fff;
                                            border-color: #4CAF50;
                                        }
                                        .pagination .disabled .page-link {
                                            color: #ccc;
                                            pointer-events: none;
                                            border-color: #eee;
                                        }
                                    </style>
                                    <nav aria-label="Page navigation">
                                        <ul class="pagination">
                                            <!-- Nút Previous -->
                                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                                <a class="page-link"
                                                   href="<c:url value='/ab'>
                                                       <c:param name='page' value='${currentPage - 1}'/>
                                                       <c:if test='${not empty keyword}'><c:param name='keyword' value='${keyword}'/></c:if>
                                                       <c:if test='${not empty type}'><c:param name='type' value='${type}'/></c:if>
                                                       <c:if test='${not empty sortBy}'><c:param name='sortBy' value='${sortBy}'/></c:if>
                                                   </c:url>"
                                                   aria-label="Previous">&laquo;</a>
                                            </li>

                                            <!-- Các số trang -->
                                            <c:forEach begin="1" end="${totalPages}" var="i">
                                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                    <a class="page-link"
                                                       href="<c:url value='/ab'>
                                                           <c:param name='page' value='${i}'/>
                                                           <c:if test='${not empty keyword}'><c:param name='keyword' value='${keyword}'/></c:if>
                                                           <c:if test='${not empty type}'><c:param name='type' value='${type}'/></c:if>
                                                           <c:if test='${not empty sortBy}'><c:param name='sortBy' value='${sortBy}'/></c:if>
                                                       </c:url>">${i}</a>
                                                </li>
                                            </c:forEach>

                                            <!-- Nút Next -->
                                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                                <a class="page-link"
                                                   href="<c:url value='/ab'>
                                                       <c:param name='page' value='${currentPage + 1}'/>
                                                       <c:if test='${not empty keyword}'><c:param name='keyword' value='${keyword}'/></c:if>
                                                       <c:if test='${not empty type}'><c:param name='type' value='${type}'/></c:if>
                                                       <c:if test='${not empty sortBy}'><c:param name='sortBy' value='${sortBy}'/></c:if>
                                                   </c:url>"
                                                   aria-label="Next">&raquo;</a>
                                            </li>
                                        </ul>
                                    </nav>
                                        </c:if>
                                    </div>

                                </div>

                            </div>
                        </div>
                    </div>

                    <!-- SIDEBAR -->
                    <div class="col-xs-12 col-sm-4 col-md-4 col-lg-3 pull-left">
                        <aside id="tg-sidebar" class="tg-sidebar">
                            <div class="tg-widget tg-widgetsearch">
                                <form class="tg-formtheme tg-formsearch" action="ab" method="get">
                                    <div class="form-group">
                                        <button type="submit"><i class="icon-magnifier"></i></button>
                                        <input type="search" name="keyword" value="${keyword}" 
                                               class="form-group" style="width: 270px;" 
                                               placeholder="Tìm kiếm với ... ">
                                    </div>
                                    <select name="type" class="form-group" style="width: 130px; margin-top: 3px;" id="searchBy">
                                        <option value="title" ${type == 'title' ? 'selected' : ''}>Tiêu đề</option>
                                        <option value="author" ${type == 'author' ? 'selected' : ''}>Tác giả</option>
                                    </select>
                                </form>

                            </div>
                        </aside> 
                        <div class="tg-widget tg-catagories"> <br>
                            <div class="tg-widgettitle">
                                <h3>Thể loại</h3>
                            </div>
                            <div class="tg-widgetcontent">
                                <ul style="padding-left:0; margin:0;">
                                    <c:forEach var="c" items="${categories}">
                                        <!-- khởi tạo count = 0 -->
                                        <c:set var="count" value="${0}" />

                                        <!-- duyệt danh sách sách và tăng count khi trùng thể loại -->
                                        <c:forEach var="b" items="${list}">
                                            <c:if test="${not empty b.category_name and b.category_name == c.name}">
                                                <c:set var="count" value="${count + 1}" />
                                            </c:if>
                                        </c:forEach>

                                        <!-- hiển thị tên category và số lượng (canh phải) -->
                                        <li style="display:flex; justify-content:space-between; align-items:center; padding:6px 10px; list-style:none; border-bottom: 1px solid #f0f0f0;">
                                            <a href="#" style="text-decoration:none; color:inherit;">
                                                ${c.name}
                                            </a>
                                            <span style="font-size:0.9rem; color:#666;">${count}</span>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<%@include file="../includes/footer.jsp"%>

