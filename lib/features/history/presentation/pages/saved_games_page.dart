import 'package:flutter/material.dart';
import 'package:score_tracker/app/routes.dart';
import 'package:score_tracker/features/scoring/data/saved_games_repository.dart';
import 'package:score_tracker/core/models/match_config.dart';
import 'package:score_tracker/core/models/player.dart';

class SavedGamesPage extends StatefulWidget {
  const SavedGamesPage({super.key});

  @override
  State<SavedGamesPage> createState() => _SavedGamesPageState();
}

class _SavedGamesPageState extends State<SavedGamesPage> {
  final SavedGamesRepository _repo = SavedGamesRepository();
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = _repo.fetchAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved Games')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final games = snapshot.data!;
          if (games.isEmpty) {
            return const Center(
              child: Text(
                'No games saved',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }
          return ListView.separated(
            itemCount: games.length,
            separatorBuilder: (_, __) =>
                const Divider(height: 1, color: Colors.white12),
            itemBuilder: (context, index) {
              final json = games[index];
              final ts = json['timestamp'] as String?;
              final c = json['controller'] as Map<String, dynamic>;
              final p1 =
                  (c['playerOne'] as Map<String, dynamic>)['name'] as String? ??
                  'Player 1';
              final p2 =
                  (c['playerTwo'] as Map<String, dynamic>)['name'] as String? ??
                  'Player 2';
              return ListTile(
                title: Text(
                  '$p1 vs $p2',
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  ts ?? '',
                  style: const TextStyle(color: Colors.white54),
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: Colors.white70,
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    Routes.scoreboard,
                    arguments: ScoreboardArgs(
                      playerOne: const Player(name: 'tmp'),
                      playerTwo: const Player(name: 'tmp'),
                      config: const MatchConfig(),
                      savedControllerJson: c,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
