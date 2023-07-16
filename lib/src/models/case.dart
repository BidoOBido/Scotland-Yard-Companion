import 'package:scotland_yard_companion/src/models/clue.dart';

class Case {
  String name;
  List<Clue> clues;

  Case({
    required this.name,
    required this.clues,
  });

  factory Case.fromJson(Map<String, dynamic> json) {
    return Case(
      name: json['nome'],
      clues: List<Clue>.from(json['pistas'].map((x) => Clue.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        'nome': name,
        'pistas': List<dynamic>.from(clues.map((x) => x.toJson())),
      };
}
