class Clue {
  String name;
  String number;
  String text;
  bool visible = false;

  Clue({
    required this.name,
    required this.number,
    required this.text,
    this.visible = false,
  });

  factory Clue.fromJson(Map<String, dynamic> json) {
    return Clue(
      name: json['nome'],
      number: json['numero'],
      text: json['dica'],
      visible: json['visible'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'nome': name,
        'numero': number,
        'dica': text,
        'visible': visible ? true : false,
      };
}
