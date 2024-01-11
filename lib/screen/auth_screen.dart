import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groceries/screen/home_scren.dart';
import 'package:groceries/screen/introduction_screen.dart';
import 'package:groceries/screen/login_screen.dart';

class AuthScreen extends ConsumerWidget {
  static const routeName = 'AuthScreen';
  AuthScreen({super.key});
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (auth.currentUser != null) {
      return HomeScreen();
    }
    return IntroScreen();
  }
}
