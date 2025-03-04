
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obsecureText;

  const MyTextfield({super.key, required this.controller, required this.hintText, required this.obsecureText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white54, // Change to your preferred color
        borderRadius: BorderRadius.circular(10), // Optional: Rounded corners
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText:hintText,
          border: InputBorder.none, // Removes the default underline
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        ),
      ),
    );
  }
}
