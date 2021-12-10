import 'package:flutter_arduino_meteo/constants.dart';

class Sensors {
  static const int maxItens = 13;

  List<double> pressure = [];
  List<double> temperature = [];
  List<double> humidity = [];
  List<double> airQuality = [];

  // Sensors(
  //   this.pressure,
  //   this.temperature,
  //   this.humidity,
  //   this.airQuality,
  // );

  void parseData(String data) {
    if (data.contains("Pressure")) {
      pressure.add(double.parse(data.replaceAll(RegExp(r'Pressure: '), "")));

      if (pressure.length > maxItens) {
        pressure.removeAt(0);
      }
    }

    if (data.contains("Temperature")) {
      temperature
          .add(double.parse(data.replaceAll(RegExp(r'Temperature: '), "")));

      if (temperature.length > maxItens) {
        temperature.removeAt(0);
      }
    }

    if (data.contains("Humidity")) {
      humidity.add(double.parse(data.replaceAll(RegExp(r'Humidity: '), "")));

      if (humidity.length > maxItens) {
        humidity.removeAt(0);
      }
    }

    if (data.contains("AirQuality")) {
      airQuality
          .add(double.parse(data.replaceAll(RegExp(r'AirQuality: '), "")));

      if (airQuality.length > maxItens) {
        airQuality.removeAt(0);
      }
    }
  }

  void resetData() {
    pressure.clear();
    temperature.clear();
    humidity.clear();
    airQuality.clear();
  }

  String getFriendlyAirQuality() {
    if (airQuality.last < 700) {
      return language == portuguese ? "Excelente" : "Excellent";
    } else if (airQuality.last >= 700 && airQuality.last < 1100) {
      return language == portuguese ? "Bom" : "Good";
    } else if (airQuality.last >= 1100 && airQuality.last < 1600) {
      return language == portuguese ? "Contaminado" : "Contamined";
    } else if (airQuality.last >= 1600 && airQuality.last < 2100) {
      return language == portuguese
          ? "Muito contaminado"
          : "Heavily contaminated";
    } else if (airQuality.last >= 2100) {
      return language == portuguese ? "Extremo" : "Extreme";
    }

    return "--";
  }

  String getWeatherState() {
    if (pressure.isNotEmpty) {
      if (pressure.last.round() < 965) {
        return language == portuguese ? "Tempestuoso" : "Stormy";
      } else if (pressure.last.round() >= 965 && pressure.last.round() < 982) {
        return language == portuguese ? "Chuvoso" : "Rainy";
      } else if (pressure.last.round() >= 982 && pressure.last.round() < 1015) {
        return language == portuguese ? "Instável" : "Unstable";
      } else if (pressure.last.round() >= 1015 &&
          pressure.last.round() < 1032) {
        return language == portuguese ? "Seco" : "Dry";
      } else if (pressure.last.round() >= 1032) {
        return language == portuguese ? "Muito seco" : "Very dry";
      }
    }

    return "--";
  }
}
