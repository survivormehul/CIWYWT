import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/models/suggestion_model.dart';
import '../../core/theme/app_theme.dart';

class SuggestionTile extends StatelessWidget {
  final SuggestionModel suggestion;

  const SuggestionTile({super.key, required this.suggestion});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: suggestion.used ? 0 : 2,
      color: suggestion.used ? AppTheme.backgroundColor : AppTheme.surfaceColor,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        title: Text(
          suggestion.name,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            decoration: suggestion.used ? TextDecoration.lineThrough : null,
            color: suggestion.used ? Colors.black38 : AppTheme.textPrimaryColor,
            fontWeight: suggestion.used ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            _getAddedByText(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: suggestion.used ? Colors.black26 : AppTheme.primaryColor.withOpacity(0.8),
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        leading: Icon(
          suggestion.used ? Icons.check_circle_outline : Icons.star_border,
          color: suggestion.used ? Colors.black26 : AppTheme.primaryColor,
        ),
      ),
    );
  }

  String _getAddedByText() {
    // If it's a fallback item, it won't have an addedBy
    if (suggestion.addedBy.isEmpty) return "Default Idea";
    
    // Check if added by the current user
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;
    if (suggestion.addedBy == currentUserUid) {
      return "Added by you ✨";
    }
    return "Added by your partner ❤️";
  }
}
