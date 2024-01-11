import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groceries/model/user_model.dart';

class UserStoreService {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> addUser(UserModel model) async {
    await firebaseFirestore.collection('user').doc(model.email).set(
      {
        "name": model.name,
        "email": model.email,
        "phone": model.phone,
        "address": model.address,
      },
    );
  }

 
}
