import 'package:go_router/go_router.dart';
import 'package:rbes_for_malaria_diagnosis/screens/admin_dashboard/admin_dashboard.dart';
import 'package:rbes_for_malaria_diagnosis/screens/diagnosis/diagnosis_screen.dart';
import 'package:rbes_for_malaria_diagnosis/screens/forgot_password/forgot_password_page.dart';
import '../main.dart';
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
    GoRoute(
      path: '/staff_overview',
      name: 'staff_overview',
      builder: (context, state) => const StaffOverviewScreen(),
    ),
    GoRoute(
      path: '/patients_overview',
      name: 'patients_overview',
      builder: (context, state) => const PatientsOverviewScreen(),
    ),
    GoRoute(
      path: '/forgot_password',
      name: 'forgot_password',
      builder: (context, state) =>  ForgotPasswordScreen(),
    ),
  ],
);