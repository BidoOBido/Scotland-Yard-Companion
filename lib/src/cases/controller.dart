import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scotland_yard_companion/src/models/case.dart';

enum BooksState { success, loading, error, empty }

class BooksController {
  ValueNotifier<BooksState> stateNotifier =
      ValueNotifier<BooksState>(BooksState.empty);

  final Map<String, Map<String, Case>> _books = {};
  String? selectedBook;

  BooksState get state => stateNotifier.value;
  List<String> get books => _books.keys.toList();

  List<Case> get cases {
    if (selectedBook == null) {
      return [];
    }

    return _books[selectedBook]!.values.toList();
  }

  Future<void> loadBooks() async {
    try {
      stateNotifier.value = BooksState.loading;

      final String response = await rootBundle.loadString('assets/data.json');
      final Map<String, dynamic> json = jsonDecode(response);

      for (final book in json.keys) {
        final List<dynamic> cases = json[book];

        for (final c in cases) {
          final Case caseObj = Case.fromJson(c);

          if (_books[book] == null) {
            _books[book] = {};
          }

          _books[book]![caseObj.name] = caseObj;
        }
      }

      selectedBook = _books.keys.first;

      stateNotifier.value =
          _books.isEmpty ? BooksState.empty : BooksState.success;
    } catch (e) {
      log(e.toString());
      stateNotifier.value = BooksState.error;
    }
  }
}
