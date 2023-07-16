import 'package:flutter/material.dart';
import 'package:scotland_yard_companion/src/cases/controller.dart';
import 'package:scotland_yard_companion/src/models/states.dart';

class HomeController {
  ValueNotifier<ControllerState> stateNotifier =
      ValueNotifier<ControllerState>(ControllerState.empty);

  BooksController booksController = BooksController();

  bool containsSavedData = false;

  ControllerState get state => stateNotifier.value;

  Future<void> loadSavedData() async {
    try {
      stateNotifier.value = ControllerState.loading;

      containsSavedData = await booksController.loadConfigurations();

      stateNotifier.value =
          containsSavedData ? ControllerState.success : ControllerState.empty;
    } catch (e) {
      stateNotifier.value = ControllerState.error;
    }
  }
}
