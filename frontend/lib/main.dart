import 'package:MarketHub/pages/page_settings.dart';
import 'package:MarketHub/pages/page_unusual_volume.dart';
import 'package:MarketHub/providers/ipos_provider.dart';
import 'package:MarketHub/providers/stocktwits_provider.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'pages/page_earnings_ipo.dart';
import 'services/trading_apps.dart';
import 'pages/page_popular.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:MarketHub/pages/page_earnings_ipo.dart';
import './providers/earnings_provider.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => EarningsProvider()),
        ChangeNotifierProvider(create: (context) => IposProvider()),
        ChangeNotifierProvider(create: (context) => StocktwitsProvider()),
      ],
      child: MaterialApp(
        themeMode: ThemeMode.system,
        // light theme
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.white,
          accentColor: Colors.teal,
          selectedRowColor: Colors.white,
          //fontFamily: 'Montserrat',
          textTheme: TextTheme(
            headline1: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
              fontWeight: FontWeight.normal,
            ),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // dark theme
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.white,
          accentColor: Colors.teal,
          selectedRowColor: Colors.white,
          //fontFamily: 'Montserrat',
          textTheme: TextTheme(
            headline1: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
              fontWeight: FontWeight.normal,
            ),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> animation;
  CurvedAnimation curve;

  int _currentIndex = 0;
  final List<Widget> _pages = [
    PopularPage(),
    UnusualVolumePage(),
    // TestPage(),
    EarningsIPOPage(),
    //NewsPage(),
    SettingsPage(),
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    TradingApps.getApps();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      final systemTheme = SystemUiOverlayStyle.light.copyWith(
        systemNavigationBarColor: Theme.of(context).accentColor,
        //statusBarColor: Theme.of(context).accentColor,
        //systemNavigationBarIconBrightness: Brightness.light,
      );
      SystemChrome.setSystemUIOverlayStyle(systemTheme);
      await Firebase.initializeApp();
    });

    _animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    curve = CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.5,
        1.0,
        curve: Curves.fastOutSlowIn,
      ),
    );
    animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(curve);

    Future.delayed(
      Duration(seconds: 1),
      () => _animationController.forward(),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  List<BottomNavigationBarItem> bottomNavBarItems() {
    return [
      BottomNavigationBarItem(
        icon: Icon(Entypo.network), //Octicons.graph,
        title: Text('Popular'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.low_priority), //Icons.low_priority
        title: Text('Low Float'),
      ),
      BottomNavigationBarItem(
        icon: Icon(MaterialCommunityIcons.calendar),
        title: Text('Earnings'),
      ),
      BottomNavigationBarItem(
        icon: Icon(FontAwesome.newspaper_o), //Icons.new_releases
        title: Text('News'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.settings),
        title: Text('Settings'),
      )
    ];
  }

  List<IconData> bottomIconList() {
    return [
      Entypo.network,
      Icons.low_priority,
      MaterialCommunityIcons.calendar,
      FontAwesome.newspaper_o,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      /*bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: bottomNavBarItems(),
        type: BottomNavigationBarType.shifting,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
      ),*/
      floatingActionButton: ScaleTransition(
        scale: animation,
        child: FloatingActionButton(
          elevation: 8,
          backgroundColor: Theme.of(context).accentColor,
          child: Icon(
            Icons.compare_arrows,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () {
            // _animationController.reset();
            // _animationController.forward();
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: bottomIconList(),
        activeIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.softEdge,
        leftCornerRadius: 25,
        rightCornerRadius: 25,
        backgroundColor: Theme.of(context).accentColor,
        activeColor: Theme.of(context).primaryColor,
        splashColor: Theme.of(context).primaryColor,
        inactiveColor: Colors.white,
        notchAndCornersAnimation: animation,
        splashSpeedInMilliseconds: 300,
      ),
      body: _pages[_currentIndex],
    );
  }
}
