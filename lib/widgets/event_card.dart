import 'package:rbes_for_malaria_diagnosis/models/user_info.dart';
import 'package:rbes_for_malaria_diagnosis/screens/admin_details.dart';
import 'package:flutter/material.dart';
import 'package:rbes_for_malaria_diagnosis/screens/manage_patients.dart';

class UserEventCard extends StatelessWidget {
  final UserInfo event;
  const UserEventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ManagePatients(),
        ),
      ),
      child: Container(
        width: 180.0,
        padding: const EdgeInsets.fromLTRB(15.0, 20, 15, 12),
        margin: const EdgeInsets.only(right: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.blueGrey[900],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              event.title.contains("Register")
                  ? Icons.app_registration
                  : Icons.health_and_safety,
              size: 25.0,
              color: Colors.white,
            ),
            Text(
              event.title,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white,
                fontSize: 20
              ),
            ),
            const SizedBox(
              width: 20.0,
              child: Divider(
                color: Colors.white,
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