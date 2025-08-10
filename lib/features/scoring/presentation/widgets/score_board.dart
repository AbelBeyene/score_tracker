import 'package:flutter/material.dart';

class ScoreBoard extends StatelessWidget {
  final String playerOneName;
  final String playerTwoName;
  final int playerOneSets;
  final int playerTwoSets;
  final int playerOneGames;
  final int playerTwoGames;
  final String playerOnePointsLabel;
  final String playerTwoPointsLabel;

  const ScoreBoard({
    super.key,
    required this.playerOneName,
    required this.playerTwoName,
    required this.playerOneSets,
    required this.playerTwoSets,
    required this.playerOneGames,
    required this.playerTwoGames,
    required this.playerOnePointsLabel,
    required this.playerTwoPointsLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _ScoreCell(
                  label: playerOneName,
                  value: playerOneSets.toString(),
                  valueAccentColor: Theme.of(context).colorScheme.primary,
                ),
                const _ScoreCell(label: 'Sets', value: ''),
                _ScoreCell(
                  label: playerTwoName,
                  value: playerTwoSets.toString(),
                  valueAccentColor: Theme.of(context).colorScheme.secondary,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _ScoreCell(
                  label: playerOneName,
                  value: playerOneGames.toString(),
                  valueAccentColor: Theme.of(context).colorScheme.primary,
                ),
                const _ScoreCell(label: 'Games', value: ''),
                _ScoreCell(
                  label: playerTwoName,
                  value: playerTwoGames.toString(),
                  valueAccentColor: Theme.of(context).colorScheme.secondary,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _ScoreCell(
                  label: playerOneName,
                  value: playerOnePointsLabel,
                  valueAccentColor: Theme.of(context).colorScheme.primary,
                ),
                const _ScoreCell(label: 'Points', value: ''),
                _ScoreCell(
                  label: playerTwoName,
                  value: playerTwoPointsLabel,
                  valueAccentColor: Theme.of(context).colorScheme.secondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ScoreCell extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueAccentColor;

  const _ScoreCell({
    required this.label,
    required this.value,
    this.valueAccentColor,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isNumber = double.tryParse(value) != null;
    return Column(
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isNumber
                ? (valueAccentColor ?? scheme.primary).withOpacity(0.10)
                : scheme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            value,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: isNumber ? (valueAccentColor ?? scheme.primary) : null,
            ),
          ),
        ),
      ],
    );
  }
}
