import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:salonika/core/repo/user_repo.dart';
import 'package:salonika/core/services/user_services.dart';
import 'package:salonika/features/auth/auth_view_model/auth_vm.dart';
import 'package:salonika/utils/local_storage.dart';
import 'package:salonika/utils/splash_screen.dart'; // Make sure the class name matches
import 'firebase_options.dart'; // created by flutterfire

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with generated options
  await Firebase.initializeApp();
  await LocalStorageService().init();
  // Start the app (you forgot this!)
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(AuthService(), UserRepository()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Salonika App',
      // Ensure the class name matches the import. If your widget is SplashScreen (two e's), use that.
      home: SplashScreeen(),
    );
  }
}
