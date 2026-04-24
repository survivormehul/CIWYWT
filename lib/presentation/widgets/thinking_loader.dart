import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';

class ThinkingLoader extends StatelessWidget {
  const ThinkingLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.favorite,
            color: AppTheme.primaryColor,
            size: 64,
          )
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .scale(duration: 600.ms, begin: const Offset(1, 1), end: const Offset(1.2, 1.2))
          .tint(color: AppTheme.secondaryColor),
          const SizedBox(height: 24),
          Text(
            "Thinking...",
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              fontSize: 24,
            ),
          )
          .animate(onPlay: (controller) => controller.repeat())
          .shimmer(duration: 1200.ms, color: AppTheme.primaryColor),
        ],
      ),
    );
  }
}