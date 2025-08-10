import 'package:flutter/material.dart';

class RuleChips extends StatelessWidget {
  final bool isTiebreak;
  final bool isDeuce;
  final bool isAdvantageP1;
  final bool isAdvantageP2;
  final bool isBreakPoint;
  final String? tiebreakScore;

  const RuleChips({
    super.key,
    required this.isTiebreak,
    required this.isDeuce,
    required this.isAdvantageP1,
    required this.isAdvantageP2,
    required this.isBreakPoint,
    this.tiebreakScore,
  });

  @override
  Widget build(BuildContext context) {
    final chips = <Widget>[];
    if (isTiebreak) {
      chips.add(
        _Chip(
          text: 'Tiebreak${tiebreakScore != null ? ' $tiebreakScore' : ''}',
          color: Theme.of(context).colorScheme.secondary,
          textColor: Theme.of(context).colorScheme.onSecondary,
        ),
      );
    } else if (isDeuce) {
      chips.add(
        _Chip(
          text: 'Deuce',
          color: Theme.of(context).colorScheme.primaryContainer,
          textColor: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      );
    }
    if (isAdvantageP1) chips.add(_Chip(text: 'Adv P1'));
    if (isAdvantageP2) chips.add(_Chip(text: 'Adv P2'));
    if (isBreakPoint) chips.add(_Chip(text: 'Break Point'));

    if (chips.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(spacing: 8, runSpacing: 8, children: chips),
    );
  }
}

class _Chip extends StatelessWidget {
  final String text;
  final Color? color;
  final Color? textColor;
  const _Chip({required this.text, this.color, this.textColor});

  @override
  Widget build(BuildContext context) {
    final background =
        color ?? Theme.of(context).colorScheme.secondaryContainer;
    final foreground =
        textColor ?? Theme.of(context).colorScheme.onSecondaryContainer;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 1),
            blurRadius: 3,
          ),
        ],
      ),
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.labelLarge?.copyWith(color: foreground),
      ),
    );
  }
}
