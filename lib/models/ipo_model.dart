import 'dart:convert';
import 'package:http/http.dart' as http;

Parser parserFromJson(String str) => Parser.fromJson(json.decode(str));

String parserToJson(Parser data) => json.encode(data.toJson());

class Parser {
  Parser({
    this.upcomingIpo,
  });

  List<IpoModel> upcomingIpo;

  factory Parser.fromJson(Map<String, dynamic> json) => Parser(
        upcomingIpo: List<IpoModel>.from(
            json["UpcomingIPO"].map((x) => IpoModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "UpcomingIPO": List<dynamic>.from(upcomingIpo.map((x) => x.toJson())),
      };
}

class IpoModel {
  IpoModel({
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

  static Future<List<IpoModel>> fetchUpcomingIPO() async {
    final response =
        await http.get("https://kylelee.pythonanywhere.com/upcoming_ipo");

    final parser = parserFromJson(response.body.toString());

    List<IpoModel> ipoList = new List();
    parser.upcomingIpo.forEach((earningsInfo) {
      ipoList.add(earningsInfo);
    });
    return ipoList;
  }

  factory IpoModel.fromJson(Map<String, dynamic> json) => IpoModel(
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
