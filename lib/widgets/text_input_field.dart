import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final bool isPass;
  final TextInputType textInputType;
  const TextInputField({
    Key? key,
    required this.textEditingController,
    required this.hintText,
    this.isPass = false,
    required this.textInputType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputBorder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return TextField(
      autofocus: false,
      controller: textEditingController,
      obscureText: isPass,
      keyboardType: textInputType,
      decoration: InputDecoration(
        border: inputBorder,
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color.fromARGB(255, 0, 0, 0),
        ),
        filled: true,
        fillColor: const Color.fromARGB(255, 255, 255, 255),
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        contentPadding: const EdgeInsets.all(8.0),
      ),
    );
  }
}
