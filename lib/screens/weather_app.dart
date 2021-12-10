import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_arduino_meteo/sensors/sensors.dart';
import 'package:flutter_arduino_meteo/constants.dart';
import 'package:flutter_arduino_meteo/controllers/app_bar_controller.dart';
import 'package:flutter_arduino_meteo/controllers/main_screen_controller.dart';
import 'package:flutter_arduino_meteo/widgets/single_graph.dart';
import 'package:flutter_arduino_meteo/widgets/single_weather.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:usb_serial/transaction.dart';
import 'package:usb_serial/usb_serial.dart';
import 'package:intl/intl.dart';

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  UsbPort? _port;
  String _status = "Idle";
  List<String> _serialData = [];

  StreamSubscription<String>? _subscription;
  Transaction<String>? _transaction;
  UsbDevice? _device;

  Sensors _sensors = Sensors();

  DateTime? dt;
  DateFormat hf = DateFormat.Hm();
  Timer? t;

  @override
  void initState() {
    super.initState();

    t = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        dt = DateTime.now();
      });
    });

    UsbSerial.usbEventStream!.listen((UsbEvent msg) {
      if (msg.event == UsbEvent.ACTION_USB_ATTACHED) {
        _getDevice();
      }
      if (msg.event == UsbEvent.ACTION_USB_DETACHED) {
        _connectTo(null);
        _sensors.resetData();
      }
    });

    _getDevice();
  }

  @override
  void dispose() {
    _connectTo(null);

    if (t != null) {
      t!.cancel();
    }

    super.dispose();
  }

  Future<bool> _connectTo(device) async {
    _serialData.clear();

    if (_subscription != null) {
      _subscription!.cancel();
      _subscription = null;
    }

    if (_transaction != null) {
      _transaction!.dispose();
      _transaction = null;
    }

    if (_port != null) {
      _port!.close();
      _port = null;
    }

    if (device == null) {
      _device = null;
      setState(() {
        _status = "Disconnected";
      });
      return true;
    }

    _port = await device.create();
    if (await (_port!.open()) != true) {
      setState(() {
        _status = "Failed to open port";
      });
      return false;
    }
    _device = device;

    await _port!.setPortParameters(
        9600, UsbPort.DATABITS_8, UsbPort.STOPBITS_1, UsbPort.PARITY_NONE);
    await _port!.setFlowControl(UsbPort.FLOW_CONTROL_OFF);

    _transaction = Transaction.stringTerminated(
        _port!.inputStream as Stream<Uint8List>, Uint8List.fromList([13, 10]));

    _subscription = _transaction!.stream.listen((String line) {
      setState(() {
        _serialData.add(line);
        _sensors.parseData(line);
      });
    });

    setState(() {
      _status = "Connected";
    });
    return true;
  }

  Future<void> _getDevice() async {
    List<UsbDevice> devices = await UsbSerial.listDevices();

    if (devices.isNotEmpty) {
      await _connectTo(devices[0]);
    }

    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Consumer<AppBarController>(
            builder: (context, state, child) {
              switch (state.widget) {
                case AppBarState.showMenuButton:
                  return Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                    child: GestureDetector(
                      onTap: () {},
                      child: SvgPicture.asset(
                        'assets/menu.svg',
                        height: 30,
                        width: 30,
                        color: Colors.white,
                      ),
                    ),
                  );

                case AppBarState.displayHour:
                  return Container(
                    margin: EdgeInsets.fromLTRB(0, 18, 20, 0),
                    child: Text(
                      dt != null ? hf.format(dt!) : '--:--',
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  );

                case AppBarState.showCloseButton:
                  return GestureDetector(
                    onTap: () {
                      Provider.of<AppBarController>(context, listen: false)
                          .setWidgetState(AppBarState.displayHour);
                      Provider.of<MainScreenController>(context, listen: false)
                          .setWidgetState(MainWidgetState.weather);
                    },
                    child: Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                        child: Icon(
                          Icons.close,
                          size: 28.0,
                        )),
                  );
              }
            },
          ),
        ],
      ),
      body: Container(
        child: Stack(
          children: [
            Image.asset(
              bgImg,
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
            Container(
              decoration: BoxDecoration(color: Colors.black38),
            ),
            Consumer<MainScreenController>(
              builder: (context, state, child) {
                switch (state.widget) {
                  case MainWidgetState.weather:
                    return SingleWeather(_sensors);

                  case MainWidgetState.barometerGraph:
                    return SingleGraph(
                      data: _sensors.pressure,
                      gradientColors: [
                        Colors.blueAccent[700]!,
                        Colors.cyanAccent,
                      ],
                      scaleLabel: pressureScale,
                      graphLabel:
                          language == portuguese ? 'Pressão:' : 'Pressure',
                      enablePrecisionScale: true,
                    );

                  case MainWidgetState.humidityGraph:
                    return SingleGraph(
                      data: _sensors.humidity,
                      gradientColors: [
                        Colors.cyan,
                        Colors.greenAccent,
                      ],
                      scaleLabel: "%",
                      graphLabel:
                          language == portuguese ? 'Umidade:' : 'Humidity',
                      enablePrecisionScale: false,
                    );

                  case MainWidgetState.airQualityGraph:
                    return SingleGraph(
                      data: _sensors.airQuality,
                      gradientColors: [
                        Colors.greenAccent,
                        Colors.blueAccent[700]!,
                      ],
                      scaleLabel: airQualityScale,
                      graphLabel: language == portuguese
                          ? 'Qualidade do Ar:'
                          : 'Air Quality',
                      enablePrecisionScale: true,
                    );

                  case MainWidgetState.temperatureGraph:
                    return SingleGraph(
                      data: _sensors.temperature,
                      gradientColors: [
                        Colors.amber,
                        Colors.redAccent,
                      ],
                      scaleLabel: temperatureScale,
                      graphLabel: language == portuguese
                          ? 'Temperatura'
                          : 'Temperature',
                      enablePrecisionScale: true,
                    );

                  default:
                    return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
