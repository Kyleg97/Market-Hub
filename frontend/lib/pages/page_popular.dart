import 'package:MarketHub/providers/stocktwits_provider.dart';
import 'package:MarketHub/widgets/stocktwits_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:MarketHub/api/api_reddit.dart';
import 'package:MarketHub/api/api_rhpopular.dart';
import 'package:MarketHub/api/api_stocktwits.dart';
import 'package:MarketHub/trading_apps.dart';

class PopularPage extends StatefulWidget {
  PopularPage() : super();

  @override
  PopularPageState createState() => PopularPageState();
}

class PopularPageState extends State<PopularPage> {
  List<StocktwitsTrending> stocktwitsTrending;
  List<CommonTicker> redditTrending;
  List<RhPopular> robinhoodTrending;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  ScrollController _scrollController = new ScrollController();

  int _currentSource = 0; // 0 stocktwits, 1 reddit, 2 google, 3 yahoo, etc...

  bool _isInit = true;
  bool _isLoadingStocktwits = false;
  bool _isLoadingReddit = false;
  bool _isLoadingRobinhood = false;

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
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoadingStocktwits = true;
        _isLoadingReddit = true;
        _isLoadingRobinhood = true;
      });
      Provider.of<StocktwitsProvider>(context)
          .fetchStocktwitsTrending()
          .then((_) {
        setState(() {
          _isLoadingStocktwits = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
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

  void callRobinhood() async {
    robinhoodTrending = await RobinhoodTrending.fetchRobinhoodTrending();
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
        //bottom: false,
        /*decoration: new BoxDecoration(
          gradient: new LinearGradient(
              colors: [Colors.teal[100], Colors.teal],
              begin: const FractionalOffset(0.0, 0.5),
              end: const FractionalOffset(0.5, 0.0),
              //radius: 1.5,
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),*/
        child: stocktwitsTrending == null
            ? Center(child: CircularProgressIndicator())
            : _currentSource == 0
                ? SmartRefresher(
                    enablePullDown: true,
                    header: WaterDropHeader(),
                    controller: _refreshController,
                    onRefresh: _onRefresh,
                    child: StocktwitsListViewBuilder(
                        scrollController: _scrollController),
                  )
                : _currentSource == 1
                    ? SmartRefresher(
                        enablePullDown: true,
                        header: WaterDropHeader(),
                        controller: _refreshController,
                        onRefresh: _onRefresh,
                        child: ListView.builder(
                          controller: _scrollController,
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
                          controller: _scrollController,
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

class StocktwitsListViewBuilder extends StatelessWidget {
  const StocktwitsListViewBuilder({
    Key key,
    @required ScrollController scrollController,
  })  : _scrollController = scrollController,
        super(key: key);

  final ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    final stocktwitsData = Provider.of<StocktwitsProvider>(context);
    final stocktwitsTrending = stocktwitsData.items;
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(5),
      itemCount: stocktwitsTrending.length,
      itemBuilder: (context, i) => StocktwitsCard(stocktwitsTrending[i].symbol,
          stocktwitsTrending[i].title, stocktwitsTrending[i].watchlistCount),
    );
  }
}
