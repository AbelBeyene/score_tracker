class MatchConfig {
  final int setsToWin;
  final bool tiebreakAtSixAll;
  final int gamesPerSet;
  final bool playAdvantage; // true = standard deuce/adv; false = no-ad
  final int initialServerIndex; // 0 -> P1, 1 -> P2

  const MatchConfig({
    this.setsToWin = 2,
    this.tiebreakAtSixAll = true,
    this.gamesPerSet = 6,
    this.playAdvantage = true,
    this.initialServerIndex = 0,
  });

  Map<String, dynamic> toJson() => {
    'setsToWin': setsToWin,
    'tiebreakAtSixAll': tiebreakAtSixAll,
    'gamesPerSet': gamesPerSet,
    'playAdvantage': playAdvantage,
    'initialServerIndex': initialServerIndex,
  };

  static MatchConfig fromJson(Map<String, dynamic> json) => MatchConfig(
    setsToWin: (json['setsToWin'] as int?) ?? 2,
    tiebreakAtSixAll: (json['tiebreakAtSixAll'] as bool?) ?? true,
    gamesPerSet: (json['gamesPerSet'] as int?) ?? 6,
    playAdvantage: (json['playAdvantage'] as bool?) ?? true,
    initialServerIndex: (json['initialServerIndex'] as int?) ?? 0,
  );
}
