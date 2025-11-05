import 'package:flutter/material.dart';
import '../models/part.dart';

class OrderRecord {
  final List<Part> items;
  final int total;
  final DateTime date;

  OrderRecord({
    required this.items,
    required this.total,
    required this.date,
  });
}

class CartProvider with ChangeNotifier {
  final List<Part> _cart = [];
  final List<OrderRecord> _orderHistory = [];

  List<Part> get items => _cart;
  List<OrderRecord> get orders => _orderHistory;

  int get totalPrice => _cart.fold(0, (sum, p) => sum + p.price);

  void addToCart(Part part) {
    _cart.add(part);
    notifyListeners();
  }

  void removeFromCart(Part part) {
    _cart.remove(part);
    notifyListeners();
  }

  void clear() {
    _cart.clear();
    notifyListeners();
  }

  void checkout() {
    if (_cart.isNotEmpty) {
      final total = totalPrice;
      final record = OrderRecord(
        items: List.from(_cart),
        total: total,
        date: DateTime.now(),
      );
      _orderHistory.insert(0, record);
      _cart.clear();
      notifyListeners();
    }
  }
}
