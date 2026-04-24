import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/theme/app_theme.dart';

class RevealCard extends StatelessWidget {
  final String title;
  final String suggestionName;
  final String? addedBy;
  final String category;
  final VoidCallback? onDismiss;

  const RevealCard({
    super.key,
    required this.title,
    required this.suggestionName,
    this.addedBy,
    required this.category,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(32),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: AppTheme.primaryColor,
                fontSize: 28,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Text(
              suggestionName,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontSize: 36,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            if (addedBy != null && addedBy!.isNotEmpty)
              Text(
                _getAddedByText(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            const SizedBox(height: 16),
            Chip(
              label: Text(category.toUpperCase()),
              backgroundColor: AppTheme.backgroundColor,
              labelStyle: const TextStyle(color: AppTheme.textSecondaryColor, fontWeight: FontWeight.bold),
            ),
            if (onDismiss != null) ...[
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: onDismiss,
                child: const Text("Awesome!"),
              )
            ]
          ],
        ),
      ),
    ).animate().flip(duration: 600.ms, direction: Axis.horizontal).scale(delay: 200.ms, duration: 400.ms);
  }

  String _getAddedByText() {
    if (addedBy == "App" || addedBy == null || addedBy!.isEmpty) return "Default Idea";
    
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;
    if (addedBy == currentUserUid) {
      return "Added by you ✨";
    }
    return "Added by your partner ❤️";
  }
}
