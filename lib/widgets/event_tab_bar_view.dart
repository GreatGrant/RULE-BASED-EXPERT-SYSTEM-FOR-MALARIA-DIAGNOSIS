import 'package:rbes_for_malaria_diagnosis/models/event.dart';
import 'package:flutter/material.dart';

import 'event_card.dart';

class EventTabBarView extends StatelessWidget {
  final List<Event> events;

  const EventTabBarView({super.key, required this.events});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: events.length,
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        var event = events[index];
        return EventCard(event: event);
      },
    );
  }
}