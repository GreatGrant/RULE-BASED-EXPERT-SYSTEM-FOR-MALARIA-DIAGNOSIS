import 'package:go_router/go_router.dart';
import '../screens/admin_screen.dart';
import '../screens/attendant_screen.dart';
import '../main.dart';

final router = GoRouter(
    routes: [
      GoRoute(
          path: '/',
          builder: (context, state) => const LoginSignUpScreen(title: "Welcome")
      ),
      GoRoute(
          path: '/admin',
          name: 'admin',
          builder: (context, state) => const AdminScreen(title: "Admin")
      ),
      GoRoute(
          path: '/attendant',
          name: 'attendant',
          builder: (context, state) => const AttendantScreen(title: "Attendant")
      )
    ]
);