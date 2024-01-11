import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groceries/const/app_color.dart';
import 'package:groceries/const/app_sized.dart';
import 'package:groceries/helper/local_store.dart';
import 'package:groceries/model/user_model.dart';
import 'package:groceries/provider/base_provider.dart';
import 'package:groceries/screen/home_scren.dart';
import 'package:groceries/screen/login_screen.dart';
import 'package:groceries/service/user_auth_service.dart';
import 'package:groceries/service/user_store_service.dart';
import 'package:groceries/widget/snack_bar.dart';
import 'package:groceries/widget/text_field.dart';
import 'package:groceries/widget/title_text.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<SignUpScreen> {
  final GlobalKey<FormState> key = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController phone = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(isLoadingProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  titles(text: "Welcome To ", size: 35, weight: FontWeight.w800, color: AppColor.primaryColor),
                  titles(text: "Groceries", size: 30, weight: FontWeight.w600),
                  titles(text: "Let's start by getting your account setup", size: 18, weight: FontWeight.w400),
                  const Row(
                    children: [
                      Image(
                        height: 150,
                        width: 200,
                        image: AssetImage('assets/images/4.jpeg'),
                      ),
                      Image(
                        height: 150,
                        width: 150,
                        image: AssetImage('assets/images/3.jpeg'),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 5),
                        child: Material(
                          elevation: 4,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          shadowColor: AppColor.red,
                          borderOnForeground: false,
                          child: NormalTextField(
                            controller: name,
                            text: 'Username',
                            iconData: Icons.person,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 5),
                        child: Material(
                          elevation: 4,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          shadowColor: AppColor.red,
                          borderOnForeground: false,
                          child: NormalTextField(
                            controller: email,
                            text: 'email',
                            iconData: Icons.mail,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 5),
                        child: Material(
                          elevation: 4,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          shadowColor: AppColor.red,
                          borderOnForeground: false,
                          child: NormalTextField(
                            controller: phone,
                            text: 'mobile number',
                            iconData: Icons.phone,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 5),
                        child: Material(
                          elevation: 4,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          shadowColor: AppColor.red,
                          borderOnForeground: false,
                          child: NormalTextField(
                            controller: location,
                            text: 'current address',
                            iconData: Icons.location_on,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 5),
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
                      AppSize.maxheight,
                      GestureDetector(
                        onTap: () async {
                          if (key.currentState!.validate()) {
                            try {
                              ref.read(isLoadingProvider.notifier).state = true;
                              var response = await UserAuthService().signin(email: email.text, password: password.text);
                              log(response.refreshToken.toString());
                              if (response.refreshToken != 'null') {
                                await LocalStorage().savetoken(key: 'email', token: email.text);

                                UserModel model = UserModel(email: email.text, phone: phone.text, name: name.text,address: location.text);
                                await UserStoreService().addUser(model);

                                await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
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
                          padding: EdgeInsets.all(10),
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
                              ? CircularProgressIndicator()
                              : titles(text: "Sign Up", color: AppColor.white, weight: FontWeight.w500, size: 20),
                        ),
                      ),
                    ],
                  ),
                  AppSize.normalheight,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      titles(text: "Already have an account ?"),
                      AppSize.minwidth,
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                        },
                        child: titles(text: "Log In ", weight: FontWeight.bold),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
