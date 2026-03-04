<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Registration" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    Registration user = (Registration) session.getAttribute("user");
    boolean isLoggedIn = user != null;
    boolean isAdmin = isLoggedIn && user.isIsAdmin(); // Ensure backend sets isAdmin to true for admin users
    String username = isLoggedIn ? user.getUsername() : "";
%>

<!DOCTYPE html>
<head>
    <title>Book Library</title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="apple-touch-icon" href="${pageContext.request.contextPath}/assets/apple-touch-icon.png">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/normalize.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/font-awesome.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/icomoon.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/jquery-ui.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/owl.carousel.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/transitions.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/color.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/responsive.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    

    
</head>
<body class="tg-home tg-homeone">

    <div id="tg-wrapper" class="tg-wrapper tg-haslayout">
        <!--************************************
                        Header Start
        *************************************-->
        <header id="tg-header" class="tg-header tg-haslayout">
            <div class="tg-topbar">
                <div class="container">
                    <div class="row">
                        <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                            <% if (isLoggedIn) {%>
                            <div class="tg-userlogin dropdown">
                                <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">

                                    <span>Hi, <%= username%></span>
                                </a>
                                <ul class="dropdown-menu list-unstyled" style="list-style: none; padding-left: 0;">
                                    <li style="list-style: none; margin-bottom:10px;"><a href="profile"><i class="fa-solid fa-user"></i> Account information</a></li>
                                        <% if (!isAdmin) { %>
                                    <li style="list-style: none; margin-bottom:10px;"><a href="${pageContext.request.contextPath}/orders"><i class="fa-solid fa-cart-shopping"></i> Purchase information</a></li>
                                        <% } %>
                                    <li style="list-style: none; margin-bottom:10px;"><a href="logout"><i class="fa-solid fa-right-from-bracket"></i> Logout</a></li>
                                </ul>
                            </div>
                            <% } else { %>
                            <div class="tg-userlogin">
                                <a href="login"><i class="fa-solid fa-right-to-bracket"></i> Login</a>    |    <a href="register"> <i class="fa-solid fa-user-plus"></i> Register</a>
                            </div>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
            <div class="tg-middlecontainer">
                <div class="container">
                    <div class="row">
                        <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                            <strong class="tg-logo"><a href="index.jsp"><img src="${pageContext.request.contextPath}/assets/images/logo.png" alt="company name here"></a></strong>
                            <div class="tg-wishlistandcart">
                                <!-- muốn dùng thì xóa cái div dưới<div class="dropdown tg-themedropdown tg-minicartdropdown">-->
                                <div>
                                    <%-- <a href="${pageContext.request.contextPath}/Cart" id="tg-minicart" class="tg-btnthemedropdown" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">--%>
                                    <a href="${pageContext.request.contextPath}/cart" id="tg-minicart" class="tg-btnthemedropdown" aria-haspopup="true" aria-expanded="false">

<!--                                        <span class="tg-themebadge">7</span>-->
                                        <i class="icon-cart"></i>
                                        <span>$123.00</span>
                                    </a>
                                    <!--                                        <div class="dropdown-menu tg-themedropdownmenu" aria-labelledby="tg-minicart">
                                                                                <div class="tg-minicartbody">
                                                                                    <div class="tg-minicarproduct">
                                                                                        <figure>
                                                                                            <img src="${pageContext.request.contextPath}/assets/images/products/img-01.jpg" alt="image description">
                                                                                        </figure>
                                                                                        <div class="tg-minicarproductdata">
                                                                                            <h5><a href="javascript:void(0);">Our State Fair Is A Great Function</a></h5>
                                                                                            <h6><a href="javascript:void(0);">$ 12.15</a></h6>
                                                                                        </div>
                                                                                    </div>
                                                                                    <div class="tg-minicarproduct">
                                                                                        <figure>
                                                                                            <img src="${pageContext.request.contextPath}/assets/images/products/img-02.jpg" alt="image description">
                                                                                        </figure>
                                                                                        <div class="tg-minicarproductdata">
                                                                                            <h5><a href="javascript:void(0);">Bring Me To Light</a></h5>
                                                                                            <h6><a href="javascript:void(0);">$ 12.15</a></h6>
                                                                                        </div>
                                                                                    </div>
                                                                                    <div class="tg-minicarproduct">
                                                                                        <figure>
                                                                                            <img src="${pageContext.request.contextPath}/assets/images/products/img-03.jpg" alt="image description">
                                                                                        </figure>
                                                                                        <div class="tg-minicarproductdata">
                                                                                            <h5><a href="javascript:void(0);">Have Faith In Your Soul</a></h5>
                                                                                            <h6><a href="javascript:void(0);">$ 12.15</a></h6>
                                                                                        </div>
                                                                                    </div>
                                                                                </div>
                                                                                <div class="tg-minicartfoot">
                                                                                    <a class="tg-btnemptycart" href="javascript:void(0);">
                                                                                        <i class="fa fa-trash-o"></i>
                                                                                        <span>Clear Your Cart</span>
                                                                                    </a>
                                                                                    <span class="tg-subtotal">Subtotal: <strong>35.78</strong></span>
                                                                                    <div class="tg-btns">
                                                                                        <a class="tg-btn tg-active" href="javascript:void(0);">View Cart</a>
                                                                                        <a class="tg-btn" href="javascript:void(0);">Checkout</a>
                                                                                    </div>
                                                                                </div>
                                                                            </div>-->
                                </div>
                            </div>
                            <div class="tg-searchbox">
                                <form class="tg-formtheme tg-formsearch" action="${pageContext.request.contextPath}/ab" method="get">
                                    <fieldset style="display: flex; align-items: center; gap: 5px;">
                                        <input type="text" name="keyword" class="typeahead form-control" placeholder="Search by title, author, keyword..." required style="flex: 1;">
                                        <select name="type" style="padding: 8px; border: 1px solid #ddd; border-radius: 4px;">
                                            <option value="">All</option>
                                            <option value="title">Title</option>
                                            <option value="author">Author</option>
                                        </select>
                                        <button type="submit"><i class="icon-magnifier"></i></button>
                                    </fieldset>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="tg-navigationarea">
                <div class="container">
                    <div class="row">
                        <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                            <nav id="tg-nav" class="tg-nav">
                                <div class="navbar-header">
                                    <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#tg-navigation" aria-expanded="false">
                                        <span class="sr-only">Toggle navigation</span>
                                        <span class="icon-bar"></span>
                                        <span class="icon-bar"></span>
                                        <span class="icon-bar"></span>
                                    </button>
                                </div>
                                <div id="tg-navigation" class="collapse navbar-collapse tg-navigation">
                                    <ul>
                                        <li><a href="book">Home</a></li>
                                            <% if (isAdmin) { %>
                                        <li class="menu-item-has-children menu-item-has-mega-menu">
                                            <a href="javascript:void(0);">All Categories</a>
                                            <div class="mega-menu">
                                                <ul class="tg-themetabnav" role="tablist">
                                                    <li role="presentation" class="active">
                                                        <a href="#artandphotography" aria-controls="artandphotography" role="tab" data-toggle="tab">Art &amp; Photography</a>
                                                    </li>
                                                    <li role="presentation">
                                                        <a href="#biography" aria-controls="biography" role="tab" data-toggle="tab">Biography</a>
                                                    </li>
                                                    <li role="presentation">
                                                        <a href="#childrensbook" aria-controls="childrensbook" role="tab" data-toggle="tab">Children’s Book</a>
                                                    </li>
                                                    <li role="presentation">
                                                        <a href="#craftandhobbies" aria-controls="craftandhobbies" role="tab" data-toggle="tab">Craft &amp; Hobbies</a>
                                                    </li>
                                                    <li role="presentation">
                                                        <a href="#crimethriller" aria-controls="crimethriller" role="tab" data-toggle="tab">Crime &amp; Thriller</a>
                                                    </li>
                                                    <li role="presentation">
                                                        <a href="#fantasyhorror" aria-controls="fantasyhorror" role="tab" data-toggle="tab">Fantasy &amp; Horror</a>
                                                    </li>
                                                    <li role="presentation">
                                                        <a href="#fiction" aria-controls="fiction" role="tab" data-toggle="tab">Fiction</a>
                                                    </li>
                                                    <li role="presentation">
                                                        <a href="#fooddrink" aria-controls="fooddrink" role="tab" data-toggle="tab">Food &amp; Drink</a>
                                                    </li>
                                                    <li role="presentation">
                                                        <a href="#graphicanimemanga" aria-controls="graphicanimemanga" role="tab" data-toggle="tab">Graphic, Anime &amp; Manga</a>
                                                    </li>
                                                    <li role="presentation">
                                                        <a href="#sciencefiction" aria-controls="sciencefiction" role="tab" data-toggle="tab">Science Fiction</a>
                                                    </li>
                                                </ul>
                                                <div class="tab-content tg-themetabcontent">
                                                    <div role="tabpanel" class="tab-pane active" id="artandphotography">
                                                        <ul>
                                                            <li>
                                                                <div class="tg-linkstitle">
                                                                    <h2>Architecture</h2>
                                                                </div>
                                                                <ul>
                                                                    <li><a href="products.html">Tough As Nails</a></li>
                                                                    <li><a href="products.html">Pro Grease Monkey</a></li>
                                                                    <li><a href="products.html">Building Memories</a></li>
                                                                    <li><a href="products.html">Bulldozer Boyz</a></li>
                                                                    <li><a href="products.html">Build Or Leave On Us</a></li>
                                                                </ul>
                                                                <a class="tg-btnviewall" href="products.html">View All</a>
                                                            </li>
                                                            <li>
                                                                <div class="tg-linkstitle">
                                                                    <h2>Art Forms</h2>
                                                                </div>
                                                                <ul>
                                                                    <li><a href="products.html">Consectetur adipisicing</a></li>
                                                                    <li><a href="products.html">Aelit sed do eiusmod</a></li>
                                                                    <li><a href="products.html">Tempor incididunt labore</a></li>
                                                                    <li><a href="products.html">Dolore magna aliqua</a></li>
                                                                    <li><a href="products.html">Ut enim ad minim</a></li>
                                                                </ul>
                                                                <a class="tg-btnviewall" href="products.html">View All</a>
                                                            </li>
                                                            <li>
                                                                <div class="tg-linkstitle">
                                                                    <h2>History</h2>
                                                                </div>
                                                                <ul>
                                                                    <li><a href="products.html">Veniam quis nostrud</a></li>
                                                                    <li><a href="products.html">Exercitation</a></li>
                                                                    <li><a href="products.html">Laboris nisi ut aliuip</a></li>
                                                                    <li><a href="products.html">Commodo conseat</a></li>
                                                                    <li><a href="products.html">Duis aute irure</a></li>
                                                                </ul>
                                                                <a class="tg-btnviewall" href="products.html">View All</a>
                                                            </li>
                                                        </ul>
                                                        <ul>
                                                            <li>
                                                                <figure><img src="${pageContext.request.contextPath}/assets/images/img-01.png" alt="image description"></figure>
                                                                <div class="tg-textbox">
                                                                    <h3>More Than<span>12,0657,53</span>Books Collection</h3>
                                                                    <div class="tg-description">
                                                                        <p>Consectetur adipisicing elit sed doe eiusmod tempor incididunt laebore toloregna aliqua enim.</p>
                                                                    </div>
                                                                    <a class="tg-btn" href="products.html">view all</a>
                                                                </div>
                                                            </li>
                                                        </ul>
                                                    </div>
                                                    <!-- Add other tab panels similarly from the original document -->
                                                    <div role="tabpanel" class="tab-pane" id="biography">
                                                        <ul>
                                                            <li>
                                                                <div class="tg-linkstitle">
                                                                    <h2>History</h2>
                                                                </div>
                                                                <ul>
                                                                    <li><a href="products.html">Veniam quis nostrud</a></li>
                                                                    <li><a href="products.html">Exercitation</a></li>
                                                                    <li><a href="products.html">Laboris nisi ut aliuip</a></li>
                                                                    <li><a href="products.html">Commodo conseat</a></li>
                                                                    <li><a href="products.html">Duis aute irure</a></li>
                                                                </ul>
                                                                <a class="tg-btnviewall" href="products.html">View All</a>
                                                            </li>
                                                            <li>
                                                                <div class="tg-linkstitle">
                                                                    <h2>Architecture</h2>
                                                                </div>
                                                                <ul>
                                                                    <li><a href="products.html">Tough As Nails</a></li>
                                                                    <li><a href="products.html">Pro Grease Monkey</a></li>
                                                                    <li><a href="products.html">Building Memories</a></li>
                                                                    <li><a href="products.html">Bulldozer Boyz</a></li>
                                                                    <li><a href="products.html">Build Or Leave On Us</a></li>
                                                                </ul>
                                                                <a class="tg-btnviewall" href="products.html">View All</a>
                                                            </li>
                                                            <li>
                                                                <div class="tg-linkstitle">
                                                                    <h2>Art Forms</h2>
                                                                </div>
                                                                <ul>
                                                                    <li><a href="products.html">Consectetur adipisicing</a></li>
                                                                    <li><a href="products.html">Aelit sed do eiusmod</a></li>
                                                                    <li><a href="products.html">Tempor incididunt labore</a></li>
                                                                    <li><a href="products.html">Dolore magna aliqua</a></li>
                                                                    <li><a href="products.html">Ut enim ad minim</a></li>
                                                                </ul>
                                                                <a class="tg-btnviewall" href="products.html">View All</a>
                                                            </li>
                                                        </ul>
                                                        <ul>
                                                            <li>
                                                                <figure><img src="${pageContext.request.contextPath}/assets/images/img-01.png" alt="image description"></figure>
                                                                <div class="tg-textbox">
                                                                    <h3>More Than<span>12,0657,53</span>Books Collection</h3>
                                                                    <div class="tg-description">
                                                                        <p>Consectetur adipisicing elit sed doe eiusmod tempor incididunt laebore toloregna aliqua enim.</p>
                                                                    </div>
                                                                    <a class="tg-btn" href="products.html">view all</a>
                                                                </div>
                                                            </li>
                                                        </ul>
                                                    </div>
                                                    <!-- Repeat for other categories as per original document -->
                                                </div>
                                            </div>
                                        </li>
                                        <li class="menu-item-has-children">
                                            <a href="authors">Authors</a>

                                        </li>
                                        <li><a href="ab">AllBook</a></li>
                                        <li><a href="cutomer">Customer</a></li>
                                        <li><a href="${pageContext.request.contextPath}/orders">Order</a></li>
                                            <% } else { %>
                                        <li><a href="ab">AllBook</a></li>
                                            <% }%>
                                    </ul>
                                </div>
                            </nav>
                        </div>
                    </div>
                </div>

            </div>
        </header>




        <!--************************************
                        Header End
        *************************************-->

    </div>
