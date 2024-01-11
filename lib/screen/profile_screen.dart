import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groceries/const/app_color.dart';
import 'package:groceries/helper/local_store.dart';
import 'package:groceries/model/user_model.dart';
import 'package:groceries/screen/login_screen.dart';
import 'package:groceries/service/user_auth_service.dart';
import 'package:groceries/widget/title_text.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key, required this.model});
  final UserModel model;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: titles(text: "Profile")),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(),
              CircleAvatar(
                radius: 70,
                backgroundColor: AppColor.bgColor,
                backgroundImage: NetworkImage(
                    "https://images.unsplash.com/photo-1633332755192-727a05c4013d?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8dXNlcnxlbnwwfHwwfHx8MA%3D%3D"),
              ),
              Divider(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: titles(text: 'Name :'),
                    title: titles(text: model.name ?? 'Na'),
                  ),
                  ListTile(
                    leading: titles(text: 'Email :'),
                    title: titles(text: model.email ?? 'Na'),
                  ),
                  ListTile(
                    leading: titles(text: 'Phone Number :'),
                    title: titles(text: model.phone ?? 'Na'),
                  ),
                  ListTile(
                    leading: titles(text: 'Address :'),
                    title: titles(text: model.address ?? 'Na'),
                  ),
                ],
              ),
              Divider(),
              MaterialButton(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: AppColor.red),
                  borderRadius: BorderRadius.circular(20),
                ),
                onPressed: () async {
                  await UserAuthService().logout();
                  await LocalStorage().clear(key: 'email');
                  await Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                },
                child: titles(text: "Logout", color: AppColor.red),
              ),
              Spacer(),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
