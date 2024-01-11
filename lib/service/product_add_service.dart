import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groceries/model/product_model.dart';

class ProductAddService {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> addProduct(ProductModel model) async {
    await firebaseFirestore.collection('product').doc(model.name).set(
      {
        "name": model.name,
        "image": '',
        "rating": model.rating,
        "category": model.category,
        "price": model.price,
        "description": model.description,
        "photo": [],
      },
    );
  }

  Future<void> addOrder({  required  String userId, required  ProductModel items,required  String totalAmount ,required String itemLength}) async {
    try {
      await firebaseFirestore.collection('orders').add({
        'userId': userId,
        'itemLength':itemLength,

        'items': items.toJson(),
        'totalAmount': totalAmount,
        'orderDate': FieldValue.serverTimestamp(),
      });
      log("added to cart");
    } catch (e) {
      log('Error adding order: $e');
    }
  }

  Future<void> deleteOrder(String id) async {
    try {
      await firebaseFirestore.collection('orders').doc(id).delete();
    } catch (e) {
      log("error message $e ");
    }
  }
}
