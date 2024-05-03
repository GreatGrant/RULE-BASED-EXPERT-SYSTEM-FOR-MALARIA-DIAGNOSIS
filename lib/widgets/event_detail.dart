import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class EventDetailTab extends StatelessWidget {
  const EventDetailTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 25.0),
          ListTile(
            leading: const CircleAvatar(
              radius: 26.0,
              backgroundImage: AssetImage("assets/5.jpg"),
            ),
            title: Text("Jessica Veranda", style: theme.textTheme.bodyLarge),
            subtitle: Text("Host", style: theme.textTheme.titleMedium),
          ),
          Divider(color: theme.primaryColor),
          ListTile(
            leading: SvgPicture.asset(
              "assets/location.svg",
              width: 25.0,
            ),
            title: Text(
              "48 Cambridge Street CLARENDON 2756 New South Wales",
              style: theme.textTheme.titleSmall,
            ),
          ),
          Divider(color: theme.primaryColor),
          ListTile(
            leading: SvgPicture.asset(
              "assets/menu.svg",
              width: 25.0,
            ),
            title: Text(
              "Snaks a buffet and drinks will be provided",
              style: theme.textTheme.titleMedium,
            ),
          ),
          Divider(color: theme.primaryColor),
          ListTile(
            leading: SvgPicture.asset(
              "assets/gift.svg",
              width: 25.0,
            ),
            title: Text(
              "No presents, just your presence",
              style: theme.textTheme.titleMedium,
            ),
          ),
          Divider(color: theme.primaryColor),
        ],
      ),
    );
  }
}