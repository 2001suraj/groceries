import 'package:flutter/material.dart';
import 'package:groceries/const/app_color.dart';

class NormalTextField extends StatelessWidget {
  const NormalTextField({super.key, required this.controller, required this.text, this.iconData, this.line});
  final TextEditingController controller;
  final String text;
  final IconData? iconData;
  final int? line;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter your $text';
        }
        return null;
      },
      controller: controller,
      maxLines: line ?? 1,
      decoration: InputDecoration(
        fillColor: AppColor.white,
        filled: true,
        labelText: text,
        prefixIcon: Icon(iconData),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.greyColor),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
