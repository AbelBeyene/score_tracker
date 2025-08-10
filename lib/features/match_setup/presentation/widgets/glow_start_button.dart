import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';

class GlowStartButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String label;

  const GlowStartButton({
    super.key,
    required this.onPressed,
    this.label = 'Start Match',
  });

  @override
  State<GlowStartButton> createState() => _GlowStartButtonState();
}

class _GlowStartButtonState extends State<GlowStartButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: GlowButton(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFFBFFF00),
        glowColor: const Color(0xFFCCFF66),
        spreadRadius: 2,
        blurRadius: 18,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.play_arrow, color: Colors.black54),
            const SizedBox(width: 8),
            Text(
              widget.label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        onPressed: widget.onPressed,
      ),
    );
  }
}
