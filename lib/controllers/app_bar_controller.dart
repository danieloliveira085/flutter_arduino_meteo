import 'package:flutter/material.dart';

enum AppBarState {
  showCloseButton,
  showMenuButton,
  displayHour,
}

class AppBarController extends ChangeNotifier {
  /// Internal, private state of the cart.
  AppBarState _state = AppBarState.displayHour;

  /// An unmodifiable view of the items in the cart.
  AppBarState get widget => _state;

  void setWidgetState(AppBarState state) {
    switch (state) {
      case AppBarState.showMenuButton:
        _state = AppBarState.showMenuButton;
        break;

      case AppBarState.showCloseButton:
        _state = AppBarState.showCloseButton;
        break;

      case AppBarState.displayHour:
        _state = AppBarState.displayHour;
        break;
    }

    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
}
