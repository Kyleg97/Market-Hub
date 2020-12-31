import 'package:MarketHub/models/earnings_model.dart';
import 'package:MarketHub/models/ipo_model.dart';
import 'package:MarketHub/models/reddit_model.dart';
import 'package:MarketHub/models/robinhood_model.dart';
import 'package:MarketHub/models/stocktwits_model.dart';
import 'package:firebase_database/firebase_database.dart';

class API {
  static Future fetchEarnings() async {
    final databaseReference =
        FirebaseDatabase.instance.reference().child("earnings-info");
    databaseReference.once().then((DataSnapshot snapshot) {
      var test = EarningsModel.parseData(snapshot.value);
      print(test);
      return test;
    });
  }

  static Future fetchRobinhood() async {
    final databaseReference =
        FirebaseDatabase.instance.reference().child("robinhood-popular");
    databaseReference.once().then((DataSnapshot snapshot) {
      var test = RobinhoodModel.parseData(snapshot.value);
      print(test);
      return test;
    });
  }

  static Future fetchReddit() async {
    final databaseReference =
        FirebaseDatabase.instance.reference().child("reddit-mentions");
    databaseReference.once().then((DataSnapshot snapshot) {
      var test = RedditModel.parseData(snapshot.value);
      print(test);
      return test;
    });
  }

  static Future fetchStocktwits() async {
    final databaseReference =
        FirebaseDatabase.instance.reference().child("stocktwits-trending");
    databaseReference.once().then((DataSnapshot snapshot) {
      var test = StocktwitsModel.parseData(snapshot.value);
      print(test);
      return test;
    });
  }

  static Future fetchIPOInfo() async {
    final databaseReference =
        FirebaseDatabase.instance.reference().child("ipo-info");
    databaseReference.once().then((DataSnapshot snapshot) {
      var test = IpoModel.parseData(snapshot.value);
      print(test);
      return test;
    });
  }
}
