import 'package:MarketHub/models/unusual_volume_model.dart';
import 'package:MarketHub/services/helper.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VolumeGraphPage extends StatefulWidget {
  final UnusualVolumeModel data;
  const VolumeGraphPage({Key key, this.data}) : super(key: key);
  @override
  VolumeGraphPageState createState() => VolumeGraphPageState();
}

class VolumeGraphPageState extends State<VolumeGraphPage> {
  List<dynamic> xValues;
  List<dynamic> yValues;
  final DateFormat formatter = DateFormat('MM/dd/yyyy');

  @override
  void initState() {
    /*SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);*/
    xValues = widget.data.outlierVolume.keys.toList();
    yValues = widget.data.outlierVolume.values.toList();
    super.initState();
  }

  @override
  void dispose() {
    /*SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);*/
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.data.ticker} - ${widget.data.company}",
          style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 14),
        ),
        backgroundColor: Theme.of(context).accentColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.elliptical(50, 20),
          ),
        ),
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /*Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 15, 5),
                child: Text(
                  '${widget.data.ticker} - ${widget.data.company}',
                ),
              ),*/
              Padding(
                padding: EdgeInsets.fromLTRB(10, 25, 10, 10),
                child: Text(
                  'Avg. Volume: ${toSuffix(widget.data.meanVolume.toInt())}',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 25, 10, 10),
                child: VolumeChart(
                  data: widget.data,
                ),
              ),
              /*Padding(
                padding: EdgeInsets.all(10),
                child: ScatterPlot(
                  data: widget.data,
                ),
              ),*/
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: ListView.builder(
                    itemCount: xValues.length,
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Text(
                                  '${formatter.format(DateTime.parse(xValues[index]))}: '),
                              Icon(Icons.arrow_forward),
                            ],
                          )
                          /*child: Text(
                          '${formatter.format(DateTime.parse(xValues[index]))}'
                          ':, ${widget.data.ticker} '
                          'moved from its average volume of '
                          '${toSuffix(widget.data.meanVolume)} to '
                          '${toSuffix(int.parse(yValues[index]))}',
                        ),*/
                          );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*
// Scatter Chart
class ScatterPlot extends StatefulWidget {
  ScatterPlot({Key key, @required UnusualVolumeModel data})
      : data = data,
        super(key: key);
  final UnusualVolumeModel data;
  @override
  ScatterPlotState createState() => ScatterPlotState();
}

class ScatterPlotState extends State<ScatterPlot> {
  final maxX = 75.0;
  final maxY = 75.0;
  final radius = 10.0;

  double averageVolumeRadius;
  double maxCoord = 0;

  bool showAverage = true;

  List<ScatterSpot> spotList = [];

  int touchedIndex;

  Color greyColor = Colors.grey;

  List<int> selectedSpots = [];

  int lastPanStartOnIndex = -1;

  Map<dynamic, dynamic> dataMap = {};

