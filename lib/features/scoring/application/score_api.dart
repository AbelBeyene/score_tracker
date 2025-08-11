import 'package:flutter/foundation.dart';
import 'package:score_tracker/core/models/score_state.dart';
import 'package:score_tracker/features/scoring/presentation/controllers/scoring_controller.dart';

class ScoreApi {
  static ScoringController? _controller;
  static VoidCallback? _controllerListener;

  static final List<void Function(int serverIndex)> _serverListeners =
      <void Function(int)>[];
  static final List<VoidCallback> _endsChangeListeners = <VoidCallback>[];
  static final List<void Function(bool isDeuceCourt)> _serviceBoxListeners =
      <void Function(bool)>[];
  static final List<VoidCallback> _scoreChangeListeners = <VoidCallback>[];

  static int? _lastServerIndex;
  static int? _lastGamesTotal;
  static int? _lastTiebreakPointsTotal;
  static Point? _lastP1Point;
  static Point? _lastP2Point;
  static int _gamePointIndex = 0;

  static void attach(ScoringController controller) {
    _controller = controller;
    _lastServerIndex = controller.state.serverIndex;
    _lastGamesTotal =
        controller.state.playerOneGames + controller.state.playerTwoGames;
    _lastTiebreakPointsTotal =
        controller.state.playerOneTiebreakPoints +
        controller.state.playerTwoTiebreakPoints;
    _lastP1Point = controller.state.playerOnePoint;
    _lastP2Point = controller.state.playerTwoPoint;
    _gamePointIndex = 0;

    _controllerListener ??= _handleControllerChange;
    controller.addListener(_controllerListener!);
  }

  static void detach(ScoringController controller) {
    if (identical(_controller, controller)) {
      if (_controllerListener != null) {
        controller.removeListener(_controllerListener!);
      }
      _controller = null;
      _controllerListener = null;
      _lastServerIndex = null;
      _lastGamesTotal = null;
      _lastTiebreakPointsTotal = null;
      _lastP1Point = null;
      _lastP2Point = null;
      _gamePointIndex = 0;
    }
  }

  static bool get isConnected => _controller != null;

  static void addPointTo({required int playerIndex}) {
    final ScoringController? controller = _controller;
    if (controller == null) return;
    if (playerIndex == 0) {
      controller.pointToPlayerOne();
    } else if (playerIndex == 1) {
      controller.pointToPlayerTwo();
    }
  }

  static void pointToPlayerOne() {
    _controller?.pointToPlayerOne();
  }

  static void pointToPlayerTwo() {
    _controller?.pointToPlayerTwo();
  }

  static void addServerChangedListener(
    void Function(int serverIndex) listener,
  ) {
    _serverListeners.add(listener);
  }

  static void removeServerChangedListener(
    void Function(int serverIndex) listener,
  ) {
    _serverListeners.remove(listener);
  }

  static void addEndsChangedListener(VoidCallback listener) {
    _endsChangeListeners.add(listener);
  }

  static void removeEndsChangedListener(VoidCallback listener) {
    _endsChangeListeners.remove(listener);
  }

  static void addServiceBoxChangedListener(
    void Function(bool isDeuceCourt) listener,
  ) {
    _serviceBoxListeners.add(listener);
  }

  static void removeServiceBoxChangedListener(
    void Function(bool isDeuceCourt) listener,
  ) {
    _serviceBoxListeners.remove(listener);
  }

  static int? get currentServerIndex => _controller?.state.serverIndex;

  static bool get isServeFromDeuceCourt {
    final ScoringController? controller = _controller;
    if (controller == null) return true;
    if (controller.state.isTiebreak) {
      final total =
          controller.state.playerOneTiebreakPoints +
          controller.state.playerTwoTiebreakPoints;
      return total % 2 == 0;
    }
    return _gamePointIndex % 2 == 0;
  }

  static bool get isTiebreak => _controller?.state.isTiebreak ?? false;

  static String get playerOneName => _controller?.playerOne.name ?? 'Player 1';
  static String get playerTwoName => _controller?.playerTwo.name ?? 'Player 2';

  static int get playerOneSets => _controller?.state.playerOneSets ?? 0;
  static int get playerTwoSets => _controller?.state.playerTwoSets ?? 0;
  static int get playerOneGames => _controller?.state.playerOneGames ?? 0;
  static int get playerTwoGames => _controller?.state.playerTwoGames ?? 0;

  static String get playerOnePointsLabel {
    final c = _controller;
    if (c == null) return '0';
    if (c.state.isTiebreak) return c.state.playerOneTiebreakPoints.toString();
    return ScoreState.label(c.state.playerOnePoint);
  }

  static String get playerTwoPointsLabel {
    final c = _controller;
    if (c == null) return '0';
    if (c.state.isTiebreak) return c.state.playerTwoTiebreakPoints.toString();
    return ScoreState.label(c.state.playerTwoPoint);
  }

  static void addScoreChangedListener(VoidCallback listener) {
    _scoreChangeListeners.add(listener);
  }

  static void removeScoreChangedListener(VoidCallback listener) {
    _scoreChangeListeners.remove(listener);
  }

  static void _handleControllerChange() {
    final ScoringController? controller = _controller;
    if (controller == null) return;
    final int currentServerIndex = controller.state.serverIndex;
    final bool isTiebreak = controller.state.isTiebreak;
    final int gamesTotal =
        controller.state.playerOneGames + controller.state.playerTwoGames;
    final int tiebreakPointsTotal =
        controller.state.playerOneTiebreakPoints +
        controller.state.playerTwoTiebreakPoints;
    final Point p1Point = controller.state.playerOnePoint;
    final Point p2Point = controller.state.playerTwoPoint;

    if (_lastServerIndex != null && currentServerIndex != _lastServerIndex) {
      for (final l in List.of(_serverListeners)) {
        l(currentServerIndex);
      }
    }

    if (!isTiebreak) {
      if (_lastGamesTotal != null && gamesTotal != _lastGamesTotal) {
        if (gamesTotal % 2 == 1) {
          for (final l in List.of(_endsChangeListeners)) {
            l();
          }
        }
        _gamePointIndex = 0;
        for (final l in List.of(_serviceBoxListeners)) {
          l(true);
        }
      }
      if ((_lastP1Point != null && p1Point != _lastP1Point) ||
          (_lastP2Point != null && p2Point != _lastP2Point)) {
        _gamePointIndex += 1;
        final bool isDeuceNow = _gamePointIndex % 2 == 0;
        for (final l in List.of(_serviceBoxListeners)) {
          l(isDeuceNow);
        }
      }
    } else {
      if (_lastTiebreakPointsTotal != null &&
          tiebreakPointsTotal != _lastTiebreakPointsTotal) {
        if (tiebreakPointsTotal % 6 == 0 && tiebreakPointsTotal > 0) {
          for (final l in List.of(_endsChangeListeners)) {
            l();
          }
        }
        final bool isDeuceNow = tiebreakPointsTotal % 2 == 0;
        for (final l in List.of(_serviceBoxListeners)) {
          l(isDeuceNow);
        }
      }
    }

    _lastServerIndex = currentServerIndex;
    _lastGamesTotal = gamesTotal;
    _lastTiebreakPointsTotal = tiebreakPointsTotal;
    _lastP1Point = p1Point;
    _lastP2Point = p2Point;

    for (final l in List.of(_scoreChangeListeners)) {
      l();
    }
  }
}
