import 'package:flutter/material.dart';

class CustomTabBarView extends StatelessWidget {
  final TabController controller;
  final List<Widget> children;

  const CustomTabBarView({
    super.key,
    required this.controller,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 150.0,
      margin: const EdgeInsets.only(left: 18.0),
      child: TabBarView(
        controller: controller,
        children: children,
      ),
    );
  }
}
