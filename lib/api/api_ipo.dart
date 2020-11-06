import 'dart:convert';
import 'package:http/http.dart' as http;

class IPO {
  static Future<List<UpcomingIpo>> fetchUpcomingIPO() async {
    final response =
        await http.get("https://kylelee.pythonanywhere.com/upcoming_ipo");

    final parser = parserFromJson(response.body.toString());

    List<UpcomingIpo> ipoList = new List();
    parser.upcomingIpo.forEach((earningsInfo) {
      ipoList.add(earningsInfo);
    });
    //print(parser.earningsInfo);
    return ipoList;
  }
}

Parser parserFromJson(String str) => Parser.fromJson(json.decode(str));

String parserToJson(Parser data) => json.encode(data.toJson());

class Parser {
  Parser({
    this.upcomingIpo,
  });

  List<UpcomingIpo> upcomingIpo;

  factory Parser.fromJson(Map<String, dynamic> json) => Parser(
        upcomingIpo: List<UpcomingIpo>.from(
            json["UpcomingIPO"].map((x) => UpcomingIpo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "UpcomingIPO": List<dynamic>.from(upcomingIpo.map((x) => x.toJson())),
      };
}

class UpcomingIpo {
  UpcomingIpo({
    this.companyName,
    this.date,
    this.priceRange,
    this.sharesNum,
    this.tickerName,
    this.volume,
  });

  String companyName;
  String date;
  String priceRange;
  String sharesNum;
  String tickerName;
  String volume;

  factory UpcomingIpo.fromJson(Map<String, dynamic> json) => UpcomingIpo(
        companyName: json["company_name"],
        date: json["date"],
        priceRange: json["price_range"],
        sharesNum: json["shares_num"],
        tickerName: json["ticker_name"],
        volume: json["volume"],
      );

  Map<String, dynamic> toJson() => {
        "company_name": companyName,
        "date": date,
        "price_range": priceRange,
        "shares_num": sharesNum,
        "ticker_name": tickerName,
        "volume": volume,
      };
}