  @override
  void initState() {
    averageVolumeRadius = (widget.data.meanVolume.toDouble() / 100000) / 2;
    spotList = outlierData();
    Map<dynamic, dynamic> temp = widget.data.outlierVolume;
    dataMap = Map.fromIterable(temp.values.toSet(),
        key: (k) => (double.parse(k) / 1000000) / 2,
        value: (v) => temp.keys.where((k) => temp[k] == v));
    print("dataMap: $dataMap");
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<ScatterSpot> outlierData() {
    List<ScatterSpot> list = [];
    list.add(ScatterSpot((maxX / 2), (maxY / 2),
        color: Colors.red, radius: averageVolumeRadius));
    var y = widget.data.outlierVolume.values.toList();
    y.forEach((element) {
      if (double.parse(element) > maxCoord) {
        maxCoord = double.parse(element);
      }
      list.add(ScatterSpot((Random().nextDouble() * (maxX - 8)) + 4,
          (Random().nextDouble() * (maxY - 8)) + 4,
          color: Colors.blue, radius: (double.parse(element) / 1000000) / 2));
      print("y list: $y");
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          showAverage = !showAverage;
        });
      },
      child: Center(
        child: ScatterChart(
          ScatterChartData(
            scatterSpots: spotList,
            minX: averageVolumeRadius,
            maxX: maxCoord,
            minY: averageVolumeRadius,
            maxY: maxCoord,
            borderData: FlBorderData(
              show: false,
            ),
            gridData: FlGridData(
              show: true,
              drawHorizontalLine: true,
              checkToShowHorizontalLine: (value) => true,
              getDrawingHorizontalLine: (value) =>
                  FlLine(color: Colors.white.withOpacity(0.1)),
              drawVerticalLine: true,
              checkToShowVerticalLine: (value) => true,
              getDrawingVerticalLine: (value) =>
                  FlLine(color: Colors.white.withOpacity(0.1)),
            ),
            titlesData: FlTitlesData(
              show: false,
            ),
            scatterTouchData: ScatterTouchData(
              enabled: true,
              touchTooltipData: ScatterTouchTooltipData(
                  tooltipBgColor: Colors.white,
                  getTooltipItems: (ScatterSpot touchedBarSpots) {
                    final flSpot = touchedBarSpots;
                    return ScatterTooltipItem(
                      flSpot.radius == averageVolumeRadius
                          ? 'Volume: ${(toSuffix((flSpot.radius.toInt() * 2) * 4))}\nDate: ${dataMap[flSpot.radius]}'
                          : 'Volume: ${(toSuffix((flSpot.radius.toInt() * 2) * 2))}\nDate: ${dataMap[flSpot.radius]}',
                      //'${xValues[flSpot.x.toInt()]} \nVolume: ${flSpot.y}',
                      const TextStyle(color: Colors.black),
                      radius / 2,
                    );
                  }),
              touchCallback: (ScatterTouchResponse touchResponse) {
                if (touchResponse.touchInput is FlPanStart) {
                  lastPanStartOnIndex = touchResponse.touchedSpotIndex;
                } else if (touchResponse.touchInput is FlPanEnd) {
                  final FlPanEnd flPanEnd = touchResponse.touchInput;

                  if (flPanEnd.velocity.pixelsPerSecond <= const Offset(4, 4)) {
                    // Tap happened
                    setState(
                      () {
                        if (selectedSpots.contains(lastPanStartOnIndex)) {
                          selectedSpots.remove(lastPanStartOnIndex);
                        } else {
                          selectedSpots.add(lastPanStartOnIndex);
                        }
                      },
                    );
                  }
                }
              },
            ),
          ),
          swapAnimationDuration: const Duration(milliseconds: 600),
        ),
      ),
    );
  }
}
*/
// Volume Charts
class VolumeChart extends StatefulWidget {
  VolumeChart({Key key, @required UnusualVolumeModel data})
      : data = data,
        super(key: key);
  final UnusualVolumeModel data;
  @override
  VolumeChartState createState() => VolumeChartState();
}

class VolumeChartState extends State<VolumeChart> {
  double touchedValue;
  List<dynamic> xValues;
  List<dynamic> yValues;
  bool finishDrawing;
  int currentSideTitleNum;

