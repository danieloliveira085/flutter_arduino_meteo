import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_arduino_meteo/sensors/sensors.dart';
import 'package:flutter_arduino_meteo/constants.dart';
import 'package:flutter_arduino_meteo/controllers/app_bar_controller.dart';
import 'package:flutter_arduino_meteo/controllers/main_screen_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SingleWeather extends StatelessWidget {
  final Sensors data;
  SingleWeather(this.data);

  String _getWeatherIcon() {
    String state = data.getWeatherState();
    if (state == "Stormy" || state == "Tempestuoso") {
      return "assets/stormy.svg";
    }

    if (state == "Rainy" || state == "Chuvoso") {
      return "assets/rainy.svg";
    }

    if (state == "Unstable" || state == "Instável") {
      return "assets/cloudy2.svg";
    }

    if (state == "Dry" || state == "Seco") {
      return "assets/cloudy_sun.svg";
    }

    if (state == "Very dry" || state == "Muito seco") {
      return "assets/sunny.svg";
    }

    return "assets/default.svg";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Provider.of<AppBarController>(context, listen: false)
                      .setWidgetState(AppBarState.showCloseButton);
                  Provider.of<MainScreenController>(context, listen: false)
                      .setWidgetState(MainWidgetState.temperatureGraph);
                },
                child: Text(
                  data.temperature.isEmpty
                      ? '--'
                      : "${data.temperature.last.toStringAsFixed(0)} $temperatureScale",
                  style: GoogleFonts.lato(
                    fontSize: 75,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                  ),
                ),
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    _getWeatherIcon(),
                    width: 34,
                    height: 34,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10),
                  Text(
                    data.getWeatherState(),
                    // locationList[index].weatherType,
                    style: GoogleFonts.lato(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  Provider.of<AppBarController>(context, listen: false)
                      .setWidgetState(AppBarState.showCloseButton);
                  Provider.of<MainScreenController>(context, listen: false)
                      .setWidgetState(MainWidgetState.barometerGraph);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.av_timer,
                      color: Colors.blueAccent[700],
                    ),
                    SizedBox(width: defaultPadding / 2),
                    Text(
                      language == portuguese ? 'Pressão:' : 'Pressure:',
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: defaultPadding / 2),
                    Text(
                      data.pressure.isEmpty
                          ? '--'
                          : data.pressure.last.toStringAsFixed(0),
                      style: GoogleFonts.lato(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      pressureScale,
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: defaultPadding),
              GestureDetector(
                onTap: () {
                  Provider.of<AppBarController>(context, listen: false)
                      .setWidgetState(AppBarState.showCloseButton);
                  Provider.of<MainScreenController>(context, listen: false)
                      .setWidgetState(MainWidgetState.humidityGraph);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.opacity,
                      color: Colors.cyanAccent,
                    ),
                    SizedBox(width: defaultPadding / 2),
                    Text(
                      language == portuguese ? 'Umidade:' : 'Humidity:',
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: defaultPadding / 2),
                    Text(
                      data.humidity.isEmpty
                          ? '--'
                          : data.humidity.last.toStringAsFixed(0),
                      style: GoogleFonts.lato(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '%',
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: defaultPadding),
              GestureDetector(
                onTap: () {
                  Provider.of<AppBarController>(context, listen: false)
                      .setWidgetState(AppBarState.showCloseButton);
                  Provider.of<MainScreenController>(context, listen: false)
                      .setWidgetState(MainWidgetState.airQualityGraph);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.air,
                      color: Colors.greenAccent,
                    ),
                    SizedBox(width: defaultPadding / 2),
                    Text(
                      language == portuguese
                          ? 'Qualidade do Ar:'
                          : 'Air Quality:',
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: defaultPadding / 2),
                    SizedBox(
                      width: 126,
                      child: Text(
                        data.airQuality.isEmpty
                            ? '--'
                            : data.getFriendlyAirQuality(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.lato(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      '',
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          /* Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                locationList[index].city,
                style: GoogleFonts.lato(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 5),
              Text(
                locationList[index].dateTime,
                style: GoogleFonts.lato(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ), */
        ],
      ),
    );
  }
}
