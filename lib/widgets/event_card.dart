import 'package:rbes_for_malaria_diagnosis/models/event.dart';
import 'package:rbes_for_malaria_diagnosis/screens/admin_details.dart';
import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final Event event;
  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EventDetail(event: event),
        ),
      ),
      child: Container(
        width: 180.0,
        padding: const EdgeInsets.fromLTRB(15.0, 20, 15, 12),
        margin: const EdgeInsets.only(right: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: event.isActive ? theme.primaryColor : theme.cardColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              event.title == "Register"
                  ? Icons.app_registration
                  : Icons.health_and_safety,
              size: 25.0,
              color: event.isActive ? Colors.white : theme.primaryColor,
            ),
            Text(
              event.title,
              style: theme.textTheme.bodySmall?.copyWith(
                color: event.isActive ? Colors.white : null,
                fontSize: 20
              ),
            ),
            SizedBox(
              width: 20.0,
              child: Divider(
                color:event.isActive? Colors.white : theme.primaryColor,
                thickness: 5,
              ),
            ),
            // Card(
            //   color:event.isActive ? theme.cardColor.withOpacity(.2) : theme.primaryColor,
            //   elevation: 0.0,
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(12.0),
            //   ),
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(
            //       horizontal: 12.0,
            //       vertical: 4.0,
            //     ),
            //     child: Text(
            //       "GOING",
            //       style: theme.textTheme.bodyText1?.copyWith(
            //         color: event.isActive ? Colors.white : null,
            //       ),
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}