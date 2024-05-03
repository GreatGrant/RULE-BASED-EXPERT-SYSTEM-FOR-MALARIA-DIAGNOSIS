import 'package:flutter/material.dart';

import '../models/user_info.dart';

class GuestListTab extends StatelessWidget {
  const GuestListTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView.builder(
      itemCount: friendList.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        var friend = friendList[index];
        return ListTile(
          leading: CircleAvatar(
            radius: 27.0,
            backgroundImage: AssetImage(friend.image),
          ),
          title: Text(
            friend.name,
            style: theme.textTheme.bodyLarge,
          ),
          subtitle: Text(
            "Joined in ${friend.date}",
            style: theme.textTheme.titleMedium,
          ),
        );
      },
    );
  }
}