import 'package:go_router/go_router.dart';
import 'package:untitled/screens/main.dart';

import '../screens/admin_screen.dart';
import '../screens/attendant_screen.dart';

final router = GoRouter(
    routes: [
      GoRoute(
          path: '/',
          builder: (context, state) => const LoginScreen()
      ),
      GoRoute(
          path: '/admin',
          name: 'admin',
          builder: (context, state) => const AdminScreen()
      ),
      GoRoute(
          path: '/attendant',
          name: 'attendant',
          builder: (context, state) => const AttendantScreen()
      )
    ]
);