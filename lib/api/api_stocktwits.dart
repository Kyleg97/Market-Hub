import 'dart:convert';
import 'package:http/http.dart' as http;

class StocktwitsTrending {
  String symbol;
  String name;
  int watchlistCount;

  StocktwitsTrending(this.symbol, this.name, this.watchlistCount);

  static Future<List<StocktwitsTrending>> fetchStocktwitsTrending() async {
    final response = await http
        .get('https://api.stocktwits.com/api/2/trending/symbols.json');

    final parser = parserFromJson(response.body.toString());
    List<StocktwitsTrending> trending = new List();
    parser.symbols.forEach((element) {
      trending.add(new StocktwitsTrending(
          element.symbol, element.title, element.watchlistCount));
    });
    trending.sort((b, a) => a.watchlistCount.compareTo(b.watchlistCount));
    return trending;
  }
}

Parser parserFromJson(String str) => Parser.fromJson(json.decode(str));

String parserToJson(Parser data) => json.encode(data.toJson());

class Parser {
  Parser({
    this.response,
    this.symbols,
  });

  Response response;
  List<Symbol> symbols;

  factory Parser.fromJson(Map<String, dynamic> json) => Parser(
        response: Response.fromJson(json["response"]),
        symbols:
            List<Symbol>.from(json["symbols"].map((x) => Symbol.fromJson(x))),
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

class Symbol {
  Symbol({
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

  factory Symbol.fromJson(Map<String, dynamic> json) => Symbol(
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
