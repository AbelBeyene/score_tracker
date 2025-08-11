import 'package:flutter_test/flutter_test.dart';
import 'package:score_tracker/core/models/score_state.dart';
import 'package:score_tracker/core/models/player.dart';
import 'package:score_tracker/core/models/match_config.dart';
import 'package:score_tracker/features/scoring/application/score_api.dart';
import 'package:score_tracker/features/scoring/presentation/controllers/scoring_controller.dart';

void main() {
  test('ScoreApi attaches, increments points, and detaches', () {
    final controller = ScoringController(
      playerOne: const Player(name: 'A'),
      playerTwo: const Player(name: 'B'),
      config: const MatchConfig(),
    );

    expect(ScoreApi.isConnected, isFalse);
    ScoreApi.attach(controller);
    expect(ScoreApi.isConnected, isTrue);

    ScoreApi.pointToPlayerOne();
    expect(controller.state.playerOnePoint, Point.fifteen);

    ScoreApi.pointToPlayerOne();
    expect(controller.state.playerOnePoint, Point.thirty);

    ScoreApi.pointToPlayerOne();
    expect(controller.state.playerOnePoint, Point.forty);

    ScoreApi.pointToPlayerOne();
    expect(controller.state.playerOneGames, 1);
    expect(controller.state.playerOnePoint, Point.love);
    expect(controller.state.playerTwoPoint, Point.love);

    ScoreApi.pointToPlayerTwo();
    expect(controller.state.playerTwoPoint, Point.fifteen);

    ScoreApi.detach(controller);
    expect(ScoreApi.isConnected, isFalse);
  });

  test('ScoreApi notifies server change and ends change on games', () {
    final controller = ScoringController(
      playerOne: const Player(name: 'A'),
      playerTwo: const Player(name: 'B'),
      config: const MatchConfig(),
    );

    int? lastServerIndex;
    int endsChanges = 0;

    ScoreApi.attach(controller);
    void Function(int) serverListener = (idx) => lastServerIndex = idx;
    void Function() endsListener = () => endsChanges++;
    ScoreApi.addServerChangedListener(serverListener);
    ScoreApi.addEndsChangedListener(endsListener);

    ScoreApi.pointToPlayerOne();
    ScoreApi.pointToPlayerOne();
    ScoreApi.pointToPlayerOne();
    ScoreApi.pointToPlayerOne();

    expect(controller.state.playerOneGames, 1);
    expect(lastServerIndex, 1);
    expect(endsChanges, 1);

    ScoreApi.pointToPlayerTwo();
    ScoreApi.pointToPlayerTwo();
    ScoreApi.pointToPlayerTwo();
    ScoreApi.pointToPlayerTwo();

    expect(controller.state.playerTwoGames, 1);
    expect(lastServerIndex, 0);
    expect(endsChanges, 1);

    ScoreApi.removeServerChangedListener(serverListener);
    ScoreApi.removeEndsChangedListener(endsListener);
    ScoreApi.detach(controller);
  });

  test('ScoreApi notifies ends change during tiebreak every 6 points', () {
    final controller = ScoringController(
      playerOne: const Player(name: 'A'),
      playerTwo: const Player(name: 'B'),
      config: const MatchConfig(gamesPerSet: 1, tiebreakAtSixAll: true),
    );

    int endsChanges = 0;
    ScoreApi.attach(controller);
    void Function() endsListener = () => endsChanges++;
    ScoreApi.addEndsChangedListener(endsListener);

    for (int i = 0; i < 4; i++) {
      ScoreApi.pointToPlayerOne();
    }
    for (int i = 0; i < 4; i++) {
      ScoreApi.pointToPlayerTwo();
    }
    expect(controller.isTiebreak, isTrue);
    endsChanges = 0;

    for (int i = 0; i < 6; i++) {
      if (i % 2 == 0) {
        ScoreApi.pointToPlayerOne();
      } else {
        ScoreApi.pointToPlayerTwo();
      }
    }
    expect(endsChanges, 1);

    for (int i = 0; i < 6; i++) {
      if (i % 2 == 0) {
        ScoreApi.pointToPlayerOne();
      } else {
        ScoreApi.pointToPlayerTwo();
      }
    }
    expect(endsChanges, 2);

    ScoreApi.removeEndsChangedListener(endsListener);
    ScoreApi.detach(controller);
  });
}
