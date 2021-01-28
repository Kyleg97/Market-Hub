import 'package:MarketHub/models/stocktwits_model.dart';
import 'package:MarketHub/services/api.dart';
import 'package:flutter/material.dart';

class StocktwitsProvider with ChangeNotifier {
  StocktwitsProvider() {
    fetchData();
  }

  bool _isFetching = false;

  List<StocktwitsModel> _items = [];

  void addData(StocktwitsModel object) {
    _items.add(object);
    notifyListeners();
  }

  Future fetchData() async {
    _isFetching = true;
    notifyListeners();
    _items = await API.fetchStocktwits();
    _isFetching = false;
    notifyListeners();
  }

  void clearItems() {
    _items.clear();
  }

  bool get isFetching => _isFetching;
  List<StocktwitsModel> get getItems => [..._items];
  set setItems(List<StocktwitsModel> items) => _items = items;
}
