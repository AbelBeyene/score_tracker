import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:score_tracker/core/models/match_config.dart';
import 'package:score_tracker/core/models/player.dart';

class MatchSetupController extends ChangeNotifier {
  final TextEditingController playerOneController = TextEditingController(
    text: 'Player 1',
  );
  final TextEditingController playerTwoController = TextEditingController(
    text: 'Player 2',
  );
  int setsToWin = 2; // best of 3 by default
  bool tiebreakAtSixAll = true;
  int initialServerIndex = 0;
  bool playAdvantage = true;

  MatchSetupController() {
    playerOneController.addListener(_onNameChanged);
    playerTwoController.addListener(_onNameChanged);
  }

  void _onNameChanged() => notifyListeners();

  void swapPlayers() {
    final a = playerOneController.text;
    playerOneController.text = playerTwoController.text;
    playerTwoController.text = a;
    notifyListeners();
  }

  void setSetsToWin(int value) {
    setsToWin = value;
    notifyListeners();
  }

  void setTiebreak(bool value) {
    tiebreakAtSixAll = value;
    notifyListeners();
  }

  void setServer(int index) {
    initialServerIndex = index;
    notifyListeners();
  }

  void setAdvantage(bool value) {
    playAdvantage = value;
    notifyListeners();
  }

  Player get playerOne => Player(
    name: playerOneController.text.trim().isEmpty
        ? 'Player 1'
        : playerOneController.text.trim(),
  );
  Player get playerTwo => Player(
    name: playerTwoController.text.trim().isEmpty
        ? 'Player 2'
        : playerTwoController.text.trim(),
  );

  MatchConfig buildConfig() {
    return MatchConfig(
      setsToWin: setsToWin,
      tiebreakAtSixAll: tiebreakAtSixAll,
      playAdvantage: playAdvantage,
      initialServerIndex: initialServerIndex,
    );
  }

  @override
  void dispose() {
    playerOneController.dispose();
    playerTwoController.dispose();
    super.dispose();
  }
}
