import 'package:MarketHub/models/reddit_model.dart';
import 'package:MarketHub/services/api.dart';
import 'package:flutter/material.dart';

class RedditProvider with ChangeNotifier {
  RedditProvider() {
    fetchData();
  }

  bool _isFetching = false;

  List<RedditModel> _items = [];

  /*List<RedditModel> get items {
    return [..._items];
  }*/

  void addData(RedditModel object) {
    _items.add(object);
    notifyListeners();
  }

  Future<void> fetchData() async {
    _isFetching = true;
    notifyListeners();
    _items = await API.fetchReddit();
    _isFetching = false;
    notifyListeners();
  }

  void clearItems() {
    _items.clear();
  }

  bool get isFetching => _isFetching;
  List<RedditModel> get getItems => [..._items];
}
