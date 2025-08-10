import 'dart:math' as math;
import 'package:flutter/material.dart';

class ServeIndicator extends StatefulWidget {
  final bool isServing;
  final double size;

  const ServeIndicator({super.key, required this.isServing, this.size = 18});

  @override
  State<ServeIndicator> createState() => _ServeIndicatorState();
}

class _ServeIndicatorState extends State<ServeIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    _scale = Tween(
      begin: 0.94,
      end: 1.06,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (widget.isServing) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant ServeIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isServing != widget.isServing) {
      if (widget.isServing) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double size = widget.size;
    final bool isServing = widget.isServing;
    final Color glowColor = const Color(0xFFFFF176); // lemon glow

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 220),
      opacity: isServing ? 1 : 0.45,
      child: ScaleTransition(
        scale: isServing ? _scale : const AlwaysStoppedAnimation(1.0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: isServing
                ? [
                    BoxShadow(
                      color: glowColor.withOpacity(0.55),
                      blurRadius: 14,
                      spreadRadius: 1.2,
                    ),
                    BoxShadow(
                      color: Colors.greenAccent.withOpacity(0.18),
                      blurRadius: 22,
                      spreadRadius: 1.8,
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 4,
                      spreadRadius: 0.5,
                    ),
                  ],
          ),
          child: CustomPaint(
            size: Size.square(size),
            painter: _TennisBallPainter(
              baseColor: const Color(0xFFFFEB3B),
              highlightColor: const Color(0xFFFFF59D),
              seamColor: Colors.white70,
            ),
          ),
        ),
      ),
    );
  }
}

class _TennisBallPainter extends CustomPainter {
  final Color baseColor;
  final Color highlightColor;
  final Color seamColor;

  _TennisBallPainter({
    required this.baseColor,
    required this.highlightColor,
    required this.seamColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    final Offset center = Offset(radius, radius);

    final Paint fillPaint = Paint()
      ..shader = RadialGradient(
        colors: [highlightColor, baseColor],
        center: const Alignment(-0.3, -0.3),
        radius: 0.9,
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    // Ball base
    canvas.drawCircle(center, radius, fillPaint);

    // Seams
    final Paint seamPaint = Paint()
      ..color = seamColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.10
      ..strokeCap = StrokeCap.round;

    final Rect arcRect = Rect.fromCircle(center: center, radius: radius * 0.85);

    // Left-to-right upper arc
    canvas.drawArc(
      arcRect.shift(Offset(0, -radius * 0.25)),
      math.pi * 0.15,
      math.pi * 0.70,
      false,
      seamPaint,
    );

    // Left-to-right lower arc
    canvas.drawArc(
      arcRect.shift(Offset(0, radius * 0.25)),
      -math.pi * 0.85,
      math.pi * 0.70,
      false,
      seamPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _TennisBallPainter oldDelegate) {
    return oldDelegate.baseColor != baseColor ||
        oldDelegate.highlightColor != highlightColor ||
        oldDelegate.seamColor != seamColor;
  }
}
