import 'package:MarketHub/models/earnings_model.dart';
import 'package:flutter/material.dart';

class EarningsProvider with ChangeNotifier {
  List<EarningsModel> _items = [];

  List<EarningsModel> get items {
    return [..._items];
  }

  void addEarningsInfo(EarningsModel object) {
    _items.add(object);
    notifyListeners();
  }

  Future<void> fetchEarningsInfo() async {
    _items = await EarningsModel.fetchEarnings();
    print(_items);
    notifyListeners();
  }

  void clearItems() {
    _items.clear();
  }
}
