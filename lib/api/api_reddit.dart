import 'dart:convert';
import 'package:http/http.dart' as http;

class RedditTrending {
  static Future<List<CommonTicker>> fetchRedditTrending() async {
    final response =
        await http.get("https://kylelee.pythonanywhere.com/common_tickers");

    final parser = parserFromJson(response.body.toString());
    List<CommonTicker> commonTickersList = new List();
    parser.commonTickers.forEach((element) {
      commonTickersList.add(element);
    });
    return commonTickersList;
  }
}

Parser parserFromJson(String str) => Parser.fromJson(json.decode(str));

String parserToJson(Parser data) => json.encode(data.toJson());

class Parser {
  Parser({
    this.commonTickers,
  });

  List<CommonTicker> commonTickers;

  factory Parser.fromJson(Map<String, dynamic> json) => Parser(
        commonTickers: List<CommonTicker>.from(
            json["CommonTickers"].map((x) => CommonTicker.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "CommonTickers":
            List<dynamic>.from(commonTickers.map((x) => x.toJson())),
      };
}

class CommonTicker {
  CommonTicker({
    this.companyName,
    this.investing,
    this.options,
    this.pennystocks,
    this.smallstreetbets,
    this.stocks,
    this.thewallstreet,
    this.tickerName,
    this.totalMentionCount,
    this.wallstreetbets,
  });

  String companyName;
  int investing;
  int options;
  int pennystocks;
  int smallstreetbets;
  int stocks;
  int thewallstreet;
  String tickerName;
  int totalMentionCount;
  int wallstreetbets;

  factory CommonTicker.fromJson(Map<String, dynamic> json) => CommonTicker(
        companyName: json["company_name"],
        investing: json["investing"],
        options: json["options"],
        pennystocks: json["pennystocks"],
        smallstreetbets: json["smallstreetbets"],
        stocks: json["stocks"],
        thewallstreet: json["thewallstreet"],
        tickerName: json["ticker_name"],
        totalMentionCount: json["total_mention_count"],
        wallstreetbets: json["wallstreetbets"],
      );

  Map<String, dynamic> toJson() => {
        "company_name": companyName,
        "investing": investing,
        "options": options,
        "pennystocks": pennystocks,
        "smallstreetbets": smallstreetbets,
        "stocks": stocks,
        "thewallstreet": thewallstreet,
        "ticker_name": tickerName,
        "total_mention_count": totalMentionCount,
        "wallstreetbets": wallstreetbets,
      };
}
