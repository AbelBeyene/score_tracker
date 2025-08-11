import 'package:flutter/material.dart';
import 'package:score_tracker/features/scoring/application/score_api.dart';

class MiniScoreGrid extends StatefulWidget {
  const MiniScoreGrid({super.key});

  @override
  State<MiniScoreGrid> createState() => _MiniScoreGridState();
}

class _MiniScoreGridState extends State<MiniScoreGrid> {
  @override
  void initState() {
    super.initState();
    ScoreApi.addScoreChangedListener(_onScoreChange);
    ScoreApi.addServerChangedListener(_onServerChange);
    ScoreApi.addEndsChangedListener(_onEndsChange);
    ScoreApi.addServiceBoxChangedListener(_onServiceBoxChange);
  }

  @override
  void dispose() {
    ScoreApi.removeScoreChangedListener(_onScoreChange);
    ScoreApi.removeServerChangedListener(_onServerChange);
    ScoreApi.removeEndsChangedListener(_onEndsChange);
    ScoreApi.removeServiceBoxChangedListener(_onServiceBoxChange);
    super.dispose();
  }

  void _onScoreChange() => setState(() {});
  void _onServerChange(int _) => setState(() {});
  void _onEndsChange() => setState(() {});
  void _onServiceBoxChange(bool _) => setState(() {});

  @override
  Widget build(BuildContext context) {
    final bool isConnected = ScoreApi.isConnected;
    final int? serverIndex = ScoreApi.currentServerIndex;
    final bool isDeuceBox = ScoreApi.isServeFromDeuceCourt;
    final TextStyle head = Theme.of(context).textTheme.labelLarge!;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white24),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 120),
              Text('Sets', style: head),
              Text('Games', style: head),
              Text('Points', style: head),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
          const SizedBox(height: 8),
          _row(
            name: ScoreApi.playerOneName,
            isServing: isConnected && serverIndex == 0,
            sets: ScoreApi.playerOneSets,
            games: ScoreApi.playerOneGames,
            points: ScoreApi.playerOnePointsLabel,
            isDeuceBox: isDeuceBox,
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
          const SizedBox(height: 8),
          _row(
            name: ScoreApi.playerTwoName,
            isServing: isConnected && serverIndex == 1,
            sets: ScoreApi.playerTwoSets,
            games: ScoreApi.playerTwoGames,
            points: ScoreApi.playerTwoPointsLabel,
            isDeuceBox: isDeuceBox,
          ),
        ],
      ),
    );
  }

  Widget _row({
    required String name,
    required bool isServing,
    required int sets,
    required int games,
    required String points,
    required bool isDeuceBox,
  }) {
    final Color on = Colors.white;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 120,
          child: Row(
            children: [
              if (isServing)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(Icons.sports_tennis, color: on, size: 18),
                ),
              Flexible(
                child: Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: on, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        _cell(sets.toString()),
        _cell(games.toString()),
        _cell(points + (isServing ? (isDeuceBox ? '  R' : '  L') : '')),
      ],
    );
  }

  Widget _cell(String text) {
    return SizedBox(
      width: 64,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
