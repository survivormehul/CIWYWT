import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/auth_service.dart';
import 'category_screen.dart';
import 'pick_screen.dart';
import 'history_screen.dart';
import '../../core/theme/app_theme.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _navigateToCategory(BuildContext context, String title, String categoryId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CategoryScreen(title: title, category: categoryId),
      ),
    );
  }

  void _navigateToPick(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const PickScreen(),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CIWYWT"),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HistoryScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authServiceProvider).signOut(),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: _buildHomeButton(
                        context,
                        "Food",
                        "🍕",
                        () => _navigateToCategory(context, "Food Ideas", "food"),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildHomeButton(
                        context,
                        "Places",
                        "🏞",
                        () => _navigateToCategory(context, "Places", "place"),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: _buildHomeButton(
                        context,
                        "Watchlist",
                        "🎬",
                        () => _navigateToCategory(context, "Watchlist", "watch"),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildHomeButton(
                        context,
                        "Pick for Us",
                        "🎲",
                        () => _navigateToPick(context),
                        isPrimary: true,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHomeButton(BuildContext context, String title, String emoji, VoidCallback onTap, {bool isPrimary = false}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          color: isPrimary ? AppTheme.primaryColor : AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 64),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontSize: 22,
                color: isPrimary ? Colors.white : AppTheme.textPrimaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
