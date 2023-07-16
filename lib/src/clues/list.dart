import 'package:flutter/material.dart';
import 'package:scotland_yard_companion/src/clues/card.dart';
import 'package:scotland_yard_companion/src/models/case.dart';
import 'package:scotland_yard_companion/src/models/clue.dart';
import 'package:scotland_yard_companion/src/widgets/reveal_clue.dart';

class CluesList extends StatefulWidget {
  final Case caseData;
  final VoidCallback onRevelClue;

  const CluesList({
    super.key,
    required this.caseData,
    required this.onRevelClue,
  });

  @override
  State<CluesList> createState() => _CluesListState();
}

class _CluesListState extends State<CluesList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.caseData.name),
        actions: [
          TextButton(
            child: const Text('Adicionar Pista'),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return RevealClue(
                    onAdd: (number) {
                      bool valid = false;

                      final Iterable<Clue> clues =
                          widget.caseData.clues.where((e) {
                        return (e.number == number && !e.visible);
                      });

                      if (clues.isNotEmpty) {
                        for (final clue in clues) {
                          clue.visible = true;
                        }
                        valid = true;
                        setState(() {});

                        widget.onRevelClue();
                      }

                      if (!valid) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Pista inválida'),
                          ),
                        );
                        return;
                      }

                      Navigator.of(context).pop();
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: widget.caseData.clues.length,
        itemBuilder: (context, index) {
          final clue = widget.caseData.clues[index];

          if (!clue.visible) {
            return const SizedBox.shrink();
          }

          return Card(
            child: ListTile(
              leading: Text(
                (index + 1).toString().padLeft(3, '0'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              title: Text(clue.name),
              subtitle: Text(clue.text, overflow: TextOverflow.ellipsis),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => ClueCard(clue: clue),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
