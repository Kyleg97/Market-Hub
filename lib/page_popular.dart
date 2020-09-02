import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:stock_stalker/api_reddit.dart';
import 'package:stock_stalker/api_stocktwits.dart';
import 'package:stock_stalker/trading_apps.dart';

class PopularPage extends StatefulWidget {
  final scrollController;
  PopularPage({this.scrollController}) : super();

  @override
  PopularPageState createState() => PopularPageState();
}

class PopularPageState extends State<PopularPage> {
  List<StocktwitsTrending> stocktwitsTrending;
  List<CommonTicker> redditTrending;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  int _currentSource = 0; // 0 stocktwits, 1 reddit, 2 google, 3 yahoo, etc...

  void _onRefresh() async {
    if (_currentSource == 0) {
      stocktwitsTrending = await StocktwitsTrending.fetchStocktwitsTrending();
    } else if (_currentSource == 1) {
      redditTrending = await RedditTrending.fetchRedditTrending();
    }
    _refreshController.refreshCompleted();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    callStocktwits();
    callReddit();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /*void loadStocktwits() async {
    setState(() {
      trending = null;
    });
    trending = await StocktwitsTrending.fetchStocktwitsTrending();
    setState(() {});
  }*/

  void callStocktwits() async {
    stocktwitsTrending = await StocktwitsTrending.fetchStocktwitsTrending();
    setState(() {});
  }

  void callReddit() async {
    redditTrending = await RedditTrending.fetchRedditTrending();
    setState(() {});
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
      appBar: AppBar(actions: [
        Container(
          padding: EdgeInsets.fromLTRB(0, 10, 5, 10),
          child: FlatButton(
            onPressed: () {
              setState(() {
                _currentSource = 0;
              });
            },
            child: Text("Stocktwits"),
            color: _currentSource == 0 ? Colors.teal : Colors.transparent,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
            child: Text("Reddit"),
            color: _currentSource == 1 ? Colors.teal : Colors.transparent,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
        /*Container(
          padding: EdgeInsets.fromLTRB(0, 10, 5, 10),
          child: FlatButton(
            onPressed: () {
              setState(() {
                _currentSource = 2;
              });
            },
            child: Text("Yahoo!"),
            color: _currentSource == 2 ? Colors.teal : Colors.transparent,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(0, 10, 5, 10),
          child: FlatButton(
            onPressed: () {
              setState(() {
                _currentSource = 3;
              });
            },
            child: Text("Robinhood"),
            color: _currentSource == 3 ? Colors.teal : Colors.transparent,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),*/
      ]),
      body: SafeArea(
        child: stocktwitsTrending == null
            ? Center(child: CircularProgressIndicator())
            : _currentSource == 0
                ? SmartRefresher(
                    enablePullDown: true,
                    header: WaterDropHeader(),
                    controller: _refreshController,
                    onRefresh: _onRefresh,
                    child: ListView.builder(
                      controller: widget.scrollController,
                      padding: const EdgeInsets.all(5),
                      itemCount: stocktwitsTrending.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 10,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                onTap: () {
                                  TradingApps.installedApps.forEach((element) {
                                    if (element["app_name"] == "Robinhood") {
                                      leavingAppDialog(
                                          stocktwitsTrending[index].symbol);
                                      return;
                                    }
                                  });
                                },
                                title: Text(stocktwitsTrending[index].symbol),
                                subtitle: Text(stocktwitsTrending[index].name),
                                trailing: Text(stocktwitsTrending[index]
                                    .watchlistCount
                                    .toString()),
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
                      itemCount: stocktwitsTrending.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 10,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                onTap: () {
                                  TradingApps.installedApps.forEach((element) {
                                    if (element["app_name"] == "Robinhood") {
                                      leavingAppDialog(
                                          stocktwitsTrending[index].symbol);
                                      return;
                                    }
                                  });
                                },
                                title: Text(redditTrending[index].tickerName),
                                subtitle:
                                    Text(redditTrending[index].companyName),
                                trailing: Text(redditTrending[index]
                                    .totalMentionCount
                                    .toString()),
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
