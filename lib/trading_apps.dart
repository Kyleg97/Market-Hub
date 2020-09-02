import 'dart:async';
import 'dart:io';
import 'package:flutter_appavailability/flutter_appavailability.dart';
import 'package:url_launcher/url_launcher.dart';

class TradingApps {
  static List<Map<String, String>> installedApps;
  static List<String> tradingApps = [
    "Robinhood",
  ];

  static Future<void> getApps() async {
    List<Map<String, String>> _installedApps;

    if (Platform.isAndroid) {
      _installedApps = await AppAvailability.getInstalledApps();
    }
    installedApps = _installedApps;
  }

  static void launchURL(String ticker) async {
    String url;
    installedApps.forEach((element) async {
      String name = element["app_name"];
      if (name == "Robinhood") {
        url = "https://robinhood.com/stocks/$ticker";
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw "Could not launch $url";
        }
      }
    });
  }
}
