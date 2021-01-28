import 'package:MarketHub/models/earnings_model.dart';
import 'package:MarketHub/services/api.dart';
import 'package:flutter/material.dart';

class EarningsProvider with ChangeNotifier {
  EarningsProvider() {
    fetchData();
  }

  bool _isFetching = false;

  List<EarningsModel> _items = [];

  List<EarningsModel> get items {
    return [..._items];
  }

  void addData(EarningsModel object) {
    _items.add(object);
    notifyListeners();
  }

  Future<void> fetchData() async {
    _isFetching = true;
    notifyListeners();
    _items = await API.fetchEarnings();
    _isFetching = false;
    notifyListeners();
  }

  void clearItems() {
    _items.clear();
  }

  bool get isFetching => _isFetching;
}
