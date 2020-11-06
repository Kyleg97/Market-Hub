import 'dart:convert';
import 'package:http/http.dart' as http;

Parser parserFromJson(String str) => Parser.fromJson(json.decode(str));

String parserToJson(Parser data) => json.encode(data.toJson());

class Parser {
  Parser({
    this.response,
    this.symbols,
  });

  Response response;
  List<StocktwitsModel> symbols;

  factory Parser.fromJson(Map<String, dynamic> json) => Parser(
        response: Response.fromJson(json["response"]),
        symbols: List<StocktwitsModel>.from(
            json["symbols"].map((x) => StocktwitsModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "response": response.toJson(),
        "symbols": List<dynamic>.from(symbols.map((x) => x.toJson())),
      };
}

class Response {
  Response({
    this.status,
  });

  int status;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
      };
}

class StocktwitsModel {
  StocktwitsModel({
    this.id,
    this.symbol,
    this.title,
    this.aliases,
    this.isFollowing,
    this.watchlistCount,
  });

  int id;
  String symbol;
  String title;
  List<String> aliases;
  bool isFollowing;
  int watchlistCount;

  static Future<List<StocktwitsModel>> fetchStocktwitsTrending() async {
    final response = await http
        .get('https://api.stocktwits.com/api/2/trending/symbols.json');

    final parser = parserFromJson(response.body.toString());
    List<StocktwitsModel> trending = new List();
    parser.symbols.forEach((element) {
      trending.add(
        StocktwitsModel(
          id: element.id,
          symbol: element.symbol,
          title: element.title,
          aliases: element.aliases,
          isFollowing: element.isFollowing,
          watchlistCount: element.watchlistCount,
        ),
      );
    });
    trending.sort((b, a) => a.watchlistCount.compareTo(b.watchlistCount));
    return trending;
  }

  factory StocktwitsModel.fromJson(Map<String, dynamic> json) =>
      StocktwitsModel(
        id: json["id"],
        symbol: json["symbol"],
        title: json["title"],
        aliases: List<String>.from(json["aliases"].map((x) => x)),
        isFollowing: json["is_following"],
        watchlistCount: json["watchlist_count"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "symbol": symbol,
        "title": title,
        "aliases": List<dynamic>.from(aliases.map((x) => x)),
        "is_following": isFollowing,
        "watchlist_count": watchlistCount,
      };
}
