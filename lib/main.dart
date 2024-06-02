import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app_theme.dart';
import 'firebase_options.dart';
import 'navigation/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MalariaApp());
}

class MalariaApp extends StatelessWidget {
  const MalariaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
    );
  }
}
