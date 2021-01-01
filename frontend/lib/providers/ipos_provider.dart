import 'package:MarketHub/models/ipo_model.dart';
import 'package:MarketHub/services/api.dart';
import 'package:flutter/material.dart';

class IposProvider with ChangeNotifier {
  List<IpoModel> _items = [];

  List<IpoModel> get items {
    return [..._items];
  }

  void addIpo(IpoModel object) {
    _items.add(object);
    notifyListeners();
  }

  Future<void> fetchIpos() async {
    _items = await API.fetchIPOInfo();
    print(_items);
    notifyListeners();
  }

  void clearItems() {
    _items.clear();
  }
}
