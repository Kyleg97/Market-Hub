class IpoModel {
  IpoModel(
    this.company,
    this.date,
    this.priceRange,
    this.shares,
    this.ticker,
    this.volume,
  );

  String company;
  String date;
  String priceRange;
  String shares;
  String ticker;
  String volume;

  static List<dynamic> parseData(List data) {
    return data
        .map(
          (entry) => IpoModel(
            entry['company'].toString(),
            entry['date'].toString(),
            entry['priceRange'].toString(),
            entry['shares'].toString(),
            entry['ticker'].toString(),
            entry['volume'].toString(),
          ),
        )
        .toList();
  }
}
