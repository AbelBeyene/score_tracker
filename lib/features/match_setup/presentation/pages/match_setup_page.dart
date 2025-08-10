import 'package:flutter/material.dart';
import 'package:score_tracker/app/routes.dart';
import 'package:score_tracker/features/match_setup/presentation/controllers/match_setup_controller.dart';
import 'package:score_tracker/features/match_setup/presentation/widgets/match_format_picker.dart';
import 'package:score_tracker/features/match_setup/presentation/widgets/player_form.dart';
import 'package:score_tracker/features/match_setup/presentation/widgets/serve_selector.dart';
import 'package:score_tracker/features/match_setup/presentation/widgets/glow_start_button.dart';

class MatchSetupPage extends StatefulWidget {
  const MatchSetupPage({super.key});

  @override
  State<MatchSetupPage> createState() => _MatchSetupPageState();
}

class _MatchSetupPageState extends State<MatchSetupPage> {
  late final MatchSetupController controller;

  @override
  void initState() {
    super.initState();
    controller = MatchSetupController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Match Setup'),
            automaticallyImplyLeading: false,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IconButton(
                  tooltip: 'History',
                  onPressed: () =>
                      Navigator.of(context).pushNamed(Routes.history),
                  icon: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF1B232F),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x552196F3),
                          blurRadius: 14,
                          spreadRadius: 1,
                        ),
                        BoxShadow(
                          color: Color(0x332196F3),
                          blurRadius: 24,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const SizedBox(
                      width: 36,
                      height: 36,
                      child: Center(
                        child: Icon(Icons.history, color: Color(0xFF64B5F6)),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF1F1F1F), Color(0xFF000000)],
              ),
            ),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                PlayerForm(
                  playerOneController: controller.playerOneController,
                  playerTwoController: controller.playerTwoController,
                ),
                const SizedBox(height: 16),
                MatchFormatPicker(
                  setsToWin: controller.setsToWin,
                  tiebreakAtSixAll: controller.tiebreakAtSixAll,
                  playAdvantage: controller.playAdvantage,
                  onSetsChanged: controller.setSetsToWin,
                  onTiebreakChanged: controller.setTiebreak,
                  onAdvantageChanged: controller.setAdvantage,
                ),
                const SizedBox(height: 16),
                ServeSelector(
                  initialIndex: controller.initialServerIndex,
                  onChanged: controller.setServer,
                  playerOneLabel:
                      controller.playerOneController.text.trim().isEmpty
                      ? 'Player 1'
                      : controller.playerOneController.text.trim(),
                  playerTwoLabel:
                      controller.playerTwoController.text.trim().isEmpty
                      ? 'Player 2'
                      : controller.playerTwoController.text.trim(),
                ),
                const SizedBox(height: 24),
                GlowStartButton(
                  label: 'Start Match',
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      Routes.scoreboard,
                      arguments: ScoreboardArgs(
                        playerOne: controller.playerOne,
                        playerTwo: controller.playerTwo,
                        config: controller.buildConfig(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
