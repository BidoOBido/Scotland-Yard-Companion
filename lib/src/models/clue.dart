class Clue {
  String name;
  int number;
  String text;
  bool visible = false;

  Clue({
    required this.name,
    required this.number,
    required this.text,
  });

  factory Clue.fromJson(Map<String, dynamic> json) {
    return Clue(
      name: json['nome'],
      number: json['numero'],
      text: json['dica'],
    );
  }
}
