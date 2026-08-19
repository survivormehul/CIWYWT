import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../data/services/date_idea_service.dart';
import '../widgets/date_idea_card.dart';
import '../widgets/add_date_idea_modal.dart';
import '../../core/theme/app_theme.dart';

class DateIdeasScreen extends ConsumerWidget {
  const DateIdeasScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ideasAsyncValue = ref.watch(dateIdeasStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Date Ideas ❤️"),
      ),
      body: SafeArea(
        child: ideasAsyncValue.when(
          data: (ideas) {
            if (ideas.isEmpty) {
              return const Center(
                child: Text(
                  "No date ideas yet.\nTap + to add one! ✨",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              );
            }
            return MasonryGridView.count(
              padding: const EdgeInsets.all(16),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              itemCount: ideas.length,
              itemBuilder: (context, index) {
                final idea = ideas[index];
                return DateIdeaCard(idea: idea).animate().fade(duration: 300.ms).slideY(begin: 0.1, end: 0);
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Text("Error: $error"),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => const AddDateIdeaModal(),
          );
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
