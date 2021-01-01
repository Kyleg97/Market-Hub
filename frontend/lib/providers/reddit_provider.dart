import 'package:MarketHub/services/api.dart';
import 'package:flutter/material.dart';

class RedditProvider with ChangeNotifier {
  List<RedditProvider> _items = [];

  List<RedditProvider> get items {
    return [..._items];
  }

  void addStocktwitTrending(RedditProvider object) {
    _items.add(object);
    notifyListeners();
  }

  Future<void> fetchStocktwitsTrending() async {
    _items = await API.fetchReddit();
    notifyListeners();
  }

  void clearItems() {
    _items.clear();
  }
}
