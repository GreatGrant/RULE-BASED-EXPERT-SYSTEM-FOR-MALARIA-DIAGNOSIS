import 'package:rbes_for_malaria_diagnosis/models/user_info.dart';
import 'package:flutter/material.dart';

import 'event_card.dart';

class UserEventTabBarView extends StatelessWidget {
  final List<UserInfo> events;

  const UserEventTabBarView({super.key, required this.events});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: events.length,
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        var event = events[index];
        return UserEventCard(event: event);
      },
    );
  }
}