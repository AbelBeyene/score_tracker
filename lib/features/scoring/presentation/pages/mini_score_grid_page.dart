import 'package:flutter/material.dart';
import 'package:score_tracker/features/scoring/application/score_api.dart';
import 'package:score_tracker/features/scoring/presentation/widgets/mini_score_grid.dart';

class MiniScoreGridPage extends StatelessWidget {
  const MiniScoreGridPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mini Score Grid')),
      body: const Center(child: MiniScoreGrid()),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(
            heroTag: 'mini-grid-p1',
            tooltip: 'Add point P1',
            onPressed: ScoreApi.pointToPlayerOne,
            child: const Text('P1'),
          ),
          const SizedBox(width: 12),
          FloatingActionButton.small(
            heroTag: 'mini-grid-p2',
            tooltip: 'Add point P2',
            onPressed: ScoreApi.pointToPlayerTwo,
            child: const Text('P2'),
          ),
        ],
      ),
    );
  }
}
