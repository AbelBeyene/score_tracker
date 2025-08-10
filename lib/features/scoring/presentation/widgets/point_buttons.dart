import 'package:flutter/material.dart';

class PointButtons extends StatelessWidget {
  final VoidCallback onPlayerOnePoint;
  final VoidCallback onPlayerTwoPoint;

  const PointButtons({
    super.key,
    required this.onPlayerOnePoint,
    required this.onPlayerTwoPoint,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: _OutlinedActionButton(
            label: 'Point P1',
            icon: Icons.add,
            borderColor: scheme.primary,
            onPressed: onPlayerOnePoint,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _OutlinedActionButton(
            label: 'Point P2',
            icon: Icons.add,
            borderColor: scheme.secondary,
            onPressed: onPlayerTwoPoint,
          ),
        ),
      ],
    );
  }
}

class _OutlinedActionButton extends StatelessWidget {
  final Color borderColor;
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _OutlinedActionButton({
    required this.borderColor,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.circular(5);

    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
      style: ButtonStyle(
        padding: const MaterialStatePropertyAll(
          EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(borderRadius: radius),
        ),
        foregroundColor: const MaterialStatePropertyAll(Colors.white),
        overlayColor: MaterialStateProperty.resolveWith(
          (states) => borderColor.withOpacity(
            states.contains(MaterialState.pressed) ? 0.18 : 0.10,
          ),
        ),
        side: MaterialStateProperty.resolveWith((states) {
          final double width = states.contains(MaterialState.pressed)
              ? 1.8
              : 1.2;
          return BorderSide(color: borderColor.withOpacity(0.9), width: width);
        }),
      ),
    );
  }
}
