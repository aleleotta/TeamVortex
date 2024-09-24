import 'package:flutter/material.dart';

Widget inputField(String? labelName, {bool isPassword = false, TextEditingController? controller}) {
  return SizedBox(
    width: 200,
    child: Center(
      child: TextField(
        controller: controller,
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