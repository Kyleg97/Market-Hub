class RedditModel {
  RedditModel(
    this.ticker,
    this.count,
  );

  String ticker;
  int count;

  static List<dynamic> parseData(List data) {
    return data
        .map(
          (entry) => RedditModel(entry['ticker'].toString(), entry['count']),
        )
        .toList();
  }
}
