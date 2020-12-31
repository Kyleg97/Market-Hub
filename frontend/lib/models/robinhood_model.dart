class RobinhoodModel {
  RobinhoodModel(
    this.company,
    this.marketCap,
    this.price,
    this.ticker,
    this.volume,
  );

  String company;
  String marketCap;
  String price;
  String ticker;
  int volume;

  static List<dynamic> parseData(List data) {
    return data
        .map(
          (entry) => RobinhoodModel(
            entry['company'].toString(),
            entry['market_cap'].toString(),
            entry['price'].toString(),
            entry['ticker'].toString(),
            int.parse(entry['volume'].toString()),
          ),
        )
        .toList();
  }
}
