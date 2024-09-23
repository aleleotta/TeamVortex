import 'package:flutter/material.dart';

Widget inputField(String? labelName, {bool isPassword = false}) {
  return SizedBox(
    width: 200,
    child: Center(
      child: TextField(
        decoration: InputDecoration(
          labelText: labelName,
          border: const OutlineInputBorder(),
        ),
        obscureText: isPassword,
      ),
    )
  );
}

Text errorMessage(String message) {
  return Text(
    message,
    style: const TextStyle(
      color: Colors.red,
      fontWeight: FontWeight.bold
    ),
  );
}