import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rbes_for_malaria_diagnosis/screens/admin_dashboard/admin_dashboard.dart';
import 'package:rbes_for_malaria_diagnosis/screens/diagnosis/diagnosis_screen.dart';
import 'package:rbes_for_malaria_diagnosis/screens/forgot_password/forgot_password_page.dart';
import '../screens/edit_staff/edit_staff_details.dart';
import '../screens/home/login_signup_screen.dart';
import '../screens/manage_patients/manage_patients.dart';
import '../screens/manage_staff/manage_staff.dart';
import '../screens/patient_overview/patients_overview_screen.dart';
import '../screens/staff_overview/staff_overview_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LoginSignUpScreen(title: "Welcome"),
      pageBuilder: (context, state) {
        return const CustomTransitionPage(
          child: LoginSignUpScreen(title: "Welcome"),
          transitionsBuilder: _fadeTransition,
        );
      },
    ),
    GoRoute(
      path: '/admin',
      name: 'admin',
      builder: (context, state) => const AdminDashboard(),
      pageBuilder: (context, state) {
        return const CustomTransitionPage(
          child: AdminDashboard(),
          transitionsBuilder: _slideTransition,
        );
      },
    ),
    GoRoute(
      path: '/manage_patients',
      name: 'manage_patients',
      builder: (context, state) => const ManagePatients(),
      pageBuilder: (context, state) {
        return const CustomTransitionPage(
          child: ManagePatients(),
          transitionsBuilder: _slideTransition,
        );
      },
    ),
    GoRoute(
      path: '/diagnosis/:patientId',
      builder: (context, state) {
        final patientId = state.pathParameters['patientId'] ?? '';
        return DiagnosisScreen(patientId: patientId);
      },
      pageBuilder: (context, state) {
        final patientId = state.pathParameters['patientId'] ?? '';
        return CustomTransitionPage(
          child: DiagnosisScreen(patientId: patientId),
          transitionsBuilder: _fadeTransition,
        );
      },
    ),
    GoRoute(
      path: '/manage_staff',
      name: 'manage_staff',
      builder: (context, state) => const ManageStaff(),
      pageBuilder: (context, state) {
        return const CustomTransitionPage(
          child: ManageStaff(),
          transitionsBuilder: _slideTransition,
        );
      },
    ),
    GoRoute(
      path: '/edit_staff/:staffId',
      builder: (context, state) {
        final staffId = state.pathParameters['staffId'] ?? '';
        final name = state.uri.queryParameters['name'] ?? '';
        final email = state.uri.queryParameters['email'] ?? '';
        return EditStaffDetailsPage(staffId: staffId,  name: name, email: email,);
      },
      pageBuilder: (context, state) {
        final staffId = state.pathParameters['staffId'] ?? '';
        final name = state.uri.queryParameters['name'] ?? '';
        final email = state.uri.queryParameters['email'] ?? '';
        return CustomTransitionPage(
          child: EditStaffDetailsPage(staffId: staffId, name: name, email: email),
          transitionsBuilder: _fadeTransition,
        );
      },
    ),
    GoRoute(
      path: '/staff_overview',
      name: 'staff_overview',
      builder: (context, state) => const StaffOverviewScreen(),
      pageBuilder: (context, state) {
        return const CustomTransitionPage(
          child: StaffOverviewScreen(),
          transitionsBuilder: _slideTransition,
        );
      },
    ),
    GoRoute(
      path: '/patients_overview',
      name: 'patients_overview',
      builder: (context, state) => const PatientsOverviewScreen(),
      pageBuilder: (context, state) {
        return const CustomTransitionPage(
          child: PatientsOverviewScreen(),
          transitionsBuilder: _slideTransition,
        );
      },
    ),
    GoRoute(
      path: '/forgot_password',
      name: 'forgot_password',
      builder: (context, state) => ForgotPasswordScreen(),
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          child: ForgotPasswordScreen(),
          transitionsBuilder: _fadeTransition,
        );
      },
    ),
  ],
);

Widget _fadeTransition(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
  return FadeTransition(
    opacity: animation,
    child: child,
  );
}

Widget _slideTransition(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
  const begin = Offset(1.0, 0.0);
  const end = Offset.zero;
  const curve = Curves.ease;

  final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

  final offsetAnimation = animation.drive(tween);

  return SlideTransition(
    position: offsetAnimation,
    child: child,
  );
}
