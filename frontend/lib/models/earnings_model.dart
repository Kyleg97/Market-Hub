class EarningsModel {
  EarningsModel(
    this.company,
    this.startdatetime,
    this.startdatetimetype,
    this.epsEstimate,
    this.ticker,
    this.timezone,
  );

  String company;
  String startdatetime;
  String startdatetimetype;
  String epsEstimate;
  String ticker;
  String timezone;

  static List<dynamic> parseData(List data) {
    return data
        .map(
          (entry) => EarningsModel(
            entry['company'].toString(),
            entry['startdatetime'].toString(),
            entry['startdatetimetype'].toString(),
            entry['epsestimate'].toString(),
            entry['ticker'].toString(),
            entry['timezone'].toString(),
          ),
        )
        .toList();
  }
}
