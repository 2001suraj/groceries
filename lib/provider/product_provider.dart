import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productDataProvider = StreamProvider<QuerySnapshot>((ref) {
  return FirebaseFirestore.instance.collection('product').snapshots();
});
final cartDataProvider = StreamProvider<QuerySnapshot>((ref) {
  return FirebaseFirestore.instance.collection('orders').snapshots();
});




final selectedChipProvider = StateNotifierProvider.autoDispose<SelectChip, List<String>>((ref) => SelectChip());

class SelectChip extends StateNotifier<List<String>> {
  SelectChip() : super([]);

  void addId1(String id) {
    if (state.contains(id)) {
      var stcpy = state.toSet().toList();
      state = stcpy.where((item) => item != id).toSet().toList();
      log(' State new length is ${state.length} and items are  $state');
    } else {
      state = [...state, id];
      log('  else not contained State new length is ${state.length} and items are  $state');
    }
  }

 void removeAll() {
    state = [];

    log(' State new length is ${state.length} and items are  $state');
  }



}
