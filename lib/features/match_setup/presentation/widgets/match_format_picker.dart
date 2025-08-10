import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:score_tracker/features/match_setup/presentation/widgets/setup_section_card.dart';

class MatchFormatPicker extends StatelessWidget {
  final int setsToWin;
  final bool tiebreakAtSixAll;
  final bool playAdvantage;
  final ValueChanged<int> onSetsChanged;
  final ValueChanged<bool> onTiebreakChanged;
  final ValueChanged<bool> onAdvantageChanged;

  const MatchFormatPicker({
    super.key,
    required this.setsToWin,
    required this.tiebreakAtSixAll,
    required this.playAdvantage,
    required this.onSetsChanged,
    required this.onTiebreakChanged,
    required this.onAdvantageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = Colors.white;
    return SetupSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Format',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: textColor),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text('Sets:', style: TextStyle(color: textColor)),
              const SizedBox(width: 12),
              Expanded(
                child: _PillSelector<int>(
                  values: const [1, 2, 3],
                  selected: setsToWin,
                  onChanged: onSetsChanged,
                ),
              ),
              const SizedBox(width: 10),
              _CustomNumberInput(
                value: setsToWin,
                onChanged: (v) {
                  final clamped = v.clamp(1, 7);
                  onSetsChanged(clamped);
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          _ToggleRow(
            title: 'Tiebreak at 6-6',
            value: tiebreakAtSixAll,
            onChanged: onTiebreakChanged,
            icon: Icons.change_circle_outlined,
          ),
          const SizedBox(height: 8),
          _ToggleRow(
            title: 'Play advantage (deuce/adv)',
            value: playAdvantage,
            onChanged: onAdvantageChanged,
            icon: Icons.sports_tennis,
          ),
        ],
      ),
    );
  }
}

class _PillSelector<T> extends StatelessWidget {
  final List<T> values;
  final T selected;
  final ValueChanged<T> onChanged;

  const _PillSelector({
    required this.values,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: values.map((v) {
        final bool isSelected = v == selected;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => onChanged(v),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: isSelected ? Colors.white12 : const Color(0xFF262626),
                border: Border.all(
                  color: isSelected ? Colors.white70 : const Color(0xFF4A4A4A),
                ),
              ),
              child: Text(
                v.toString(),
                style: TextStyle(
                  color: Colors.white.withOpacity(isSelected ? 1 : 0.8),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  final IconData icon;

  const _ToggleRow({
    required this.title,
    required this.value,
    required this.onChanged,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: value ? Colors.white12 : const Color(0xFF262626),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: value ? Colors.white70 : const Color(0xFF4A4A4A),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white70, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(title, style: const TextStyle(color: Colors.white)),
            ),
            Switch(value: value, onChanged: onChanged),
          ],
        ),
      ),
    );
  }
}

class _CustomNumberInput extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const _CustomNumberInput({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.circular(20);
    final TextEditingController controller = TextEditingController(
      text: value.toString(),
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF262626),
        borderRadius: radius,
        border: Border.all(color: const Color(0xFF4A4A4A)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _RoundIcon(
            icon: Icons.remove,
            onTap: () => onChanged((value - 1).clamp(1, 7)),
          ),
          const SizedBox(width: 6),
          SizedBox(
            width: 48,
            child: TextField(
              controller: controller,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 6),
                border: InputBorder.none,
              ),
              onChanged: (txt) {
                final parsed = int.tryParse(txt);
                if (parsed != null) onChanged(parsed);
              },
            ),
          ),
          const SizedBox(width: 6),
          _RoundIcon(
            icon: Icons.add,
            onTap: () => onChanged((value + 1).clamp(1, 7)),
          ),
        ],
      ),
    );
  }
}

class _RoundIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _RoundIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 18,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white12,
          border: Border.all(color: const Color(0xFF4A4A4A)),
        ),
        child: Icon(icon, size: 16, color: Colors.white),
      ),
    );
  }
}
