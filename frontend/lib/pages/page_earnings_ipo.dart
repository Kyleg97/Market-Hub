import 'package:MarketHub/api/api_ipo.dart';
import 'package:MarketHub/providers/earnings_provider.dart';
import 'package:MarketHub/providers/ipos_provider.dart';
import 'package:MarketHub/widgets/earning_card.dart';
import 'package:MarketHub/widgets/ipo_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:MarketHub/api/api_earnings.dart';
import '../providers/earnings_provider.dart';

class EarningsIPOPage extends StatefulWidget {
  EarningsIPOPage({Key key}) : super(key: key);
  @override
  EarningsIPOPageState createState() => EarningsIPOPageState();
}

class EarningsIPOPageState extends State<EarningsIPOPage> {
  TextStyle textStyle = TextStyle(fontSize: 18, fontFamily: 'Montserrat');
  List<EarningsInfo> earnings;
  List<UpcomingIpo> ipos;

  bool _isInit = true;
  bool _isLoadingEarnings = false;
  bool _isLoadingIpos = false;

  ScrollController _scrollController = new ScrollController();

  int _currentView = 0; // 0 == Earnings, 1 == IPO

  int averageVolume = 0;
  DateTime currentDate;

  /*CustomDropDownItem _currentDropdownValue;
  List<CustomDropDownItem> _customDropdownItems = [
    CustomDropDownItem(Icon(Icons.arrow_upward), "Volume", 1),
    CustomDropDownItem(Icon(Icons.arrow_upward), "Date", 1),
    CustomDropDownItem(Icon(Icons.arrow_upward), "EPS Estimate", 1),
    CustomDropDownItem(Icon(Icons.arrow_downward), "Volume", -1),
    CustomDropDownItem(Icon(Icons.arrow_downward), "Date", -1),
    CustomDropDownItem(Icon(Icons.arrow_downward), "EPS Estimate", -1),
  ];*/

  @override
  void initState() {
    super.initState();
    // callEarnings();
    // Provider.of<EarningsProvider>(context).fetchEarningsInfo();
    // callUpcomingIPO();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoadingEarnings = true;
        _isLoadingIpos = true;
      });
      Provider.of<EarningsProvider>(context).fetchEarningsInfo().then((_) {
        setState(() {
          _isLoadingEarnings = false;
        });
      });
      Provider.of<IposProvider>(context).fetchIpos().then((_) {
        setState(() {
          _isLoadingIpos = false;
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

  /*callEarnings() async {
    earnings = await Earnings.fetchEarnings();
    averageVolume = calculateAverageVolume();
    print("Average Volume: " + averageVolume.toString());
    setState(() {});
  }*/

  /*callUpcomingIPO() async {
    ipos = await IPO.fetchUpcomingIPO();
    setState(() {});
  }*/ /////

  Future<void> _refreshEarnings(BuildContext context) async {
    await Provider.of<EarningsProvider>(context, listen: false)
        .fetchEarningsInfo();
  }

  Future<void> _refreshIpos(BuildContext context) async {
    await Provider.of<IposProvider>(context, listen: false).fetchIpos();
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
            ? _isLoadingEarnings
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => _refreshEarnings(context),
                    child: EarningsListviewBuilder(
                      scrollController: _scrollController,
                      averageVolume: averageVolume,
                    ),
                  )
            : _isLoadingIpos
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => _refreshIpos(context),
                    child: IpoListViewBuilder(
                        scrollController: _scrollController,
                        averageVolume: averageVolume),
                  ),
      ),
    );
  }
}

class IpoListViewBuilder extends StatelessWidget {
  const IpoListViewBuilder({
    Key key,
    @required ScrollController scrollController,
    @required this.averageVolume,
  })  : _scrollController = scrollController,
        super(key: key);

  final ScrollController _scrollController;
  final int averageVolume;

  @override
  Widget build(BuildContext context) {
    final iposData = Provider.of<IposProvider>(context);
    final ipos = iposData.items;
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      controller: _scrollController,
      itemCount: ipos.length,
      itemBuilder: (context, i) => Container(),
      /*itemBuilder: (context, i) => IpoItem(
        ipos[i].tickerName,
        ipos[i].companyName,
        ipos[i].date,
        ipos[i].volume,
        ipos[i].priceRange,
        ipos[i].sharesNum,
        averageVolume,
      ),*/
    );
  }
}

class EarningsListviewBuilder extends StatelessWidget {
  const EarningsListviewBuilder({
    Key key,
    @required ScrollController scrollController,
    @required this.averageVolume,
  })  : _scrollController = scrollController,
        super(key: key);

  final ScrollController _scrollController;
  final int averageVolume;

  @override
  Widget build(BuildContext context) {
    final earningsData = Provider.of<EarningsProvider>(context);
    final earnings = earningsData.items;
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      controller: _scrollController,
      itemCount: earnings.length,
      itemBuilder: (context, i) =>
          /*EarningItem(
        earnings[i].tickerName,
        earnings[i].companyName,
        earnings[i].currentVolume,
        earnings[i].epsEstimate,
        earnings[i].earningsDatetime,
        averageVolume,
      ),*/
          Container(),
    );
  }
}

class CustomDropDownItem {
  Icon icon;
  String word;
  int function;
  CustomDropDownItem(this.icon, this.word, this.function);
}
