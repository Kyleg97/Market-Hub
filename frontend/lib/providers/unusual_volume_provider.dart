import 'package:MarketHub/models/unusual_volume_model.dart';
import 'package:MarketHub/services/api.dart';
import 'package:flutter/material.dart';

class UnusualVolumeProvider with ChangeNotifier {
  UnusualVolumeProvider() {
    fetchData();
  }

  bool _isFetching = false;

  List<UnusualVolumeModel> _items = [];

  void addData(UnusualVolumeModel object) {
    _items.add(object);
    notifyListeners();
  }

  Future<void> fetchData() async {
    _isFetching = true;
    notifyListeners();
    _items = await API.fetchUnusualVolume();
    _isFetching = false;
    notifyListeners();
  }

  void clearItems() {
    _items.clear();
  }

  bool get isFetching => _isFetching;
  List<UnusualVolumeModel> get getItems => [..._items];
}
