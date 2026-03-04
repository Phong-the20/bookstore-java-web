/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author ADMIN
 */
public class Book {

    //Lấy từ bảng product 5 thuộc tính: sku, img,name,price,quantity
    private String sku_product;
    private String img;
    private String name_product;
    private double price_product;
    private int quantity_product; // số lượng này là số lượng tồn(product) phải trừ số lượng đã bán(orderDetails) qua sku
    private String description;

    //Lấy từ bảng category thuộc tính: name
    private String category_name;

    //Lấy từ bảng Author thuộc tính: name
    private String author_name;

    //Lấy từ bảng orderDetails thuộc tính: quantity
    private int quantity_orderDetail;
    private ProductDetail productDetail;

    public Book() {
    }

    public Book(String sku_product, String img, String name_product, double price_product, int quantity_product, String description, String category_name, String author_name, int quantity_orderDetail, ProductDetail productDetail) {
        this.sku_product = sku_product;
        this.img = img;
        this.name_product = name_product;
        this.price_product = price_product;
        this.quantity_product = quantity_product;
        this.description = description;
        this.category_name = category_name;
        this.author_name = author_name;
        this.quantity_orderDetail = quantity_orderDetail;
        this.productDetail = productDetail;
    }

    public String getSku_product() {
        return sku_product;
    }

    public void setSku_product(String sku_product) {
        this.sku_product = sku_product;
    }

    public String getImg() {
        return img;
    }

    public void setImg(String img) {
        this.img = img;
    }

    public String getName_product() {
        return name_product;
    }

    public void setName_product(String name_product) {
        this.name_product = name_product;
    }

    public double getPrice_product() {
        return price_product;
    }

    public void setPrice_product(double price_product) {
        this.price_product = price_product;
    }

    public int getQuantity_product() {
        return quantity_product;
    }

    public void setQuantity_product(int quantity_product) {
        this.quantity_product = quantity_product;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getCategory_name() {
        return category_name;
    }

    public void setCategory_name(String category_name) {
        this.category_name = category_name;
    }

    public String getAuthor_name() {
        return author_name;
    }

    public void setAuthor_name(String author_name) {
        this.author_name = author_name;
    }

    public int getQuantity_orderDetail() {
        return quantity_orderDetail;
    }

    public void setQuantity_orderDetail(int quantity_orderDetail) {
        this.quantity_orderDetail = quantity_orderDetail;
    }

    public ProductDetail getProductDetail() {
        return productDetail;
    }

    public void setProductDetail(ProductDetail productDetail) {
        this.productDetail = productDetail;
    }

    @Override
    public String toString() {
        return "Book{" + "sku_product=" + sku_product + ", img=" + img + ", name_product=" + name_product + ", price_product=" + price_product + ", quantity_product=" + quantity_product + ", description=" + description + ", category_name=" + category_name + ", author_name=" + author_name + ", quantity_orderDetail=" + quantity_orderDetail + '}';
    }

}
