import 'package:flutter/material.dart';
import 'package:scotland_yard_companion/src/models/clue.dart';

class ClueCard extends StatelessWidget {
  final Clue clue;

  const ClueCard({
    super.key,
    required this.clue,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Pista ${clue.number}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(clue.text),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Fechar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
