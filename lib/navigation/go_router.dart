import 'package:go_router/go_router.dart';
import 'package:rbes_for_malaria_diagnosis/screens/admin_dashboard.dart';
import 'package:rbes_for_malaria_diagnosis/screens/fake_diagn.dart';
import '../main.dart';
import '../screens/edit_staff_details.dart';
import '../screens/manage_patients.dart';
import '../screens/manage_staff.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LoginSignUpScreen(title: "Welcome"),
    ),
    GoRoute(
      path: '/admin',
      name: 'admin',
      builder: (context, state) => const AdminDashboard(),
    ),
    GoRoute(
      path: '/manage_patients',
      name: 'manage_patients',
      builder: (context, state) => const ManagePatients(),
    ),
    GoRoute(
      path: '/diagnosis/:patientId',
      builder: (context, state) {
        final patientId = state.pathParameters['patientId'] ?? '';
        return DiagnosisScreen(patientId: patientId);
      },
    ),
    GoRoute(
      path: '/manage_staff',
      name: 'manage_staff',
      builder: (context, state) => const ManageStaff(),
    ),
    GoRoute(
      path: '/edit_staff/:staffId',
      builder: (context, state) {
        final staffId = state.pathParameters['staffId'] ?? '';
        final name = state.uri.queryParameters['name'] ?? '';
        final email = state.uri.queryParameters['email'] ?? '';
        return EditStaffDetailsPage(staffId: staffId,  name: name, email: email,);
      },
    ),
  ],
);