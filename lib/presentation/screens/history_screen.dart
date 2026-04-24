import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/pick_service.dart';
import '../../core/theme/app_theme.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(picksHistoryStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Past Picks"),
      ),
      body: historyAsync.when(
        data: (picks) {
          if (picks.isEmpty) {
            return const Center(child: Text("No history yet! 🎲"));
          }

          return ListView.builder(
            itemCount: picks.length,
            itemBuilder: (context, index) {
              final pick = picks[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(
                    pick.suggestionName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "${pick.category.toUpperCase()} • ${DateFormat('MMM d, yyyy').format(pick.pickedAt)}",
                  ),
                  trailing: TextButton(
                    onPressed: () async {
                      try {
                        await ref.read(pickServiceProvider).reconsiderPick(pick.id, pick.suggestionId);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Suggestion available again!")));
                        }
                      } catch (e) {
                         if (context.mounted) {
                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                         }
                      }
                    },
                    child: const Text("Reconsider", style: TextStyle(color: AppTheme.primaryColor)),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor)),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
