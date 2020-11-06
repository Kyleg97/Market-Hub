import 'dart:convert';
import 'package:http/http.dart' as http;

Parser parserFromJson(String str) => Parser.fromJson(json.decode(str));

String parserToJson(Parser data) => json.encode(data.toJson());

class Parser {
  Parser({
    this.earningsInfo,
  });

  List<EarningsModel> earningsInfo;

  factory Parser.fromJson(Map<String, dynamic> json) => Parser(
        earningsInfo: List<EarningsModel>.from(
            json["EarningsInfo"].map((x) => EarningsModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "EarningsInfo": List<dynamic>.from(earningsInfo.map((x) => x.toJson())),
      };
}

class EarningsModel {
  EarningsModel({
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

  static Future<List<EarningsModel>> fetchEarnings() async {
    final response =
        await http.get("https://kylelee.pythonanywhere.com/earnings_info");

    final parser = parserFromJson(response.body.toString());

    List<EarningsModel> earningsList = new List();
    parser.earningsInfo.forEach((earningsInfo) {
      earningsList.add(earningsInfo);
    });
    return earningsList;
  }

  factory EarningsModel.fromJson(Map<String, dynamic> json) => EarningsModel(
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
