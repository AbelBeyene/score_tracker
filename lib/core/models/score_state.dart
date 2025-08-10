enum Point { love, fifteen, thirty, forty, advantage }

class ScoreState {
  Point playerOnePoint;
  Point playerTwoPoint;
  int playerOneGames;
  int playerTwoGames;
  int playerOneSets;
  int playerTwoSets;
  int serverIndex;
  bool isTiebreak;
  int playerOneTiebreakPoints;
  int playerTwoTiebreakPoints;

  ScoreState({
    this.playerOnePoint = Point.love,
    this.playerTwoPoint = Point.love,
    this.playerOneGames = 0,
    this.playerTwoGames = 0,
    this.playerOneSets = 0,
    this.playerTwoSets = 0,
    this.serverIndex = 0,
    this.isTiebreak = false,
    this.playerOneTiebreakPoints = 0,
    this.playerTwoTiebreakPoints = 0,
  });

  ScoreState copy() {
    return ScoreState(
      playerOnePoint: playerOnePoint,
      playerTwoPoint: playerTwoPoint,
      playerOneGames: playerOneGames,
      playerTwoGames: playerTwoGames,
      playerOneSets: playerOneSets,
      playerTwoSets: playerTwoSets,
      serverIndex: serverIndex,
      isTiebreak: isTiebreak,
      playerOneTiebreakPoints: playerOneTiebreakPoints,
      playerTwoTiebreakPoints: playerTwoTiebreakPoints,
    );
  }

  Map<String, dynamic> toJson() => {
    'playerOnePoint': playerOnePoint.index,
    'playerTwoPoint': playerTwoPoint.index,
    'playerOneGames': playerOneGames,
    'playerTwoGames': playerTwoGames,
    'playerOneSets': playerOneSets,
    'playerTwoSets': playerTwoSets,
    'serverIndex': serverIndex,
    'isTiebreak': isTiebreak,
    'playerOneTiebreakPoints': playerOneTiebreakPoints,
    'playerTwoTiebreakPoints': playerTwoTiebreakPoints,
  };

  static ScoreState fromJson(Map<String, dynamic> json) {
    return ScoreState(
      playerOnePoint: Point.values[(json['playerOnePoint'] as int?) ?? 0],
      playerTwoPoint: Point.values[(json['playerTwoPoint'] as int?) ?? 0],
      playerOneGames: (json['playerOneGames'] as int?) ?? 0,
      playerTwoGames: (json['playerTwoGames'] as int?) ?? 0,
      playerOneSets: (json['playerOneSets'] as int?) ?? 0,
      playerTwoSets: (json['playerTwoSets'] as int?) ?? 0,
      serverIndex: (json['serverIndex'] as int?) ?? 0,
      isTiebreak: (json['isTiebreak'] as bool?) ?? false,
      playerOneTiebreakPoints: (json['playerOneTiebreakPoints'] as int?) ?? 0,
      playerTwoTiebreakPoints: (json['playerTwoTiebreakPoints'] as int?) ?? 0,
    );
  }

  static String label(Point p) {
    switch (p) {
      case Point.love:
        return '0';
      case Point.fifteen:
        return '15';
      case Point.thirty:
        return '30';
      case Point.forty:
        return '40';
      case Point.advantage:
        return 'Ad';
    }
  }
}
