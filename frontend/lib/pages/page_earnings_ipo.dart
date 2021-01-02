import 'package:MarketHub/providers/earnings_provider.dart';
import 'package:MarketHub/providers/ipos_provider.dart';
import 'package:MarketHub/widgets/earning_card.dart';
import 'package:MarketHub/widgets/ipo_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../providers/earnings_provider.dart';

class EarningsIPOPage extends StatefulWidget {
  EarningsIPOPage({Key key}) : super(key: key);
  @override
  EarningsIPOPageState createState() => EarningsIPOPageState();
}

class EarningsIPOPageState extends State<EarningsIPOPage> {
  TextStyle textStyle = TextStyle(fontSize: 18, fontFamily: 'Montserrat');

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  ScrollController _scrollController = new ScrollController();

  int _currentView = 0; // 0 == Earnings, 1 == IPO

  int averageVolume = 0;
  DateTime currentDate;

  CustomDropDownItem _currentDropdownValue;
  List<CustomDropDownItem> _customDropdownItems = [
    CustomDropDownItem(Icon(Icons.arrow_upward), "Volume", 1),
    CustomDropDownItem(Icon(Icons.arrow_upward), "Date", 1),
    CustomDropDownItem(Icon(Icons.arrow_upward), "EPS Estimate", 1),
    CustomDropDownItem(Icon(Icons.arrow_downward), "Volume", -1),
    CustomDropDownItem(Icon(Icons.arrow_downward), "Date", -1),
    CustomDropDownItem(Icon(Icons.arrow_downward), "EPS Estimate", -1),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /*void sort(CustomDropDownItem value) {
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
  }*/

  /*int calculateAverageVolume() {
    int sum = 0;
    earnings.forEach((element) {
      if (element.currentVolume != -1000) {
        sum += element.currentVolume;
      }
    });
    return (sum / earnings.length).round();
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
                  _currentView = 0;
                });
              },
              child: Text(
                "Upcoming Earnings",
                style: TextStyle(
                    color: _currentView == 0 ? Colors.teal : Colors.white),
              ),
              color: _currentView == 0
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
                  _currentView = 1;
                });
              },
              child: Text(
                "Upcoming IPOs",
                style: TextStyle(
                    color: _currentView == 1 ? Colors.teal : Colors.white),
              ),
              color: _currentView == 1
                  ? Theme.of(context).selectedRowColor
                  : Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: _currentView == 0
            ? EarningsPage(
                scrollController: _scrollController,
                refreshController: _refreshController,
              )
            : IpoPage(
                scrollController: _scrollController,
                refreshController: _refreshController),
      ),
    );
  }
}

// Earnings Page
class EarningsPage extends StatelessWidget {
  const EarningsPage({
    Key key,
    @required ScrollController scrollController,
    @required RefreshController refreshController,
  })  : _scrollController = scrollController,
        _refreshController = refreshController,
        super(key: key);

  final ScrollController _scrollController;
  final RefreshController _refreshController;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: EarningsProvider(),
      child: Consumer<EarningsProvider>(
        builder: (context, provider, child) {
          return provider.isFetching
              ? Center(child: CircularProgressIndicator())
              : SmartRefresher(
                  enablePullDown: true,
                  header: WaterDropHeader(),
                  controller: _refreshController,
                  onRefresh: () => provider.fetchData(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(10),
                    controller: _scrollController,
                    itemCount: provider.items.length,
                    itemBuilder: (context, i) => EarningItem(
                      provider.items[i].ticker,
                      provider.items[i].company,
                      provider.items[i].volume,
                      double.parse(provider.items[i].epsEstimate),
                      provider.items[i].datetime,
                      5, // replace later with average volume
                    ),
                  ),
                );
        },
      ),
    );
  }
}

// IPO Page
class IpoPage extends StatelessWidget {
  const IpoPage({
    Key key,
    @required ScrollController scrollController,
    @required RefreshController refreshController,
  })  : _scrollController = scrollController,
        _refreshController = refreshController,
        super(key: key);

  final ScrollController _scrollController;
  final RefreshController _refreshController;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: IposProvider(),
      child: Consumer<IposProvider>(
        builder: (context, provider, child) {
          return provider.isFetching
              ? Center(child: CircularProgressIndicator())
              : SmartRefresher(
                  enablePullDown: true,
                  header: WaterDropHeader(),
                  controller: _refreshController,
                  onRefresh: () => provider.fetchData(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(10),
                    controller: _scrollController,
                    itemCount: provider.items.length,
                    itemBuilder: (context, i) => IpoItem(
                      provider.items[i].ticker,
                      provider.items[i].company,
                      provider.items[i].date,
                      provider.items[i].volume,
                      provider.items[i].priceRange,
                      provider.items[i].shares,
                      5, // replace with average volume
                    ),
                  ),
                );
        },
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
