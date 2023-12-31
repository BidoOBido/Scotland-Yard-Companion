import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RevealClue extends StatelessWidget {
  final ValueChanged<int> onAdd;

  const RevealClue({
    super.key,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return AlertDialog(
      title: const Text('Número da Pista'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Número',
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () {
            controller.clear();
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Adicionar'),
          onPressed: () {
            final number = int.tryParse(controller.text);
            if (number != null) {
              onAdd(number);
            }
          },
        ),
      ],
    );
  }
}
