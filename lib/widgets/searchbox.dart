import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final void Function(String)? onChanged;

  const SearchBox({
    super.key,
    required this.hintText,
    required this.icon,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      height: 55.0,
      margin: const EdgeInsets.symmetric(horizontal: 18.0),
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withOpacity(.2),
            blurRadius: 7.0,
            spreadRadius: 1,
            offset: const Offset(2, 4),
          )
        ],
      ),
      child: TextField(
        cursorColor: theme.primaryColor,
        onChanged: onChanged,
        decoration: InputDecoration(
          icon: Icon(icon, size: 25.0,),
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: theme.textTheme.titleMedium,
        ),
      ),
    );
  }
}
