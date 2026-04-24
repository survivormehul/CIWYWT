import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'data/services/auth_service.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/login_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase initialization. 
  // NOTE: User must configure Firebase locally using `flutterfire configure` 
  // before running, since we don't have the google-services.json generated yet.
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase not initialized: $e");
    // Fallback or ignore for UI development without Firebase config
  }
  
  runApp(const ProviderScope(child: CIWYWTApp()));
}

class CIWYWTApp extends ConsumerWidget {
  const CIWYWTApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateAsync = ref.watch(authStateProvider);

    return MaterialApp(
      title: 'CIWYWT',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: authStateAsync.when(
        data: (user) {
          if (user != null) {
            return const HomeScreen();
          }
          return const LoginScreen();
        },
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (e, trace) => Scaffold(
          body: Center(child: Text("Error: $e")),
        ),
      ),
    );
  }
}