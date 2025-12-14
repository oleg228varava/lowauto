// utils/currency_service.dart
import 'dart:convert';

import 'package:http/http.dart' as http;

class CurrencyService {
  static Map<String, double> _rates = {'UAH': 1.0};

  static Future<void> fetchRates() async {
    try {
      final url = Uri.parse('https://api.privatbank.ua/p24api/pubinfo?json&exchange&coursid=5');
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as List<dynamic>;
        _rates = {'UAH': 1.0};
        for (var item in data) {
          final ccy = item['ccy'] as String;
          final sale = double.tryParse(item['sale'] ?? '');
          if (sale != null) _rates[ccy] = sale;
        }
      }
    } catch (_) {
      _rates = {'UAH': 1.0};
    }
  }

  static Future<double> convertAsync(double amount, String from, String to) async {
    if (_rates.length == 1) {
      await fetchRates(); // якщо курси ще не підвантажені
    }
    final fromRate = _rates[from] ?? 1.0;
    final toRate = _rates[to] ?? 1.0;
    return amount / fromRate * toRate;
  }
}
