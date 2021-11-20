import 'package:flutter/material.dart';

InputDecoration buildInputDecoration({
  String? hintText,
  Icon? prefixIcon,
}) {
  return InputDecoration(
      prefixIcon: prefixIcon ?? Icon(Icons.edit),
      hintText: hintText ?? "",
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black54),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
      errorStyle: TextStyle(color: Colors.black));
}

InputDecoration buildInputProfileDecoration({String? hintText,}) {
  return InputDecoration(
      hintText: hintText ?? "",
      hintStyle: TextStyle(color: Colors.white),
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(color: Colors.white),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(color: Colors.white),
      ),
      errorStyle: TextStyle(color: Colors.red),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(20)),
    borderSide: BorderSide(color: Colors.white),
  ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      borderSide: BorderSide(color: Colors.white),
    ),
  );
}

bool isEmail(String text) {
  return RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(text);
}