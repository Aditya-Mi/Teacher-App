import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isObscureText;
  final String? Function(String?)? validator;
  const CustomField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isObscureText = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        focusedErrorBorder: border(Colors.red),
        focusedBorder: border(Colors.blue),
        enabledBorder: border(Colors.grey),
        errorBorder: border(Colors.red),
      ),
      validator: validator ??
          (value) {
            if (value!.isEmpty) {
              return "$hintText is missing!";
            }
            return null;
          },
      obscureText: isObscureText,
    );
  }

  OutlineInputBorder border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: color),
    );
  }
}
