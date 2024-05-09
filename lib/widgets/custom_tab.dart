import 'package:flutter/material.dart';

class CustomTabBar extends StatelessWidget {
  final TabController controller;
  final List<String> tabTitles;
  final TextStyle? labelStyle;
  final TextStyle? unselectedLabelStyle;
  final Color? indicatorColor;
  final Color? labelColor;
  final Color? unselectedLabelColor;

  const CustomTabBar({
    super.key,
    required this.controller,
    required this.tabTitles,
    this.labelStyle,
    this.unselectedLabelStyle,
    this.indicatorColor,
    this.labelColor,
    this.unselectedLabelColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Align(
      alignment: Alignment.topLeft,
      child: TabBar(
        controller: controller,
        labelStyle: labelStyle ?? theme.textTheme.headlineMedium,
        unselectedLabelStyle: unselectedLabelStyle ?? theme.textTheme.titleMedium,
        isScrollable: true,
        indicatorColor: indicatorColor ?? Colors.blueGrey[900],
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: labelColor ?? Colors.blueGrey[900],
        unselectedLabelColor: unselectedLabelColor ?? Colors.blueGrey[500],
        tabs: tabTitles.map((title) => Tab(text: title)).toList(),
      ),
    );
  }
}
