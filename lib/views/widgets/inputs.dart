import 'package:flutter/material.dart';

Widget inputField(String? parameterName, {bool isPassword = false}) {
  return SizedBox(
    width: 200,
    child: Center(
      child: TextField(
        decoration: InputDecoration(
          labelText: parameterName,
          border: const OutlineInputBorder(),
        ),
        obscureText: isPassword,
      ),
    )
  );
}