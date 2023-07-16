import 'package:flutter/material.dart';
import 'package:scotland_yard_companion/src/cases/list.dart';
import 'package:scotland_yard_companion/src/home/controller.dart';
import 'package:scotland_yard_companion/src/models/states.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final HomeController _controller = HomeController();

  @override
  void initState() {
    super.initState();

    _controller.loadSavedData();
    _controller.stateNotifier.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Scotland Yard Companion',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            getNewButton(),
            getContinueButton()
          ],
        ),
      ),
    );
  }

  Widget getContinueButton() {
    switch (_controller.state) {
      case ControllerState.loading:
        return const CircularProgressIndicator();
      default:
        return TextButton.icon(
          icon: const Icon(
            Icons.turn_right,
            size: 24,
          ),
          label: const Text(
            'Continuar',
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          onPressed: _controller.containsSavedData ? () => _doContinue() : null,
        );
    }
  }

  Future<dynamic> _doContinue() {
    return Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => CasesList(
          controller: _controller.booksController,
        ),
      ),
    );
  }

  Future<dynamic> _doNew() {
    return Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const CasesList(),
      ),
    );
  }

  Widget getNewButton() {
    switch (_controller.state) {
      case ControllerState.loading:
        return const CircularProgressIndicator();
      default:
        return TextButton.icon(
          icon: const Icon(
            Icons.book,
            size: 24,
          ),
          label: const Text(
            'Novo',
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          onPressed: () {
            if (!_controller.containsSavedData) {
              _doNew();
              return;
            }
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: const Text('Deseja limpar os dados salvos?'),
                  actions: [
                    TextButton(
                      child: const Text('Não'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Use a opção "Continuar" para '
                                'carregar os dados salvos'),
                          ),
                        );
                      },
                    ),
                    TextButton(
                      child: const Text('Sim'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        _doNew();
                      },
                    ),
                  ],
                );
              },
            );
          },
        );
    }
  }
}
