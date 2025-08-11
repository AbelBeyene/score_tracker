import 'package:flutter/foundation.dart';
import 'package:score_tracker/core/models/match_config.dart';
import 'package:score_tracker/core/models/player.dart';
import 'package:score_tracker/core/models/score_state.dart';

class ScoringController extends ChangeNotifier {
  final Player playerOne;
  final Player playerTwo;
  final MatchConfig config;

  final ScoreState state = ScoreState();
  final List<ScoreState> _history = <ScoreState>[];
  final List<ScoreState> _redo = <ScoreState>[];
  int? _tiebreakFirstServerIndex;

  ScoringController({
    required this.playerOne,
    required this.playerTwo,
    this.config = const MatchConfig(),
  }) {
    state.serverIndex = config.initialServerIndex;
  }

  void pointToPlayerOne() => _applyPoint(isPlayerOne: true);
  void pointToPlayerTwo() => _applyPoint(isPlayerOne: false);

  bool get canUndo => _history.isNotEmpty;
  bool get canRedo => _redo.isNotEmpty;
  void undo() {
    if (!canUndo) return;
    final current = state.copy();
    final previous = _history.removeLast();
    _redo.add(current);
    state.playerOnePoint = previous.playerOnePoint;
    state.playerTwoPoint = previous.playerTwoPoint;
    state.playerOneGames = previous.playerOneGames;
    state.playerTwoGames = previous.playerTwoGames;
    state.playerOneSets = previous.playerOneSets;
    state.playerTwoSets = previous.playerTwoSets;
    state.serverIndex = previous.serverIndex;
    state.isTiebreak = previous.isTiebreak;
    state.playerOneTiebreakPoints = previous.playerOneTiebreakPoints;
    state.playerTwoTiebreakPoints = previous.playerTwoTiebreakPoints;
    notifyListeners();
  }

  void redo() {
    if (!canRedo) return;
    final next = _redo.removeLast();
    _history.add(state.copy());
    state.playerOnePoint = next.playerOnePoint;
    state.playerTwoPoint = next.playerTwoPoint;
    state.playerOneGames = next.playerOneGames;
    state.playerTwoGames = next.playerTwoGames;
    state.playerOneSets = next.playerOneSets;
    state.playerTwoSets = next.playerTwoSets;
    state.serverIndex = next.serverIndex;
    state.isTiebreak = next.isTiebreak;
    state.playerOneTiebreakPoints = next.playerOneTiebreakPoints;
    state.playerTwoTiebreakPoints = next.playerTwoTiebreakPoints;
    notifyListeners();
  }

  bool _isDeuce() =>
      !state.isTiebreak &&
      state.playerOnePoint == Point.forty &&
      state.playerTwoPoint == Point.forty;

  bool get isTiebreak => state.isTiebreak;
  bool get isDeuceNow => _isDeuce();
  bool get isAdvantage =>
      state.playerOnePoint == Point.advantage ||
      state.playerTwoPoint == Point.advantage;
  bool get isBreakPoint {
    if (state.isTiebreak) return false;
    final serverIsP1 = state.serverIndex == 0;
    if (!config.playAdvantage && _isDeuce()) return true;
    if (serverIsP1) {
      return state.playerTwoPoint == Point.advantage ||
          (state.playerTwoPoint == Point.forty &&
              state.playerOnePoint.index < Point.forty.index);
    } else {
      return state.playerOnePoint == Point.advantage ||
          (state.playerOnePoint == Point.forty &&
              state.playerTwoPoint.index < Point.forty.index);
    }
  }

  void _applyPoint({required bool isPlayerOne}) {
    _redo.clear();
    _history.add(state.copy());
    if (state.isTiebreak) {
      _applyTiebreakPoint(isPlayerOne: isPlayerOne);
      return;
    }

    if (config.playAdvantage) {
      if (isPlayerOne) {
        if (state.playerOnePoint == Point.advantage) {
          _winGame(isPlayerOne: true);
          return;
        }
        if (state.playerTwoPoint == Point.advantage) {
          state.playerTwoPoint = Point.forty;
          notifyListeners();
          return;
        }
      } else {
        if (state.playerTwoPoint == Point.advantage) {
          _winGame(isPlayerOne: false);
          return;
        }
        if (state.playerOnePoint == Point.advantage) {
          state.playerOnePoint = Point.forty;
          notifyListeners();
          return;
        }
      }
      if (_isDeuce()) {
        if (isPlayerOne) {
          state.playerOnePoint = Point.advantage;
        } else {
          state.playerTwoPoint = Point.advantage;
        }
        notifyListeners();
        return;
      }
    } else {
      if (_isDeuce()) {
        _winGame(isPlayerOne: isPlayerOne);
        return;
      }
    }

    if (isPlayerOne) {
      if (state.playerOnePoint == Point.forty &&
          state.playerTwoPoint != Point.forty) {
        _winGame(isPlayerOne: true);
        return;
      }
      state.playerOnePoint = _incrementPoint(state.playerOnePoint);
    } else {
      if (state.playerTwoPoint == Point.forty &&
          state.playerOnePoint != Point.forty) {
        _winGame(isPlayerOne: false);
        return;
      }
      state.playerTwoPoint = _incrementPoint(state.playerTwoPoint);
    }
    notifyListeners();
  }

