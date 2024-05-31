import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/user_helper.dart';
PreferredSize buildAppBar(BuildContext context) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(70.0),
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 18.0,
          vertical: 20.0,
        ),
        child: Row(
          children: [
            Builder( // Wrap IconButton with Builder to get the correct context
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer(); // Open the drawer using Scaffold.of(context)
                  },
                );
              },
            ),
            Text(
              "Admin Dashboard",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[900],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}



void _logout(BuildContext context) async{
  UserHelper.logOut();
}