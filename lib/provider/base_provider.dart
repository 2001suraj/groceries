import 'package:flutter_riverpod/flutter_riverpod.dart';

final isLoadingProvider = StateProvider<bool>((ref) {
  return false;
});
final imageIndexProvider = StateProvider<int>((ref) {
  return 1;
});
final itemProvider = StateProvider<int>((ref) {
  return 1;
});
final showMoreProvider = StateProvider<bool>((ref) {
  return false;
});
