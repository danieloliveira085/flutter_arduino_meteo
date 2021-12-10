import 'package:flutter/material.dart';

enum MainWidgetState {
  weather,
  barometerGraph,
  humidityGraph,
  airQualityGraph,
  temperatureGraph,
}

class MainScreenController extends ChangeNotifier {
  /// Internal, private state of the cart.
  MainWidgetState _state = MainWidgetState.weather;

  /// An unmodifiable view of the items in the cart.
  MainWidgetState get widget => _state;

  void setWidgetState(MainWidgetState state) {
    switch (state) {
      case MainWidgetState.weather:
        _state = MainWidgetState.weather;
        break;

      case MainWidgetState.barometerGraph:
        _state = MainWidgetState.barometerGraph;
        break;

      case MainWidgetState.humidityGraph:
        _state = MainWidgetState.humidityGraph;
        break;

      case MainWidgetState.airQualityGraph:
        _state = MainWidgetState.airQualityGraph;
        break;

      case MainWidgetState.temperatureGraph:
        _state = MainWidgetState.temperatureGraph;
        break;
    }

    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
}
