import 'dart:convert';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {

    String id;
    String name;
    double price;
    bool stock;
    String photo;
    
    Product({
        this.id,
        this.name ='',
        this.price = 0,
        this.stock = false,
        this.photo,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        price: json["price"].toDouble(),
        stock: json["stock"],
        photo: json["photo"],
    );

    Map<String, dynamic> toJson() => {
        //"id": id,
        "name": name,
        "price": price,
        "stock": stock,
        "photo": photo,
    };
}