  Point _incrementPoint(Point p) {
    switch (p) {
      case Point.love:
        return Point.fifteen;
      case Point.fifteen:
        return Point.thirty;
      case Point.thirty:
        return Point.forty;
      case Point.forty:
        return Point.forty;
      case Point.advantage:
        return Point.advantage;
    }
  }

  void _winGame({required bool isPlayerOne}) {
    if (isPlayerOne) {
      state.playerOneGames += 1;
    } else {
      state.playerTwoGames += 1;
    }
    _resetPoints();
    _maybeEnterTiebreak();
    _maybeWinSet();
    _toggleServer();
    notifyListeners();
  }

  void _resetPoints() {
    state.playerOnePoint = Point.love;
    state.playerTwoPoint = Point.love;
  }

  void _toggleServer() {
    state.serverIndex = state.serverIndex == 0 ? 1 : 0;
  }

  Map<String, dynamic> toJson() => {
    'playerOne': playerOne.toJson(),
    'playerTwo': playerTwo.toJson(),
    'config': config.toJson(),
    'state': state.toJson(),
  };

  void _maybeEnterTiebreak() {
    if (!config.tiebreakAtSixAll) return;
    if (state.playerOneGames == config.gamesPerSet &&
        state.playerTwoGames == config.gamesPerSet) {
      state.isTiebreak = true;
      _tiebreakFirstServerIndex = state.serverIndex;
    }
  }

  void _maybeWinSet() {
    if (state.isTiebreak) return;
    final p1 = state.playerOneGames;
    final p2 = state.playerTwoGames;
    final target = config.gamesPerSet;
    if ((p1 >= target || p2 >= target) && (p1 - p2).abs() >= 2) {
      _awardSet(winnerIsP1: p1 > p2);
    }
  }

  void _awardSet({required bool winnerIsP1}) {
    if (winnerIsP1) {
      state.playerOneSets += 1;
    } else {
      state.playerTwoSets += 1;
    }
    state.playerOneGames = 0;
    state.playerTwoGames = 0;
    state.isTiebreak = false;
    state.playerOneTiebreakPoints = 0;
    state.playerTwoTiebreakPoints = 0;
  }

  void _applyTiebreakPoint({required bool isPlayerOne}) {
    if (isPlayerOne) {
      state.playerOneTiebreakPoints += 1;
    } else {
      state.playerTwoTiebreakPoints += 1;
    }
    final int p1 = state.playerOneTiebreakPoints;
    final int p2 = state.playerTwoTiebreakPoints;
    final int total = p1 + p2;

    if ((p1 >= 7 || p2 >= 7) && (p1 - p2).abs() >= 2) {
      _awardSet(winnerIsP1: p1 > p2);
      final int firstServer = _tiebreakFirstServerIndex ?? state.serverIndex;
      state.serverIndex = firstServer == 0 ? 1 : 0;
      _tiebreakFirstServerIndex = null;
      notifyListeners();
      return;
    }

    // While in tiebreak, serving alternates after the first point and then
    // every two points: toggle after odd totals (1,3,5,...)
    if (total % 2 == 1) {
      state.serverIndex = state.serverIndex == 0 ? 1 : 0;
    }
    notifyListeners();
  }

  static ScoringController fromJson(Map<String, dynamic> json) {
    final playerOne = Player.fromJson(
      json['playerOne'] as Map<String, dynamic>,
    );
    final playerTwo = Player.fromJson(
      json['playerTwo'] as Map<String, dynamic>,
    );
    final config = MatchConfig.fromJson(json['config'] as Map<String, dynamic>);
    final state = ScoreState.fromJson(json['state'] as Map<String, dynamic>);
    final controller = ScoringController(
      playerOne: playerOne,
      playerTwo: playerTwo,
      config: config,
    );
    controller.state.playerOnePoint = state.playerOnePoint;
    controller.state.playerTwoPoint = state.playerTwoPoint;
    controller.state.playerOneGames = state.playerOneGames;
    controller.state.playerTwoGames = state.playerTwoGames;
    controller.state.playerOneSets = state.playerOneSets;
    controller.state.playerTwoSets = state.playerTwoSets;
    controller.state.serverIndex = state.serverIndex;
    controller.state.isTiebreak = state.isTiebreak;
    controller.state.playerOneTiebreakPoints = state.playerOneTiebreakPoints;
    controller.state.playerTwoTiebreakPoints = state.playerTwoTiebreakPoints;
    return controller;
  }
}
