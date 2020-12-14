import 'package:MarketHub/models/ipo_model.dart';
import 'package:MarketHub/models/stocktwits_model.dart';
import 'package:flutter/material.dart';

class StocktwitsProvider with ChangeNotifier {
  List<StocktwitsModel> _items = [];

  List<StocktwitsModel> get items {
    return [..._items];
  }

  void addStocktwitTrending(StocktwitsModel object) {
    _items.add(object);
    notifyListeners();
  }

  Future<void> fetchStocktwitsTrending() async {
    _items = await StocktwitsModel.fetchStocktwitsTrending();
    notifyListeners();
  }

  void clearItems() {
    _items.clear();
  }
}
