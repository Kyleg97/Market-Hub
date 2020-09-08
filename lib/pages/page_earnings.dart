import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:MarketHub/api/api_earnings.dart';
import 'package:intl/intl.dart';

class EarningsPage extends StatefulWidget {
  EarningsPage({Key key}) : super(key: key);
  @override
  EarningsPageState createState() => EarningsPageState();
}

class EarningsPageState extends State<EarningsPage> {
  TextStyle textStyle = TextStyle(fontSize: 18, fontFamily: 'Montserrat');
  List<EarningsInfo> earnings;

  ScrollController _scrollController = new ScrollController();

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  CustomDropDownItem _currentDropdownValue;
  List<CustomDropDownItem> _customDropdownItems = [
    CustomDropDownItem(Icon(Icons.arrow_upward), "Volume", 1),
    CustomDropDownItem(Icon(Icons.arrow_upward), "Date", 1),
    CustomDropDownItem(Icon(Icons.arrow_upward), "EPS Estimate", 1),
    CustomDropDownItem(Icon(Icons.arrow_downward), "Volume", -1),
    CustomDropDownItem(Icon(Icons.arrow_downward), "Date", -1),
    CustomDropDownItem(Icon(Icons.arrow_downward), "EPS Estimate", -1),
  ];

  int averageVolume = 0;

  final NumberFormat volumeFormatter = new NumberFormat("#,##0", "en_US");

  final DateFormat datetimeFormatter = new DateFormat('MM/dd/yyyy hh:mm a');

  DateTime currentDate;

  void _onRefresh() async {
    await callEarnings();
    if (_currentDropdownValue != null) {
      sort(_currentDropdownValue);
    }
    _refreshController.refreshCompleted();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    callEarnings();
  }

  @override
  void dispose() {
    super.dispose();
  }

  callEarnings() async {
    earnings = await Earnings.fetchEarnings();
    averageVolume = calculateAverageVolume();
    print("Average Volume: " + averageVolume.toString());
    setState(() {});
  }

  void sort(CustomDropDownItem value) {
    setState(() {
      if (value.word == "Volume" && value.function == 1) {
        earnings.sort((b, a) => a.currentVolume.compareTo(b.currentVolume));
      } else if (value.word == "Volume" && value.function == -1) {
        earnings.sort((a, b) => a.currentVolume.compareTo(b.currentVolume));
      } else if (value.word == "Date" && value.function == 1) {
        earnings
            .sort((a, b) => a.earningsDatetime.compareTo(b.earningsDatetime));
      } else if (value.word == "Date" && value.function == -1) {
        earnings
            .sort((b, a) => a.earningsDatetime.compareTo(b.earningsDatetime));
      } else if (value.word == "EPS Estimate" && value.function == 1) {
        earnings.sort((a, b) => a.epsEstimate.compareTo(b.epsEstimate));
      } else if (value.word == "EPS Estimate" && value.function == -1) {
        earnings.sort((b, a) => a.epsEstimate.compareTo(b.epsEstimate));
      }
    });
  }

  int calculateAverageVolume() {
    int sum = 0;
    earnings.forEach((element) {
      if (element.currentVolume != -1000) {
        sum += element.currentVolume;
      }
    });
    return (sum / earnings.length).round();
  }

  @override
  Widget build(BuildContext context) {
    return earnings == null
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              actions: [
                DropdownButtonHideUnderline(
                  child: DropdownButton<CustomDropDownItem>(
                    dropdownColor: Theme.of(context).accentColor,
                    iconEnabledColor: Colors.white,
                    hint: Text(
                      "Sort By",
                      textAlign: TextAlign.right,
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    value: _currentDropdownValue,
                    onChanged: (CustomDropDownItem value) {
                      setState(() {
                        _currentDropdownValue = value;
                        sort(value);
                        _scrollController.animateTo(0.0,
                            curve: Curves.easeOut,
                            duration: const Duration(milliseconds: 300));
                      });
                    },
                    items: _customDropdownItems.map((CustomDropDownItem item) {
                      return DropdownMenuItem<CustomDropDownItem>(
                        value: item,
                        child: Row(
                          children: <Widget>[
                            item.icon,
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              item.word,
                              style: Theme.of(context).textTheme.headline1,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            body: SafeArea(
              child: earnings == null
                  ? CircularProgressIndicator()
                  : SmartRefresher(
                      enablePullDown: true,
                      header: WaterDropHeader(),
                      controller: _refreshController,
                      onRefresh: _onRefresh,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(10),
                        controller: _scrollController,
                        itemCount: earnings.length,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 5,
                            child: InkWell(
                              onTap: () {},
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(15, 10, 15, 0),
                                      child: Text(
                                        earnings[index].tickerName,
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(15, 10, 15, 0),
                                      child: Text(
                                        earnings[index].companyName + "\n",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Align(
                                        alignment: Alignment.center,
                                        child: Card(
                                          elevation: 5,
                                          margin: EdgeInsets.fromLTRB(
                                              15, 10, 15, 0),
                                          color: Colors.white, //Colors.black12,
                                          child: Padding(
                                            padding: EdgeInsets.all(15),
                                            child: Column(
                                              children: [
                                                Text("Current Volume:"),
                                                earnings[index].currentVolume ==
                                                        -1000
                                                    ? Text("Unavailable")
                                                    : Text(
                                                        volumeFormatter.format(
                                                            earnings[index]
                                                                .currentVolume),
                                                        style: TextStyle(
                                                            color: earnings[index]
                                                                        .currentVolume <
                                                                    averageVolume
                                                                ? Colors.red
                                                                : Colors.green),
                                                      ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        child: Card(
                                            margin: EdgeInsets.fromLTRB(
                                                15, 10, 15, 0),
                                            elevation: 5,
                                            color:
                                                Colors.white, //Colors.black12,
                                            child: Padding(
                                                padding: EdgeInsets.all(15),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text("EPS Estimate:"),
                                                    earnings[index]
                                                                .epsEstimate ==
                                                            -1000
                                                        ? Text("Unavailable")
                                                        : Text(
                                                            earnings[index]
                                                                .epsEstimate
                                                                .toString(),
                                                            style: TextStyle(
                                                                color: earnings[index]
                                                                            .epsEstimate <
                                                                        0
                                                                    ? Colors.red
                                                                    : Colors
                                                                        .green),
                                                          ),
                                                  ],
                                                ))),
                                      ),
                                    ],
                                  ),
                                  Align(
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                            "Earnings release: " +
                                                datetimeFormatter.format(
                                                    earnings[index]
                                                        .earningsDatetime),
                                            style: textStyle.copyWith(
                                                fontSize: 16)),
                                      ))
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          );
  }
}

class CustomDropDownItem {
  Icon icon;
  String word;
  int function;
  CustomDropDownItem(this.icon, this.word, this.function);
}
