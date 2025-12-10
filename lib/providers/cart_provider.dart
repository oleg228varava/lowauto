import 'package:flutter/material.dart';
import '../models/part.dart';

/// Запис одного замовлення
class OrderRecord {
  final List<Part> items;
  final double total; // Тепер total - double
  final DateTime date;

  OrderRecord({
    required this.items,
    required this.total,
    required this.date,
  });
}

/// Провайдер кошика
class CartProvider with ChangeNotifier {
  final List<Part> _cart = [];
  final List<OrderRecord> _orderHistory = [];

  // ===== Гетери =====
  List<Part> get items => List.unmodifiable(_cart); // список товарів у кошику
  List<OrderRecord> get orders => List.unmodifiable(_orderHistory); // історія замовлень
  double get totalPrice => _cart.fold(0.0, (sum, p) => sum + p.price);

  int get totalItems => _cart.length; // <- ось правильний геттер

  // ===== Додати товар у кошик =====
  void addToCart(Part part) {
    _cart.add(part);
    notifyListeners();
  }

  // ===== Видалити один екземпляр товару =====
  void removeOne(Part part) {
    final index = _cart.indexWhere((p) => p.id == part.id);
    if (index != -1) {
      _cart.removeAt(index);
      notifyListeners();
    }
  }

  // ===== Видалити всі екземпляри товару =====
  void removeFromCart(Part part) {
    _cart.removeWhere((p) => p.id == part.id);
    notifyListeners();
  }

  // ===== Очистити кошик =====
  void clear() {
    _cart.clear();
    notifyListeners();
  }

  // ===== Оформити замовлення =====
  void checkout() {
    if (_cart.isNotEmpty) {
      final total = totalPrice; // double
      final record = OrderRecord(
        items: List.from(_cart),
        total: total,
        date: DateTime.now(),
      );
      _orderHistory.insert(0, record); // додаємо замовлення на початок списку
      _cart.clear(); // очищаємо кошик
      notifyListeners();
    }
  }
}

