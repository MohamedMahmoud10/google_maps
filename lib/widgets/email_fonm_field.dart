import 'package:flutter/material.dart';

class EmailFormField extends StatelessWidget {
  final String hitText;
  final String label;
  final Widget prefixIcon;
  final TextEditingController emailController;
  final ValueChanged<String> onChanged;
  final FormFieldValidator<String> validator;
  final TextInputType keyboardType;
  final ValueChanged<String> onFieldSubmitted;

  const EmailFormField(
      {Key? key,
      required this.hitText,
      required this.label,
      required this.prefixIcon,
      required this.emailController,
      required this.onChanged,
      required this.validator,
      required this.keyboardType,
      required this.onFieldSubmitted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: TextFormField(
        keyboardType: keyboardType,
        validator: validator,
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
        controller: emailController,
        decoration: InputDecoration(
          label: Text(label),
          labelStyle: const TextStyle(color: Colors.white),
          hintStyle: const TextStyle(color: Colors.white),
          hintText: hitText,
          prefixIcon: prefixIcon,
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.green),
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.purple),
              borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }
}
