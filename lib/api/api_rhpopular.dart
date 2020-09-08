import 'dart:convert';
import 'package:http/http.dart' as http;

class RobinhoodTrending {
  static Future<List<RhPopular>> fetchRobinhoodTrending() async {
    final response =
        await http.get("http://kylelee.pythonanywhere.com/robinhood_popular");

    final parser = parserFromJson(response.body.toString());
    List<RhPopular> popularList = new List();
    parser.rhPopular.forEach((element) {
      popularList.add(element);
    });
    return popularList;
  }
}

Parser parserFromJson(String str) => Parser.fromJson(json.decode(str));

String parserToJson(Parser data) => json.encode(data.toJson());

class Parser {
  Parser({
    this.rhPopular,
  });

  List<RhPopular> rhPopular;

  factory Parser.fromJson(Map<String, dynamic> json) => Parser(
        rhPopular: List<RhPopular>.from(
            json["RHPopular"].map((x) => RhPopular.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "RHPopular": List<dynamic>.from(rhPopular.map((x) => x.toJson())),
      };
}

class RhPopular {
  RhPopular({
    this.companyName,
    this.currentPrice,
    this.currentVolume,
    this.marketCap,
    this.tickerName,
  });

  String companyName;
  String currentPrice;
  int currentVolume;
  String marketCap;
  String tickerName;

  factory RhPopular.fromJson(Map<String, dynamic> json) => RhPopular(
        companyName: json["company_name"],
        currentPrice: json["current_price"],
        currentVolume: json["current_volume"],
        marketCap: json["market_cap"],
        tickerName: json["ticker_name"],
      );

  Map<String, dynamic> toJson() => {
        "company_name": companyName,
        "current_price": currentPrice,
        "current_volume": currentVolume,
        "market_cap": marketCap,
        "ticker_name": tickerName,
      };
}
