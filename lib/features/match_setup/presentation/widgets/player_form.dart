import 'package:flutter/material.dart';
import 'package:score_tracker/features/match_setup/presentation/widgets/setup_section_card.dart';
import 'package:score_tracker/features/match_setup/presentation/widgets/player_card_input.dart';

class PlayerForm extends StatelessWidget {
  final TextEditingController playerOneController;
  final TextEditingController playerTwoController;

  const PlayerForm({
    super.key,
    required this.playerOneController,
    required this.playerTwoController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SetupSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Players',
            style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 12),
          PlayerCardInput(
            controller: playerOneController,
            label: 'Player 1',
            hint: 'Enter Player 1 name',
            accentColor: const Color(0xFF5AA9E6),
          ),
          const SizedBox(height: 12),
          PlayerCardInput(
            controller: playerTwoController,
            label: 'Player 2',
            hint: 'Enter Player 2 name',
            accentColor: const Color(0xFFC7F464),
          ),
        ],
      ),
    );
  }
}
