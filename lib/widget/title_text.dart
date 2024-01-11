import 'package:flutter/material.dart';

Text titles({required String text, double? size, FontWeight? weight, Color? color}) {
  return Text(
    text,
    style: TextStyle(fontSize: size ?? 16, fontWeight: weight ?? FontWeight.normal, color: color ?? Colors.black),
  );
}
