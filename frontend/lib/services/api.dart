import 'package:MarketHub/models/earnings_model.dart';
import 'package:MarketHub/models/ipo_model.dart';
import 'package:MarketHub/models/reddit_model.dart';
import 'package:MarketHub/models/robinhood_model.dart';
import 'package:MarketHub/models/stocktwits_model.dart';
import 'package:MarketHub/models/unusual_volume_model.dart';
import 'package:firebase_database/firebase_database.dart';

class API {
  static Future fetchEarnings() async {
    var response = await FirebaseDatabase.instance
        .reference()
        .child("earnings-info")
        .once();
    return EarningsModel.parseData(response.value);
  }

  static Future fetchRobinhood() async {
    var response = await FirebaseDatabase.instance
        .reference()
        .child("robinhood-popular")
        .once();
    return RobinhoodModel.parseData(response.value);
  }

  static Future fetchReddit() async {
    var response = await FirebaseDatabase.instance
        .reference()
        .child("reddit-mentions")
        .once();
    return RedditModel.parseData(response.value);
  }

  static Future fetchStocktwits() async {
    var response = await FirebaseDatabase.instance
        .reference()
        .child("stocktwits-trending")
        .once();
    return StocktwitsModel.parseData(response.value);
  }

  static Future fetchIPOInfo() async {
    var response =
        await FirebaseDatabase.instance.reference().child("ipo-info").once();
    return IpoModel.parseData(response.value);
  }

  static Future fetchUnusualVolume() async {
    var response = await FirebaseDatabase.instance
        .reference()
        .child("unusual-volume")
        .once();
    return UnusualVolumeModel.parseData(response.value);
  }
}
