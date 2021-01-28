class RedditModel {
  RedditModel(
    this.ticker,
    this.company,
    this.count,
  );

  String ticker;
  String company;
  int count;

  static List<dynamic> parseData(List data) {
    return data
        .map(
          (entry) => RedditModel(
            entry['ticker'].toString(),
            entry['company'],
            entry['count'],
          ),
        )
        .toList();
  }
}
