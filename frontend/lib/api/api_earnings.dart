import 'dart:convert';
import 'package:http/http.dart' as http;

class Earnings {
  static Future<List<EarningsInfo>> fetchEarnings() async {
    print("called");
    final response =
        await http.get("https://kylelee.pythonanywhere.com/earnings_info");

    final parser = parserFromJson(response.body.toString());

    List<EarningsInfo> earningsList = new List();
    parser.earningsInfo.forEach((earningsInfo) {
      earningsList.add(earningsInfo);
    });
    //print(parser.earningsInfo);
    return earningsList;
  }
}

Parser parserFromJson(String str) => Parser.fromJson(json.decode(str));

String parserToJson(Parser data) => json.encode(data.toJson());

class Parser {
  Parser({
    this.earningsInfo,
  });

  List<EarningsInfo> earningsInfo;

  factory Parser.fromJson(Map<String, dynamic> json) => Parser(
        earningsInfo: List<EarningsInfo>.from(
            json["EarningsInfo"].map((x) => EarningsInfo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "EarningsInfo": List<dynamic>.from(earningsInfo.map((x) => x.toJson())),
      };
}

class EarningsInfo {
  EarningsInfo({
    this.companyName,
    this.currentVolume,
    this.earningsDatetime,
    this.epsEstimate,
    this.tickerName,
  });

  String companyName;
  int currentVolume;
  DateTime earningsDatetime;
  double epsEstimate;
  String tickerName;

  factory EarningsInfo.fromJson(Map<String, dynamic> json) => EarningsInfo(
        companyName: json["company_name"],
        currentVolume: json["current_volume"],
        earningsDatetime: DateTime.parse(json["earnings_datetime"]),
        epsEstimate: json["eps_estimate"].toDouble(),
        tickerName: json["ticker_name"],
      );

  Map<String, dynamic> toJson() => {
        "company_name": companyName,
        "current_volume": currentVolume,
        "earnings_datetime": earningsDatetime.toIso8601String(),
        "eps_estimate": epsEstimate,
        "ticker_name": tickerName,
      };
}
