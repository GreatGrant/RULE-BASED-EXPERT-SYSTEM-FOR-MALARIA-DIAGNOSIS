
import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final TextEditingController controller;
  final void Function(String)? onChanged;

  const SearchBox({
    super.key,
    required this.hintText,
    required this.icon,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0), // Adjust the radius as needed
        color: Colors.grey[200],
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(.2),
            blurRadius: 7.0,
            spreadRadius: 1,
            offset: const Offset(2, 4),
          )
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        cursorColor: Colors.green,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.blueGrey),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.blueGrey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0), // Adjust the radius to match the container
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0), // Adjust the radius to match the container
            borderSide: const BorderSide(color: Colors.green),
          ),
        ),
      ),
    );
  }
}