import 'package:flutter/material.dart';
import 'package:scotland_yard_companion/src/cases/controller.dart';
import 'package:scotland_yard_companion/src/clues/list.dart';

class CasesList extends StatefulWidget {
  const CasesList({super.key});

  @override
  State<CasesList> createState() => _CasesListState();
}

class _CasesListState extends State<CasesList> {
  final BooksController controller = BooksController();

  @override
  void initState() {
    super.initState();

    controller.loadBooks();
    controller.stateNotifier.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scotland Yard Companion'),
        actions: [
          DropdownButton<String>(
            value: controller.selectedBook,
            items: controller.books
                .map((e) => DropdownMenuItem<String>(
                      value: e,
                      child: Text(e),
                    ))
                .toList(),
            onChanged: (value) =>
                setState(() => controller.selectedBook = value),
          )
        ],
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    switch (controller.state) {
      case BooksState.success:
        return ListView.builder(
          itemCount: controller.cases.length,
          itemBuilder: (context, index) {
            final caseItem = controller.cases[index];

            return Card(
              child: ListTile(
                leading: Text(
                  (index + 1).toString().padLeft(3, '0'),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                title: Text(caseItem.name),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CluesList(caseData: caseItem),
                  ));
                },
              ),
            );
          },
        );
      case BooksState.loading:
        return const Center(child: CircularProgressIndicator());
      case BooksState.empty:
        return const Center(child: Text('No cases found'));
      default:
        return const Center(child: Text('Something went wrong'));
    }
  }
}
