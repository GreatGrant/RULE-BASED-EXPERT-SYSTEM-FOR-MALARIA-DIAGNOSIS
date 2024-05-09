import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/user_helper.dart';

Drawer buildDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          child: const Text(
            'Menu',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Logout'),
          onTap: () {
            _logout(context);
          },
        ),
      ],
    ),
  );
}


void _logout(BuildContext context) async{
  UserHelper.logOut();
}