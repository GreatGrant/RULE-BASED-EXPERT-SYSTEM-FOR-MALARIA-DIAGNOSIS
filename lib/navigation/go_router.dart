import 'package:go_router/go_router.dart';
import 'package:rbes_for_malaria_diagnosis/screens/admin_dashboard.dart';
import '../main.dart';
import '../screens/fake_diagn.dart';


final router = GoRouter(
    routes: [
          GoRoute(
              path: '/',
              builder: (context, state) => const LoginSignUpScreen(title: "Welcome")
          ),
          GoRoute(
              path: '/admin',
              name: 'admin',
              builder: (context, state) => const AdminDashboard()
          ),
          GoRoute(
                path: '/diagnosis/:patientId',
                builder: (context, state) {
                      final patientId = state.pathParameters['patientId'] ?? '';
                      return DiagnosisScreen(patientId: patientId);
                },
          ),
    ]
);