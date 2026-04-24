import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/suggestion_service.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/suggestion_tile.dart';

class CategoryScreen extends ConsumerStatefulWidget {
  final String title;
  final String category;

  const CategoryScreen({super.key, required this.title, required this.category});

  @override
  ConsumerState<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends ConsumerState<CategoryScreen> {
  final TextEditingController _controller = TextEditingController();

  void _addSuggestion() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    // Clear immediately for better UX
    _controller.clear();
    FocusScope.of(context).unfocus();

    try {
      await ref.read(suggestionServiceProvider).addSuggestion(text, widget.category);
    } catch (e) {
      // If there's an error, put the text back
      if (mounted) {
        _controller.text = text;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll("Exception: ", "")),
            backgroundColor: AppTheme.textPrimaryColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final suggestionsAsyncValue = ref.watch(suggestionsStreamProvider(widget.category));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: suggestionsAsyncValue.when(
              data: (suggestions) {
                if (suggestions.isEmpty) {
                  return const Center(child: Text("No ideas yet. Add some below! ✨"));
                }
                
                // Sort unused first
                final unusedList = suggestions.where((s) => !s.used).toList();
                final usedList = suggestions.where((s) => s.used).toList();
                final sortedList = [...unusedList, ...usedList];

                return ListView.builder(
                  itemCount: sortedList.length,
                  itemBuilder: (context, index) {
                    final suggestion = sortedList[index];
                    return SuggestionTile(suggestion: suggestion);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor)),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                )
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: "Add a new idea...",
                      ),
                      onSubmitted: (_) => _addSuggestion(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppTheme.primaryColor,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: _addSuggestion,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
