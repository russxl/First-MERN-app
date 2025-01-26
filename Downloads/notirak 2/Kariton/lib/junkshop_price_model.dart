// price_model.dart
import 'package:flutter/material.dart';

class PriceModel with ChangeNotifier {
  final Map<String, String> _prices = {};

  String getPrice(String category) {
    return _prices[category] ?? '₱0';
  }

  void updatePrice(String category, String price) {
    _prices[category] = price;
    notifyListeners();
  }
}
