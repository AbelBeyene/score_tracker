class Player {
  final String name;

  const Player({required this.name});

  Map<String, dynamic> toJson() => {'name': name};
  static Player fromJson(Map<String, dynamic> json) =>
      Player(name: (json['name'] as String?) ?? 'Player');
}
