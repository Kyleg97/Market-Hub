import 'package:MarketHub/models/robinhood_model.dart';
import 'package:MarketHub/services/api.dart';
import 'package:flutter/material.dart';

class RobinhoodProvider with ChangeNotifier {
  RobinhoodProvider() {
    fetchData();
  }

  bool _isFetching = false;

  List<RobinhoodModel> _items = [];

  /*List<RobinhoodModel> get items {
    return [..._items];
  }*/

  void addData(RobinhoodModel object) {
    _items.add(object);
    notifyListeners();
  }

  Future<void> fetchData() async {
    _isFetching = true;
    notifyListeners();
    _items = await API.fetchRobinhood();
    _isFetching = false;
    notifyListeners();
  }

  void clearItems() {
    _items.clear();
  }

  bool get isFetching => _isFetching;
  List<RobinhoodModel> get getItems => [..._items];
}
