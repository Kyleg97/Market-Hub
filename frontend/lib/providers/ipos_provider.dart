import 'package:MarketHub/models/ipo_model.dart';
import 'package:MarketHub/services/api.dart';
import 'package:flutter/material.dart';

class IposProvider with ChangeNotifier {
  IposProvider() {
    fetchData();
  }

  bool _isFetching = false;

  List<IpoModel> _items = [];

  List<IpoModel> get items {
    return [..._items];
  }

  void addData(IpoModel object) {
    _items.add(object);
    notifyListeners();
  }

  Future<void> fetchData() async {
    _isFetching = true;
    notifyListeners();
    _items = await API.fetchIPOInfo();
    _isFetching = false;
    notifyListeners();
  }

  void clearItems() {
    _items.clear();
  }

  bool get isFetching => _isFetching;
}
