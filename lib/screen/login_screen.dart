import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groceries/const/app_color.dart';
import 'package:groceries/const/app_sized.dart';
import 'package:groceries/helper/local_store.dart';
import 'package:groceries/provider/base_provider.dart';
import 'package:groceries/screen/home_scren.dart';
import 'package:groceries/screen/sign_up_screen.dart';
import 'package:groceries/service/user_auth_service.dart';
import 'package:groceries/widget/snack_bar.dart';
import 'package:groceries/widget/text_field.dart';
import 'package:groceries/widget/title_text.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final GlobalKey<FormState> key = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(isLoadingProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                titles(text: "Login", size: 40, weight: FontWeight.w800, color: AppColor.primaryColor),
                titles(text: "Welcome!", size: 30, weight: FontWeight.w600),
                titles(text: "Log in or create your account", size: 20, weight: FontWeight.w400),
                imageStack(),
                Container(
                  padding: EdgeInsets.only(bottom: 10, top: 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColor.bgColor,
                  ),
                  child: Form(
                    key: key,
                    child: Column(
                      children: [
                        // AppSize.normalheight,
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
                          child: Material(
                            elevation: 4,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            shadowColor: AppColor.red,
                            borderOnForeground: false,
                            child: NormalTextField(
                              controller: email,
                              text: 'email',
                              iconData: Icons.person,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: Material(
                            elevation: 4,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            shadowColor: AppColor.red,
                            borderOnForeground: false,
                            child: NormalTextField(
                              controller: password,
                              text: 'password',
                              iconData: Icons.lock,
                            ),
                          ),
                        ),
                        AppSize.minheight,
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: titles(text: "Forget Password?", color: AppColor.blue),
                          ),
                        ),
                        AppSize.minheight,
                        GestureDetector(
                          onTap: () async {
                            if (key.currentState!.validate()) {
                              try {
                                ref.read(isLoadingProvider.notifier).state = true;
                                var response = await UserAuthService().login(email: email.text, password: password.text);
                                log(response.refreshToken.toString());
                                if (response.refreshToken != 'null') {
                                  await LocalStorage().savetoken(key: 'email', token: email.text);

                                 await  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                                }
                                ref.read(isLoadingProvider.notifier).state = false;
                              } on FirebaseAuthException catch (e) {
                                log('FirebaseAuthException: ${e.message}');
                                ref.read(isLoadingProvider.notifier).state = false;

                                showsnackBar(context: context, text: 'Invalid credentails', color: Colors.red, textColor: Colors.white);
                              }
                            }
                          },
                          child: Container(
                            width: 200,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColor.primaryColor,
                                  AppColor.blue,
                                ],
                              ),
                            ),
                            alignment: Alignment.center,
                            child: isLoading
                                ? CircularProgressIndicator(
                                    color: AppColor.white,
                                  )
                                : titles(text: "Login", color: AppColor.white, weight: FontWeight.w500, size: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                AppSize.normalheight,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    titles(text: "Don't have an account ?"),
                    AppSize.minwidth,
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
                      },
                      child: titles(text: "Sign up ", weight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Stack imageStack() {
    return const Stack(
      children: [
        SizedBox(
          height: 280,
          width: double.infinity,
        ),
        Positioned(
          top: 20,
          left: 40,
          child: Image(
            height: 80,
            width: 80,
            image: AssetImage('assets/images/avocado.jpeg'),
          ),
        ),
        Positioned(
          top: 20,
          right: 40,
          child: Image(
            height: 100,
            width: 100,
            image: AssetImage('assets/images/banana.jpeg'),
          ),
        ),
        Positioned(
          bottom: 40,
          left: 10,
          child: Image(
            height: 100,
            width: 100,
            image: AssetImage('assets/images/chicken.jpeg'),
          ),
        ),
        Positioned(
          top: 150,
          right: 100,
          child: Image(
            height: 100,
            width: 100,
            image: AssetImage('assets/images/1.jpeg'),
          ),
        ),
        Positioned(
          bottom: 90,
          left: 100,
          child: Image(
            height: 100,
            width: 100,
            image: AssetImage('assets/images/2.jpeg'),
          ),
        ),
        Positioned(
          bottom: 20,
          right: 10,
          child: Image(
            height: 100,
            width: 100,
            image: AssetImage('assets/images/water.jpeg'),
          ),
        ),
      ],
    );
  }
}
