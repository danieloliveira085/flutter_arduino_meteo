import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_arduino_meteo/sensors/sensors.dart';

class SingleGraph extends StatefulWidget {
  final List<double> data;
  final List<Color> gradientColors;
  final String scaleLabel;
  final String graphLabel;
  final bool enablePrecisionScale;

  const SingleGraph({
    Key? key,
    required this.data,
    required this.gradientColors,
    required this.scaleLabel,
    required this.graphLabel,
    required this.enablePrecisionScale,
  }) : super(key: key);

  @override
  _SingleGraphState createState() => _SingleGraphState();
}

class _SingleGraphState extends State<SingleGraph> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(20.0, 20.0, 0, 0),
          child: SizedBox(
            width: 200,
            height: 34,
            child: Text(
              widget.graphLabel,
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 55),
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.all(
            //   Radius.circular(18),
            // ),
            // color: Color(0xff232d37)),
            color: Color(0xff232d37).withAlpha(60),
            // color: Colors.transparent,
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                right: 18.0, left: 12.0, top: 24, bottom: 12),
            child: LineChart(mainData()),
          ),
        ),
      ],
    );
  }

  LineChartData mainData() {
    double minY = 0.0, maxY = 0.0;

    if (widget.data.isNotEmpty) {
      minY = maxY = widget.data.first;

      for (var val in widget.data) {
        if (minY > val) {
          minY = val;
        }

        if (maxY < val) {
          maxY = val;
        }
      }

      if (maxY == minY) {
        maxY += 5;
        minY -= 5;
      } else {
        double treshold = (maxY - minY) / 5;
        maxY += treshold;
        minY -= treshold;
      }
    }

    return LineChartData(
      lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.blueGrey[900]!.withAlpha(215),
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((LineBarSpot barSpot) {
                return LineTooltipItem(
                  widget.enablePrecisionScale
                      ? '${widget.data[barSpot.x.toInt()].toStringAsFixed(2)}${widget.scaleLabel}'
                      : '${widget.data[barSpot.x.toInt()].round()}${widget.scaleLabel}',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList();
            },
          )),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          interval: 1,
          getTextStyles: (context, value) => const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 16),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '5';
              case 2:
                return '10';
              case 3:
                return '15';
              case 4:
                return '20';
              case 5:
                return '25';
              case 6:
                return '30';
              case 7:
                return '35';
              case 8:
                return '40';
              case 9:
                return '45';
              case 10:
                return '50';
              case 11:
                return '55';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          interval: widget.enablePrecisionScale ? null : 1,
          getTextStyles: (context, value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            if (widget.enablePrecisionScale) {
              return value.toStringAsFixed(1).toString();
            }

            return value.round().toString();
          },
          reservedSize: 48,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 12,
      minY: minY.floorToDouble(),
      maxY: maxY.ceilToDouble(),
      lineBarsData: [
        LineChartBarData(
          spots: List.generate(widget.data.length,
              (index) => FlSpot(index.toDouble(), widget.data[index])),
          isCurved: true,
          colors: widget.gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors: widget.gradientColors
                .map((color) => color.withOpacity(0.3))
                .toList(),
          ),
        ),
      ],
    );
  }
}
