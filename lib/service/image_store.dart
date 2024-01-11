 import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';


class IamgeStorage{
  FirebaseFirestore storage = FirebaseFirestore.instance;

    Future storeImage({
    required File photo,
    required String name,

  }) async {
    try {
      UploadTask? uploadTask;
      var ref = FirebaseStorage.instance.ref().child('product').child(name);
      ref.putFile(photo);
      uploadTask = ref.putFile(photo);
      final snap = await uploadTask.whenComplete(() {});
      final urls = await snap.ref.getDownloadURL();
      var user = await storage.collection('product').doc(name);
      await user.update({'image': urls});
    } catch (e) {
      throw Exception(e.toString());
    }
  }

 Future<void> addPhotos({
    required List<File> photos,
    required String name,
  }) async {
    try {
      List<String> imageUrls = [];

      for (int i = 0; i < photos.length; i++) {
        UploadTask? uploadTask;
        var ref = FirebaseStorage.instance.ref().child('product').child(name + '_$i');
        uploadTask = ref.putFile(photos[i]);
        await uploadTask.whenComplete(() {});
        final url = await ref.getDownloadURL();
        imageUrls.add(url);
      }

      var user = storage.collection('product').doc(name);

      await user.update({'photo': FieldValue.arrayUnion(imageUrls)});
    } catch (e) {
      throw Exception(e.toString());
    }
  }

}