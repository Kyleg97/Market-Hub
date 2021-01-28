import 'package:MarketHub/models/unusual_volume_model.dart';
import 'package:MarketHub/pages/page_volume_graph.dart';
import 'package:MarketHub/providers/unusual_volume_provider.dart';
import 'package:MarketHub/services/helper.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class UnusualVolumePage extends StatefulWidget {
  UnusualVolumePage() : super();
  @override
  UnusualVolumePageState createState() => UnusualVolumePageState();
}

class UnusualVolumePageState extends State<UnusualVolumePage> {
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void openGraphDialog(BuildContext context, UnusualVolumeModel data) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          content: Builder(
            builder: (context) {
              // Get available height and width of the build area of this widget. Make a choice depending on the size.
              var height = MediaQuery.of(context).size.height;
              var width = MediaQuery.of(context).size.width;

              return Container(
                height: height / 2,
                width: width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 15, 5),
                      child: Text(
                        '${data.ticker} - ${data.company}',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 15, 15),
                      child: Text(
                        'Avg. Volume: ${toSuffix(data.meanVolume.toInt())}',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    VolumeChart(
                      data: data,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 15, 15),
                      child: Text(
                        'Maybe we can put a scatter plot graph here?',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Unusual Volume",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 16,
            fontStyle: null,
          ),
        ),
        backgroundColor: Theme.of(context).accentColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.elliptical(50, 20),
          ),
        ),
      ),
      body: Container(
        child: ChangeNotifierProvider.value(
          value: UnusualVolumeProvider(),
          child: Consumer<UnusualVolumeProvider>(
            builder: (context, provider, child) {
              return provider.isFetching
                  ? Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: () => provider.fetchData(),
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(5),
                        itemCount: provider.getItems.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              /*openGraphDialog(
                                context,
                                provider.getItems[index],
                              );*/
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VolumeGraphPage(
                                    data: provider.getItems[index],
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 5,
                              child: ListTile(
                                  title: Text(
                                    '${provider.getItems[index].ticker} - ${provider.getItems[index].company}',
                                  ),
                                  subtitle: Text(
                                    'Avg. Volume: ${toSuffix(provider.getItems[index].meanVolume.toInt())}',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  trailing: Container(
                                    child: Icon(
                                      Icons.open_in_new,
                                      color: Theme.of(context).accentColor,
                                    ),
                                  )),
                              /*child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(15, 0, 15, 5),
                                  child: Text(
                                    '${provider.getItems[index].ticker} - ${provider.getItems[index].company}',
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
                                  child: Text(
                                    'Avg. Volume: ${toSuffix(provider.getItems[index].meanVolume.toInt())}',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                                VolumeChart(
                                  data: provider.getItems[index],
                                ),
                              ],
                            ),*/
                            ),
                          );
                        },
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }
}
/*
// Volume Chart
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
  int currentSideTitleNum;

  @override
  void initState() {
    touchedValue = -1;
    xValues = widget.data.outlierVolume.keys.toList();
    yValues = widget.data.outlierVolume.values.toList();
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

  String toSuffix(int value) {
    const units = <int, String>{
      1000000000: 'B',
      1000000: 'M',
      1000: 'K',
    };
    return units.entries
        .map((e) => '${value ~/ e.key}${e.value}')
        .firstWhere((e) => !e.startsWith('0'), orElse: () => '$value');
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 170,
      child: LineChart(
        LineChartData(
          maxY: double.parse(yValues.last.toString()) * 2.0,
          lineTouchData: LineTouchData(
              getTouchedSpotIndicator:
                  (LineChartBarData barData, List<int> spotIndexes) {
                return spotIndexes.map((spotIndex) {
                  return TouchedSpotIndicatorData(
                    FlLine(color: Colors.blue, strokeWidth: 4),
                    FlDotData(
                      getDotPainter: (spot, percent, barData, index) {
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
                      return LineTooltipItem(
                        '${xValues[flSpot.x.toInt()]} \nVolume: ${flSpot.y}',
                        const TextStyle(color: Colors.white),
                      );
                    }).toList();
                  }),
              touchCallback: (LineTouchResponse lineTouch) {
                if (lineTouch.lineBarSpots.length == 1 &&
                    lineTouch.touchInput is! FlLongPressEnd &&
                    lineTouch.touchInput is! FlPanEnd) {
                  final value = lineTouch.lineBarSpots[0].x;
                  setState(() {
                    touchedValue = value;
                  });
                } else {
                  setState(() {
                    touchedValue = -1;
                  });
                }
              }),
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
                    return true;
                  },
                ),
              ),
              dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
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
                  color: Colors.black,
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
*/
