import 'package:MarketHub/pages/page_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'pages/page_earnings.dart';
import 'pages/page_news.dart';
import 'trading_apps.dart';
import 'pages/page_popular.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:MarketHub/pages/page_earnings.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = await HydratedBlocDelegate.build();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      // light theme
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.teal,
        accentColor: Colors.teal,
        selectedRowColor: Colors.white,
        fontFamily: 'Montserrat',
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
        primarySwatch: Colors.teal,
        accentColor: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    PopularPage(), // popular
    Center(child: Text("Low Float")),
    EarningsPage(),
    NewsPage(),
    SettingsPage(),
  ];

  @override
  void initState() {
    super.initState();
    TradingApps.getApps();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: bottomNavBarItems(),
        type: BottomNavigationBarType.shifting,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
      ),
      body: _pages[_currentIndex],
    );
  }
}
