import 'package:flutter/material.dart';
import 'package:score_tracker/core/models/match_config.dart';
import 'package:score_tracker/core/models/player.dart';
import 'package:score_tracker/features/match_setup/presentation/pages/match_setup_page.dart';
import 'package:score_tracker/features/scoring/presentation/pages/scoreboard_page.dart';
import 'package:score_tracker/features/scoring/presentation/pages/mini_score_grid_page.dart';
import 'package:score_tracker/features/splash/presentation/pages/splash_page.dart';

class Routes {
  static const String scoreboard = '/';
  static const String matchSetup = '/setup';
  static const String history = '/history';
  static const String splash = '/splash';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute<void>(
          builder: (_) => const SplashPage(),
          settings: settings,
        );
      case scoreboard:
        final args = settings.arguments;
        if (args is ScoreboardArgs) {
          return MaterialPageRoute<void>(
            builder: (_) => ScoreboardPage(
              playerOne: args.playerOne,
              playerTwo: args.playerTwo,
              config: args.config,
              savedControllerJson: args.savedControllerJson,
            ),
            settings: settings,
          );
        }
        return MaterialPageRoute<void>(
          builder: (_) => const ScoreboardPage(),
          settings: settings,
        );
      case matchSetup:
        return MaterialPageRoute<void>(
          builder: (_) => const MatchSetupPage(),
          settings: settings,
        );
      case history:
        return MaterialPageRoute<void>(
          // builder: (_) => const SavedGamesPage(),
          builder: (_) => const MiniScoreGridPage(),
          settings: settings,
        );
      default:
        return MaterialPageRoute<void>(
          builder: (_) => const ScoreboardPage(),
          settings: settings,
        );
    }
  }
}

class ScoreboardArgs {
  final Player playerOne;
  final Player playerTwo;
  final MatchConfig config;
  final Map<String, dynamic>? savedControllerJson;

  const ScoreboardArgs({
    required this.playerOne,
    required this.playerTwo,
    required this.config,
    this.savedControllerJson,
  });
}
