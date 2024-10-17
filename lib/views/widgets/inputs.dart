import 'package:flutter/material.dart';

Widget inputField(String? labelName, {bool isPassword = false, TextEditingController? controller, double maxWidth = 200}) {
  return SizedBox(
    width: maxWidth,
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