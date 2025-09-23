import 'package:flutter/material.dart';

abstract class StatefulViewModel<S> extends ChangeNotifier {
  S _state;
  S get state => _state;

  StatefulViewModel(this._state);

  void setState(S state) {
    debugPrint(state.toString());
    _state = state;
    notifyListeners();
  }
}