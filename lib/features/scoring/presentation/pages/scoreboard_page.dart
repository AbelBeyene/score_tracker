import 'package:flutter/material.dart';
import 'package:score_tracker/core/models/player.dart';
import 'package:score_tracker/core/models/score_state.dart';
import 'package:score_tracker/features/scoring/presentation/controllers/scoring_controller.dart';
import 'package:score_tracker/features/scoring/presentation/widgets/point_buttons.dart';
import 'package:score_tracker/features/scoring/presentation/widgets/score_board.dart';
import 'package:score_tracker/features/scoring/presentation/widgets/serve_switch_track.dart';
import 'package:score_tracker/features/scoring/presentation/widgets/rule_chips.dart';
import 'package:score_tracker/core/models/match_config.dart';
import 'package:score_tracker/features/scoring/data/saved_games_repository.dart';

class ScoreboardPage extends StatefulWidget {
  final Player? playerOne;
  final Player? playerTwo;
  final MatchConfig? config;
  final Map<String, dynamic>? savedControllerJson;

  const ScoreboardPage({
    super.key,
    this.playerOne,
    this.playerTwo,
    this.config,
    this.savedControllerJson,
  });

  @override
  State<ScoreboardPage> createState() => _ScoreboardPageState();
}

class _ScoreboardPageState extends State<ScoreboardPage> {
  late final ScoringController controller;

  @override
  void initState() {
    super.initState();
    if (widget.savedControllerJson != null) {
      controller = ScoringController.fromJson(widget.savedControllerJson!);
    } else {
      controller = ScoringController(
        playerOne: widget.playerOne ?? const Player(name: 'Player 1'),
        playerTwo: widget.playerTwo ?? const Player(name: 'Player 2'),
        config: widget.config ?? const MatchConfig(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            leadingWidth: 64,
            leading: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: IconButton(
                tooltip: 'Exit',
                onPressed: _showExitDialog,
                icon: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF2A1B1B),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x55FF1744),
                        blurRadius: 14,
                        spreadRadius: 1,
                      ),
                      BoxShadow(
                        color: Color(0x33FF1744),
                        blurRadius: 24,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const SizedBox(
                    width: 40,
                    height: 40,
                    child: Center(
                      child: Icon(Icons.exit_to_app, color: Color(0xFFFF5252)),
                    ),
                  ),
                ),
              ),
            ),
            title: const Text('Live Match'),
            actions: [
              IconButton(
                tooltip: 'Undo',
                onPressed: controller.canUndo ? controller.undo : null,
                icon: const Icon(Icons.undo),
              ),
              IconButton(
                tooltip: 'Redo',
                onPressed: controller.canRedo ? controller.redo : null,
                icon: const Icon(Icons.redo),
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
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Text(
                            controller.playerOne.name,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                          const Spacer(),
                          Text(
                            controller.playerTwo.name,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.secondary,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ServeSwitchTrack(
                        isLeftServing: controller.state.serverIndex == 0,
                        height: 28,
                      ),
                    ],
                  ),
                ),
                RuleChips(
                  isTiebreak: controller.isTiebreak,
                  isDeuce: controller.isDeuceNow,
                  isAdvantageP1:
                      controller.state.playerOnePoint == Point.advantage,
                  isAdvantageP2:
                      controller.state.playerTwoPoint == Point.advantage,
                  isBreakPoint: controller.isBreakPoint,
                  tiebreakScore: controller.isTiebreak
                      ? '${controller.state.playerOneTiebreakPoints}-${controller.state.playerTwoTiebreakPoints}'
                      : null,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: ScoreBoard(
                          playerOneName: controller.playerOne.name,
                          playerTwoName: controller.playerTwo.name,
                          playerOneSets: controller.state.playerOneSets,
                          playerTwoSets: controller.state.playerTwoSets,
                          playerOneGames: controller.state.playerOneGames,
                          playerTwoGames: controller.state.playerTwoGames,
                          playerOnePointsLabel: controller.isTiebreak
                              ? controller.state.playerOneTiebreakPoints
                                    .toString()
                              : ScoreState.label(
                                  controller.state.playerOnePoint,
                                ),
                          playerTwoPointsLabel: controller.isTiebreak
                              ? controller.state.playerTwoTiebreakPoints
                                    .toString()
                              : ScoreState.label(
                                  controller.state.playerTwoPoint,
                                ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        child: PointButtons(
                          onPlayerOnePoint: controller.pointToPlayerOne,
                          onPlayerTwoPoint: controller.pointToPlayerTwo,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showExitDialog() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Leave match?',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
          content: const Text(
            'Do you want to exit the game or save it first?',
            style: TextStyle(color: Colors.white70),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          actions: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    style: ButtonStyle(
                      side: const MaterialStatePropertyAll(
                        BorderSide(color: Color(0xFFFF5252)),
                      ),
                      foregroundColor: const MaterialStatePropertyAll(
                        Color(0xFFFF5252),
                      ),
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    child: const Text('Exit game'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      _saveAndExit();
                    },
                    style: ButtonStyle(
                      backgroundColor: const MaterialStatePropertyAll(
                        Color(0xFF2E7D32),
                      ),
                      foregroundColor: const MaterialStatePropertyAll(
                        Colors.white,
                      ),
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    child: const Text('Save Game'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveAndExit() async {
    Navigator.of(context).pop();
    final repo = SavedGamesRepository();
    await repo.saveGame({
      'timestamp': DateTime.now().toIso8601String(),
      'controller': controller.toJson(),
    });
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Game saved')));
    Navigator.of(context).pop();
  }
}
