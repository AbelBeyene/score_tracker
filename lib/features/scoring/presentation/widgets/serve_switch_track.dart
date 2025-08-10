import 'package:flutter/material.dart';
import 'package:score_tracker/features/scoring/presentation/widgets/serve_indicator.dart';

class ServeSwitchTrack extends StatelessWidget {
  final bool isLeftServing;
  final double height;

  const ServeSwitchTrack({
    super.key,
    required this.isLeftServing,
    this.height = 26,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(height),
          gradient: const LinearGradient(
            colors: [Color(0xFF2F2F2F), Color(0xFF1E1E1E)],
          ),
          border: Border.all(color: const Color(0xFF3C3C3C)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 420),
            curve: Curves.easeInOutCubic,
            alignment: isLeftServing
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ServeIndicator(isServing: true, size: height - 8),
            ),
          ),
        ),
      ),
    );
  }
}
