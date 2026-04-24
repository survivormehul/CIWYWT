import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/pick_service.dart';
import '../../data/services/suggestion_service.dart';
import '../widgets/thinking_loader.dart';
import '../widgets/reveal_card.dart';

class PickScreen extends ConsumerStatefulWidget {
  const PickScreen({super.key});

  @override
  ConsumerState<PickScreen> createState() => _PickScreenState();
}

class _PickScreenState extends ConsumerState<PickScreen> {
  String? _selectedCategory;
  bool _isThinking = false;
  bool _showReveal = false;
  
  String _revealTitle = "";
  String _revealName = "";
  String _revealAddedBy = "";
  String _revealCategory = "";
  
  bool _isFallback = false;

  void _onSelectCategory(String category) async {
    setState(() {
      _selectedCategory = category;
      _isThinking = true;
    });

    // Simulate "thinking" duration
    await Future.delayed(const Duration(milliseconds: 1500));

    try {
      // Add a 10 second timeout so it never hangs forever!
      final pick = await ref.read(pickServiceProvider).makePick(category).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception("Connection timed out. Please check your internet or Firebase rules!"),
      );
      
      if (pick != null) {
        // Normal pick
        setState(() {
          _revealTitle = "Tonight's Pick ✨";
          _revealName = pick.suggestionName;
          _revealCategory = pick.category;
          _revealAddedBy = pick.addedBy;
          _isFallback = false;
          _isThinking = false;
          _showReveal = true;
        });
      } else {
        // Fallback flow
        setState(() {
          _isThinking = false;
        });
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Database is Empty! 🚨"),
            content: Text("Firebase successfully connected, but it returned ZERO unused ideas for the category '$category'. This means the ideas you typed on your phone never actually synced to the cloud database."),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("OK"))
            ],
          )
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isThinking = false;
          _selectedCategory = null; // reset
        });
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("CRITICAL ERROR 🚨"),
            content: Text(e.toString()),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("OK"))
            ],
          )
        );
      }
    }
  }

  void _onDismiss() {
    Navigator.of(context).pop();
  }
  
  void _onRefreshList() async {
    try {
      if (_selectedCategory != null) {
        await ref.read(suggestionServiceProvider).refreshCategory(_selectedCategory!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("List refreshed!")));
          Navigator.of(context).pop();
        }
      }
    } catch(e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pick for Us 🎲"),
      ),
      body: Center(
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (_selectedCategory == null) {
      // Step 1: Select Category
      return Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("What are we picking?", style: Theme.of(context).textTheme.displayMedium),
            const SizedBox(height: 48),
            _CategoryButton(title: "Food 🍕", onTap: () => _onSelectCategory("food")),
            const SizedBox(height: 16),
            _CategoryButton(title: "Places 🏞", onTap: () => _onSelectCategory("place")),
            const SizedBox(height: 16),
            _CategoryButton(title: "Watchlist 🎬", onTap: () => _onSelectCategory("watch")),
          ],
        ),
      );
    }

    if (_isThinking) {
      return const ThinkingLoader();
    }

    if (_showReveal) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RevealCard(
            title: _revealTitle,
            suggestionName: _isFallback ? "How about $_revealName tonight? ✨" : _revealName,
            addedBy: _isFallback ? null : _revealAddedBy,
            category: _revealCategory,
            onDismiss: _isFallback ? null : _onDismiss,
          ),
          if (_isFallback) ...[
            const SizedBox(height: 16),
            Text(
              "Should I refresh your saved list?",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _onRefreshList,
                  child: const Text("Yes, refresh!"),
                ),
                const SizedBox(width: 16),
                TextButton(
                  onPressed: _onDismiss,
                  child: const Text("No, cancel"),
                )
              ],
            )
          ]
        ],
      );
    }

    return const SizedBox.shrink();
  }
}

class _CategoryButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _CategoryButton({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 20),
        ),
        onPressed: onTap,
        child: Text(title),
      ),
    );
  }
}
