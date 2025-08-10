import 'package:flutter/material.dart';
import 'package:score_tracker/features/match_setup/presentation/widgets/setup_section_card.dart';

class ServeSelector extends StatelessWidget {
  final int initialIndex;
  final ValueChanged<int> onChanged;
  final String playerOneLabel;
  final String playerTwoLabel;

  const ServeSelector({
    super.key,
    required this.initialIndex,
    required this.onChanged,
    required this.playerOneLabel,
    required this.playerTwoLabel,
  });

  @override
  Widget build(BuildContext context) {
    final Color active = Colors.white12;
    return SetupSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'First server',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ServerChip(
                  label: playerOneLabel,
                  selected: initialIndex == 0,
                  onTap: () => onChanged(0),
                  color: const Color(0xFF5AA9E6),
                  activeColor: active,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ServerChip(
                  label: playerTwoLabel,
                  selected: initialIndex == 1,
                  onTap: () => onChanged(1),
                  color: const Color(0xFFC7F464),
                  activeColor: active,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ServerChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color color;
  final Color activeColor;

  const _ServerChip({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.color,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? activeColor : const Color(0xFF262626),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? color : const Color(0xFF4A4A4A)),
        ),
        child: Row(
          children: [
            Icon(
              Icons.sports_tennis,
              size: 16,
              color: selected ? color : Colors.white54,
            ),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
