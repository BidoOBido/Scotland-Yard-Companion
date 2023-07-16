import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scotland_yard_companion/src/models/case.dart';
import 'package:scotland_yard_companion/src/models/states.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BooksController {
  ValueNotifier<ControllerState> stateNotifier =
      ValueNotifier<ControllerState>(ControllerState.empty);

  final Map<String, Map<String, Case>> _books = {};
  String? selectedBook;

  ControllerState get state => stateNotifier.value;
  List<String> get books => _books.keys.toList();

  List<Case> get cases {
    if (selectedBook == null) {
      return [];
    }

    return _books[selectedBook]!.values.toList();
  }

  Future<void> loadBooks() async {
    try {
      stateNotifier.value = ControllerState.loading;

      final String response = await rootBundle.loadString('assets/data.json');
      final Map<String, dynamic> json = jsonDecode(response);

      for (final book in json.keys) {
        final List<dynamic> cases = json[book];

        _populateCases(cases, book);
      }

      selectedBook = _books.keys.first;

      stateNotifier.value =
          _books.isEmpty ? ControllerState.empty : ControllerState.success;
    } catch (e) {
      stateNotifier.value = ControllerState.error;
    }
  }

  Future<void> saveConfigurations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('selectedBook', selectedBook!);

    for (var collection in _books.entries) {
      prefs.setString(collection.key, jsonEncode(collection.value));
    }
  }

  Future<bool> loadConfigurations() async {
    try {
      stateNotifier.value = ControllerState.loading;

      await loadBooks();

      SharedPreferences prefs = await SharedPreferences.getInstance();

      selectedBook = prefs.getString('selectedBook');
      if (selectedBook == null) {
        return false;
      }

      for (var collection in _books.entries) {
        final String? json = prefs.getString(collection.key);

        if (json != null) {
          final Map<String, dynamic> cases = jsonDecode(json);

          _populateCases(cases.values.toList(), collection.key);
        }
      }

      stateNotifier.value = ControllerState.success;

      return true;
    } catch (e) {
      log(e.toString());
      stateNotifier.value = ControllerState.error;

      return false;
    }
  }

  void _populateCases(List<dynamic> cases, String book) {
    for (final c in cases) {
      final Case caseObj = Case.fromJson(c);

      if (_books[book] == null) {
        _books[book] = {};
      }

      _books[book]![caseObj.name] = caseObj;
    }
  }
}
