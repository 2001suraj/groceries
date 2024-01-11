import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ProductModel {
  String? name;
  String? image;
  String? description;
  String? price;
  String? rating;
  String? category;
  List<dynamic>? photo;

  ProductModel({
    this.name,
    this.image,
    this.price,
    this.rating,
    this.category,
   
    this.description,
   
    this.photo,
   
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'image': image,
      'description': description,
      'price': price,
      'rating': rating,
      'category': category,
      'photo': photo,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      name: map['name'] != null ? map['name'] as String : null,
      image: map['image'] != null ? map['image'] as String : null,
      description: map['description'] != null ? map['description'] as String : null,
      price: map['price'] != null ? map['price'] as String : null,
      rating: map['rating'] != null ? map['rating'] as String : null,
      category: map['category'] != null ? map['category'] as String : null,
      photo: map['photo'] != null ? List<dynamic>.from((map['photo'] as List<dynamic>)) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) => ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
