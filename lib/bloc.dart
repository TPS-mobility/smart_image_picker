import 'package:flutter/material.dart';

enum ViewState { Idle, Busy }
class UserBloc extends ChangeNotifier {
  ViewState _state = ViewState.Idle;
  ViewState get state => _state;

  setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }
}
