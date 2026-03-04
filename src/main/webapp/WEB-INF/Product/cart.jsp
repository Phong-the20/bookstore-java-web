<%-- 
    Document   : productdetail
    Created on : Oct 15, 2025, 2:33:11 PM
    Author     : Asus
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="../includes/headerTotal.jsp" %>
<div class="tg-innerbanner tg-haslayout tg-parallax tg-bginnerbanner" data-z-index="-100" data-appear-top-offset="600" data-parallax="scroll" data-image-src="${pageContext.request.contextPath}/assets/images/parallax/bgparallax-07.jpg">


    <div class="container">
        <div class="row">
            <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                <div class="tg-innerbannercontent">
                    <h1>All Products</h1>
                    <ol class="tg-breadcrumb">
                        <li><a href="javascript:void(0);">home</a></li>
                        <li><a href="javascript:void(0);">Products</a></li>
                        <li class="tg-active">Product Title Here</li>
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
                    <div>
                        <!-- <h2> <span>T?t c? sách  </span> </h2> -->
                        <div>
                            <%-- th:if="" --%>
                                <form method="get" action="${pageContext.request.contextPath}/orders">
                                    <input type="hidden" name="view" value="confirm">
                                    <table class="styled-table">
                                        <thead>

                                            <tr>
                                                <th>STT</th>
                                                <th>Tên sách</th>
                                                <th>Hình ảnh</th>
                                                <th>đơn giá</th>
                                                <th>Số lương</th>
                                                <th>Thành tien</th> 
                                                <th>Hành động</th>
                                                <th></th>
                                            </tr>
                                        </thead>
                                        <tbody >
                                            `<c:set var="count" value="0" scope="page"/> 
                                            <c:forEach var="item" items="${listCartItem}">
                                                <c:set var="count" value="${count+1}" scope="page"></c:set>
                                                    <tr class="active-row">

                                                        <td>${count}</td>
                                                    <td>${item.getProduct().bookName}</td>
                                                    <td><img src="${item.getProduct().img}" alt="image description" style="height: 100px;"></td>
                                                    <td style="font-size : 15px"></td>
                                                    <td class="tg-quantityholder">
                                                        <em class="minus">-</em>
                                                        <input type="text" value="${item.quantity}" class="quan" data-max="${item.getProduct().quantity}" data-sku="${item.sku}" data-price="${item.getProduct().price}" style="width: 80px; margin-top: 5px;">

                                                        <em class="plus">+</em>

                                                    </td>
                                                    <td class="total">${item.quantity * item.getProduct().price} $</td>
                                                    <td>
                                                        <a href="">
                                                            <button type="button" class="btn btn-danger delete" data-sku="${item.sku}" style="width: 80px;">Xóa</button>
                                                        </a>
                                                    </td>

                                                </tr>  
                                            </c:forEach>
                                        <script>
                                            $(document).ready(function () {
                                                const min = 1;

                                                function deleteItem(sku) {
                                                    fetch('http://localhost:8080/Lib/cart', {
                                                        method: 'POST',
                                                        headers: {
                                                            'Content-Type': 'application/x-www-form-urlencoded'
                                                        },
                                                        body: new URLSearchParams({
                                                            sku: sku,
                                                            status: 'delete'
                                                        })
                                                    });
                                                }
                                                function updateCart(sku, quantity) {
                                                    fetch('http://localhost:8080/Lib/cart', {
                                                        method: 'POST',
                                                        headers: {
                                                            'Content-Type': 'application/x-www-form-urlencoded'
                                                        },
                                                        body: new URLSearchParams({
                                                            sku: sku,
                                                            quantity: quantity,
                                                            status: 'update'
                                                        })
                                                    });
                                                }
                                                function updateRowTotal(input) {
                                                    const price = parseFloat($(input).data('price'));
                                                    const quantity = parseInt($(input).val(), 10) || 0;
                                                    const total = (price * quantity).toFixed(2);
                                                    $(input).closest('tr').find('.total').text(total + ' $');
                                                }

                                                $('.delete').on('click', function () {
                                                    const sku = $(this).data('sku');

                                                    deleteItem(sku);
                                                    $(this).text('delete success');
                                                });

                                                // Nút trừ
                                                //chọn hết tất cả các phần tử minus trong trang $('.minus')
                                                //on('click', function () gắn event vào phần tử được chọn. Ở đây click là event
                                                //khi click thì sẽ thực hiện function tiếp đó.
                                                $('.minus').on('click', function () {//la sao
                                                    //this đại diện cho phần tử html đang được click, ở đây là minus 
                                                    //$(this) giúp ta gọi các hàm nhưu siblings.
                                                    //sibling tìm các phần tử cùng cấp cha mẹ, ở đâu là quan.(Cha mẹ) Phần tử kế bên là quan đó.
                                                    const input = $(this).siblings('.quan');//$ la gì, (this).siblings la gì
                                                    let val = parseInt(input.val(), 10) || 0;// input.val() lấy giá trị
                                                    const sku = input.data('sku');
                                                    const price = input.data('price');
                                                    //parse Int và chuyển về hệ cơ số 10, nếu ko dc thì cho = 0
                                                    //val() dùng để lấy hoặc gán giá trị
                                                    if (val > min) {
                                                        val--;
                                                        input.val(val);//input.val(val - 1) gán giá trị
                                                        updateRowTotal(input);
                                                        updateCart(sku, val);
                                                    }
                                                });

                                                // Nút cộng
                                                $('.plus').on('click', function () {
                                                    const input = $(this).siblings('.quan');
                                                    const sku = input.data('sku');

                                                    let val = parseInt(input.val(), 10) || 0;
                                                    const max = parseInt(input.data('max'));
                                                    if (val < max) {
                                                        val++;
                                                        input.val(val);
                                                        updateCart(sku, val);
                                                        updateRowTotal(input);
                                                    }
                                                });

                                                // Ngăn nhập ký tự không phải số + giới hạn max khi gõ
                                                $('.quan').on('keypress', function (e) {//e là đối tượng sự kiện chứa thông tin về nút vừa bấm, ở đây là value rồi
                                                    const val = parseInt($(this).val(), 10) || 0;//this la the co class la quan hien tai
                                                    const max = parseInt($(this).data('max'));// lay từ data-max trên input
                                                    // Nếu đã đạt max hoặc gõ ký tự không phải số → chặn
                                                    if (val >= max || e.which < 48 || e.which > 57)//e.which la nằm ngoài trong bảng ASCII
                                                        e.preventDefault();//chặn các hành động nằm ngoài đó
                                                });

                                                // Khi dán (paste) hoặc nhập bằng chuột → lọc lại và giới hạn max
                                                $('.quan').on('input', function () {
                                                    const sku = $(this).data('sku');

                                                    const max = parseInt($(this).data('max'));
                                                    let val = parseInt($(this).val().replace(/[^0-9]/g, ''), 10) || 0;
                                                    if (val > max)
                                                        val = max;
                                                    if (val < min)
                                                        val = min;
                                                    $(this).val(val);
                                                    updateRowTotal(this);
                                                    updateCart(sku, val);
                                                });
                                            });
                                        </script>
                                        <c:if test="${not empty listCartItem}">
                                            <tr><td colspan="7">
                                                    <button  class="btn btn-primary"  style="background: green; width: 200px; margin-bottom: 5px; margin-top: 5px;  " 
                                                             type="submit">Đặt hàng</button>
                                                </td></tr>
                                            </c:if>           


                                        </tbody>
                                    </table>
                                </form>
                            </th:block>
                            <c:if test="${ empty listCartItem}">
                                <th:block>
                                    <h5 style="color: red; margin-top: 5px;">Hiện tại giỏ sách trống</h5>
                                </th:block>
                            </c:if>               

                        </div>
                    </div>

                </div>
            </div>
        </div>
    </div>
</main>

<%@include file="../includes/footer.jsp" %>