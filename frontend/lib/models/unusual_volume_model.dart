import 'package:intl/intl.dart';

class UnusualVolumeModel {
  UnusualVolumeModel(
    this.company,
    this.date,
    this.ticker,
    this.volume,
  );

  String company;
  String date;
  String ticker;
  int volume;

  static List<dynamic> parseData(List data) {
    return data
        .map(
          (entry) => UnusualVolumeModel(
            entry['company'].toString(),
            entry['date'].toString(),
            entry['ticker'].toString(),
            int.parse(entry['volume'].toString().replaceAll(",", "")),
          ),
        )
        .toList();
  }
}