  @override
  void initState() {
    touchedValue = -1;
    xValues = widget.data.outlierVolume.keys.toList();
    yValues = widget.data.outlierVolume.values.toList();
    finishDrawing = xValues.length < 2;
    if (finishDrawing) {
      xValues.add(xValues[0]);
      yValues.add(yValues[0]);
    }
    print("xValues");
    print(xValues);
    print("yValues");
    print(yValues);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.3,
      height: MediaQuery.of(context).size.height / 3,
      child: LineChart(
        LineChartData(
          borderData: FlBorderData(
              show: true,
              border:
                  Border.all(color: Theme.of(context).accentColor, width: 1)),
          maxY: double.parse(yValues.last.toString()) * 2.0,
          lineTouchData: LineTouchData(
            getTouchedSpotIndicator:
                (LineChartBarData barData, List<int> spotIndexes) {
              return spotIndexes.map((spotIndex) {
                return TouchedSpotIndicatorData(
                  finishDrawing
                      ? spotIndex == 1
                          ? FlLine(color: Colors.blue, strokeWidth: 0)
                          : FlLine(color: Colors.blue, strokeWidth: 4)
                      : FlLine(color: Colors.blue, strokeWidth: 4),
                  FlDotData(
                    getDotPainter: (spot, percent, barData, index) {
                      if (finishDrawing) {
                        if (index == 1) {
                          return FlDotCirclePainter(
                            radius: 0,
                            color: Colors.white,
                            strokeWidth: 0,
                            strokeColor: Theme.of(context).accentColor,
                          );
                        }
                      }
                      if (index % 2 == 0) {
                        return FlDotCirclePainter(
                          radius: 8,
                          color: Colors.white,
                          strokeWidth: 3,
                          strokeColor: Colors.blue,
                        );
                      } else {
                        return FlDotSquarePainter(
                          size: 16,
                          color: Colors.white,
                          strokeWidth: 3,
                          strokeColor: Colors.blue,
                        );
                      }
                    },
                  ),
                );
              }).toList();
            },
            touchTooltipData: LineTouchTooltipData(
                tooltipBgColor: Colors.blueAccent,
                getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                  return touchedBarSpots.map((barSpot) {
                    final flSpot = barSpot;
                    if (finishDrawing) {
                      if (flSpot.x.toInt() == 1) {
                        return null;
                      }
                    }
                    return LineTooltipItem(
                      '${xValues[flSpot.x.toInt()]} \nVolume: ${toSuffix(flSpot.y.toInt())}',
                      const TextStyle(color: Colors.white),
                    );
                  }).toList();
                }),
            touchCallback: (LineTouchResponse lineTouch) {
              if (lineTouch.lineBarSpots.length == 1 &&
                  lineTouch.touchInput is! FlLongPressEnd &&
                  lineTouch.touchInput is! FlPanEnd) {
                final value = lineTouch.lineBarSpots[0].x;
                if (finishDrawing) {
                  if (value == 1) {
                    return;
                  }
                }
                setState(() {
                  touchedValue = value;
                });
              } else {
                setState(() {
                  touchedValue = -1;
                });
              }
            },
          ),
          /*extraLinesData: ExtraLinesData(
            horizontalLines: [
              HorizontalLine(
                y: widget.data.meanVolume.toDouble(),
                color: Colors.red.withOpacity(0.8),
                strokeWidth: 2,
                dashArray: [20, 2],
              ),
            ],
          ),*/
          lineBarsData: [
            LineChartBarData(
              isStepLineChart: true,
              spots: yValues.asMap().entries.map((e) {
                return FlSpot(e.key.toDouble(), double.parse(e.value));
              }).toList(),
              isCurved: false,
              barWidth: 2,
              colors: [
                Theme.of(context).accentColor,
              ],
              belowBarData: BarAreaData(
                show: true,
                colors: [
                  Theme.of(context).accentColor.withOpacity(0.5),
                  Theme.of(context).accentColor.withOpacity(0.0),
                ],
                gradientColorStops: [1.0, 1.0],
                gradientFrom: const Offset(0, 0),
                gradientTo: const Offset(0, 1),
                spotsLine: BarAreaSpotsLine(
                  show: true,
                  flLineStyle: FlLine(
                    color: Colors.blue,
                    strokeWidth: 2,
                  ),
                  checkToShowSpotLine: (spot) {
                    if (finishDrawing) {
                      if (spot.x == 1) {
                        return false;
                      } else {
                        return true;
                      }
                    }
                    return true;
                  },
                ),
              ),
              dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    if (finishDrawing) {
                      if (index == 1) {
                        return FlDotCirclePainter(
                          radius: 0,
                          color: Colors.white,
                          strokeWidth: 0,
                          strokeColor: Theme.of(context).accentColor,
                        );
                      }
                    }
                    if (index % 2 == 0) {
                      return FlDotCirclePainter(
                        radius: 6,
                        color: Colors.white,
                        strokeWidth: 1,
                        strokeColor: Colors.blue,
                      );
                    } else {
                      return FlDotSquarePainter(
                        size: 12,
                        color: Colors.white,
                        strokeWidth: 1,
                        strokeColor: Colors.blue,
                      );
                    }
                  },
                  checkToShowDot: (spot, barData) {
                    return true;
                  }),
            ),
          ],
          minY: 0,
          gridData: FlGridData(
            show: false,
            drawHorizontalLine: false,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) {
              if (value == 0) {
                return FlLine(
                  color: Theme.of(context).accentColor,
                  strokeWidth: 2,
                );
              } else {
                return FlLine(
                  color: Colors.grey,
                  strokeWidth: 0.5,
                );
              }
            },
            getDrawingVerticalLine: (value) {
              if (value == 0) {
                return FlLine(
                  color: Colors.white,
                  strokeWidth: 2,
                );
              } else {
                return FlLine(
                  color: Colors.grey,
                  strokeWidth: 0.5,
                );
              }
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            leftTitles: SideTitles(
              showTitles: true,
              reservedSize: 20,
              getTitles: (value) {
                int val = value.toInt();
                if (val == 0) return 'Avg.\nVol.';
                if (val % 3 == 0) return toSuffix(val);
                return '';
              },
              getTextStyles: (value) => const TextStyle(fontSize: 10),
            ),
            bottomTitles: SideTitles(
              showTitles: true,
              getTitles: (value) {
                // print("value: $value");
                // print("xValues: ${xValues[value.toInt()]}");
                //return xValues[value.toInt()];
              },
              getTextStyles: (value) {
                final isTouched = value == touchedValue;
                return TextStyle(
                  color: isTouched
                      ? Theme.of(context).accentColor
                      : Theme.of(context).accentColor.withOpacity(0.5),
                  fontWeight: FontWeight.bold,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
