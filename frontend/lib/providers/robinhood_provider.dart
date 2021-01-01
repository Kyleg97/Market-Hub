import 'package:MarketHub/models/robinhood_model.dart';
import 'package:MarketHub/services/api.dart';
import 'package:flutter/material.dart';

class RobinhoodProvider with ChangeNotifier {
  List<RobinhoodModel> _items = [];

  List<RobinhoodModel> get items {
    return [..._items];
  }

  void addStocktwitTrending(RobinhoodModel object) {
    _items.add(object);
    notifyListeners();
  }

  Future<void> fetchStocktwitsTrending() async {
    _items = await API.fetchRobinhood();
    notifyListeners();
  }

  void clearItems() {
    _items.clear();
  }
}
