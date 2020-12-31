import 'package:MarketHub/models/ipo_model.dart';
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
    //_items = await IpoModel.fetchUpcomingIPO();
    print(_items);
    notifyListeners();
  }

  void clearItems() {
    _items.clear();
  }
}
