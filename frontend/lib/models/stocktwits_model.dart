class StocktwitsModel {
  StocktwitsModel(
    this.id,
    this.isFollowing,
    this.symbol,
    this.title,
    this.watchlistCount,
  );

  String id;
  bool isFollowing;
  String symbol;
  String title;
  int watchlistCount;

  static List<dynamic> parseData(List data) {
    return data
        .map(
          (entry) => StocktwitsModel(
            entry['id'].toString(),
            entry['isFollowing'],
            entry['symbol'].toString(),
            entry['title'].toString(),
            int.parse(entry['watchlist_count'].toString()),
          ),
        )
        .toList();
  }
}
