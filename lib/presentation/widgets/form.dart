import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obsecureText;
  final IconData prefixIcon;
  CustomTextFormField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.prefixIcon,
    this.obsecureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        validator: (value) => value == '' ? 'Input cannot be null' : null,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              15,
            ),
          ),
          labelText: labelText,
          isDense: true,
          prefixIcon: Icon(prefixIcon),
        ),
        obscureText: obsecureText,
      ),
    );
  }
}

class HistoryTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obsecureText;
  final IconData prefixIcon;
  TextInputType inputType;
  HistoryTextFormField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.prefixIcon,
    this.obsecureText = false,
    this.inputType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              15,
            ),
          ),
          labelText: labelText,
          isDense: true,
          prefixIcon: Icon(prefixIcon),
        ),
        obscureText: obsecureText,
      ),
    );
  }
}
