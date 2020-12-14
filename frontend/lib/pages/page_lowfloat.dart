import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:MarketHub/api/api_reddit.dart';
import 'package:MarketHub/api/api_rhpopular.dart';
import 'package:MarketHub/api/api_stocktwits.dart';
import 'package:MarketHub/trading_apps.dart';

class LowfloatPage extends StatefulWidget {
  final scrollController;
  LowfloatPage({this.scrollController}) : super();

  @override
  LowfloatPageState createState() => LowfloatPageState();
}

class LowfloatPageState extends State<LowfloatPage> {
  List<StocktwitsTrending> stocktwitsTrending;
  List<CommonTicker> redditTrending;
  List<RhPopular> robinhoodTrending;

  int avgStocktwitsWatchlistCount;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  int _currentSource = 0; // 0 stocktwits, 1 reddit, 2 google, 3 yahoo, etc...

  void _onRefresh() async {
    if (_currentSource == 0) {
      stocktwitsTrending = await StocktwitsTrending.fetchStocktwitsTrending();
    } else if (_currentSource == 1) {
      redditTrending = await RedditTrending.fetchRedditTrending();
    } else if (_currentSource == 2) {
      robinhoodTrending = await RobinhoodTrending.fetchRobinhoodTrending();
    }
    _refreshController.refreshCompleted();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    callStocktwits();
    callReddit();
    callRobinhood();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void callStocktwits() async {
    stocktwitsTrending = await StocktwitsTrending.fetchStocktwitsTrending();
    avgStocktwitsWatchlistCount = calculateAverageWatchlist();
    setState(() {});
  }

  void callReddit() async {
    redditTrending = await RedditTrending.fetchRedditTrending();
    setState(() {});
  }

  void callRobinhood() async {
    robinhoodTrending = await RobinhoodTrending.fetchRobinhoodTrending();
  }

  int calculateAverageWatchlist() {
    int sum = 0;
    stocktwitsTrending.forEach((element) {
      if (element.watchlistCount != -1000) {
        sum += element.watchlistCount;
      }
    });
    return (sum / stocktwitsTrending.length).round();
  }

  void moreInfoDialog(String ticker) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Card(
              child: Column(
                children: [
                  Text(ticker),
                  Text("testing"),
                  Text("hello"),
                ],
              ),
            ),
          );
        });
  }

  void leavingAppDialog(String ticker) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Alert"),
          content: Text("Do you want to view $ticker on Robinhood?"),
          actions: <Widget>[
            FlatButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Yes"),
              onPressed: () {
                TradingApps.launchURL(ticker);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.elliptical(50, 20),
          ),
        ),
        actions: [
          Container(
            padding: EdgeInsets.fromLTRB(0, 10, 5, 10),
            child: FlatButton(
              onPressed: () {
                setState(() {
                  _currentSource = 0;
                });
              },
              child: Text(
                "Stocktwits",
                style: TextStyle(
                    color: _currentSource == 0 ? Colors.teal : Colors.white),
              ),
              color: _currentSource == 0
                  ? Theme.of(context).selectedRowColor
                  : Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 10, 5, 10),
            child: FlatButton(
              onPressed: () {
                setState(() {
                  _currentSource = 1;
                });
              },
              child: Text(
                "Reddit",
                style: TextStyle(
                    color: _currentSource == 1 ? Colors.teal : Colors.white),
              ),
              color: _currentSource == 1
                  ? Theme.of(context).selectedRowColor
                  : Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 10, 5, 10),
            child: FlatButton(
              onPressed: () {
                setState(() {
                  _currentSource = 2;
                });
              },
              child: Text(
                "Robinhood",
                style: TextStyle(
                    color: _currentSource == 2 ? Colors.teal : Colors.white),
              ),
              color: _currentSource == 2
                  ? Theme.of(context).selectedRowColor
                  : Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ],
      ),
      body: Container(
        child: stocktwitsTrending == null
            ? Center(child: CircularProgressIndicator())
            : _currentSource == 0
                ? SmartRefresher(
                    enablePullDown: true,
                    header: WaterDropHeader(),
                    controller: _refreshController,
                    onRefresh: _onRefresh,
                    child: GridView.builder(
                      itemCount: stocktwitsTrending.length,
                      controller: widget.scrollController,
                      padding: const EdgeInsets.all(5),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4),
                      itemBuilder: (context, index) {
                        return Card(
                          /*color: stocktwitsTrending[index].watchlistCount >=
                                  avgStocktwitsWatchlistCount
                              ? Colors.teal
                              : Colors.pink[400],*/
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          elevation: 5,
                          child: InkWell(
                            onTap: () => moreInfoDialog(
                                stocktwitsTrending[index].symbol),
                            child: Center(
                              child: Text(
                                stocktwitsTrending[index].symbol,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.w300),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : _currentSource == 1
                    ? SmartRefresher(
                        enablePullDown: true,
                        header: WaterDropHeader(),
                        controller: _refreshController,
                        onRefresh: _onRefresh,
                        child: ListView.builder(
                          controller: widget.scrollController,
                          padding: const EdgeInsets.all(5),
                          itemCount: redditTrending.length,
                          itemBuilder: (context, index) {
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              elevation: 5,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    onTap: () {
                                      TradingApps.installedApps
                                          .forEach((element) {
                                        if (element["app_name"] ==
                                            "Robinhood") {
                                          leavingAppDialog(
                                              redditTrending[index].tickerName);
                                          return;
                                        }
                                      });
                                    },
                                    title:
                                        Text(redditTrending[index].tickerName),
                                    subtitle:
                                        Text(redditTrending[index].companyName),
                                    trailing: Text(
                                      "Mentions:\n" +
                                          redditTrending[index]
                                              .totalMentionCount
                                              .toString(),
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    : SmartRefresher(
                        enablePullDown: true,
                        header: WaterDropHeader(),
                        controller: _refreshController,
                        onRefresh: _onRefresh,
                        child: ListView.builder(
                          controller: widget.scrollController,
                          padding: const EdgeInsets.all(5),
                          itemCount: robinhoodTrending.length,
                          itemBuilder: (context, index) {
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              elevation: 5,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    onTap: () {
                                      TradingApps.installedApps
                                          .forEach((element) {
                                        if (element["app_name"] ==
                                            "Robinhood") {
                                          leavingAppDialog(
                                              robinhoodTrending[index]
                                                  .tickerName);
                                          return;
                                        }
                                      });
                                    },
                                    title: Text(
                                        robinhoodTrending[index].tickerName),
                                    subtitle: Text(
                                        robinhoodTrending[index].companyName),
                                    trailing: Text(
                                      "Volume:\n" +
                                          robinhoodTrending[index]
                                              .currentVolume
                                              .toString(),
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
      ),
    );
  }
}
