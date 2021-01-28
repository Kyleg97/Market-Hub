class UnusualVolumeModel {
  UnusualVolumeModel(
    this.ticker,
    this.company,
    this.meanVolume,
    this.standardVolume,
    this.outlierVolume,
    this.outlierChange,
  );

  String ticker;
  String company;
  int meanVolume;
  int standardVolume;
  Map<dynamic, dynamic> outlierVolume;
  Map<dynamic, dynamic> outlierChange;

  static List<dynamic> parseData(List data) {
    return data
        .map(
          (entry) => UnusualVolumeModel(
              entry['ticker'].toString(),
              entry['company'].toString(),
              int.parse(entry['meanvolume'].toString()),
              int.parse(entry['standardvolume'].toString()),
              entry['outliervolume'],
              entry['outlierchange']),
        )
        .toList();
  }
}
