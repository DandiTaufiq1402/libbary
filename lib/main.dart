import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import biometric
import 'core/services/biometric_lock_provider.dart';
import 'core/widgets/biometric_lock_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(); // kalau pakai Firebase

  runApp(
    MultiProvider(
      providers: [
        // Tambahkan provider lain di sini (Theme, Auth, dll)

        // Provider Biometrik
        ChangeNotifierProvider(
          create: (_) => BiometricLockProvider()..initialize(),
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
      title: 'Pasar Malam',

      // Wrap seluruh app dengan biometric lock
      builder: (context, child) =>
          BiometricLockScreen(child: child ?? const SizedBox()),

      // Contoh home (ganti sesuai app kamu)
      home: const Scaffold(
        body: Center(
          child: Text('App Ready'),
        ),
      ),
    );
  }
}