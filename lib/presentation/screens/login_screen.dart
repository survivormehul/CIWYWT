import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/auth_service.dart';
import '../../core/theme/app_theme.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _isLoading = false;

  Future<void> _signIn() async {
    setState(() => _isLoading = true);
    try {
      await ref.read(authServiceProvider).signInWithGoogle();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll("Exception: ", "")),
            backgroundColor: AppTheme.textPrimaryColor,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.favorite,
                color: AppTheme.primaryColor,
                size: 80,
              ),
              const SizedBox(height: 24),
              Text(
                "CIWYWT",
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 48,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Our private space ❤️",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 64),
              _isLoading
                  ? const CircularProgressIndicator(color: AppTheme.primaryColor)
                  : ElevatedButton.icon(
                      onPressed: _signIn,
                      icon: const Icon(Icons.login),
                      label: const Text("Sign in with Google"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}