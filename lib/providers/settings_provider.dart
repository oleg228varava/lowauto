import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  // ---------------- Theme ----------------
  bool isDarkTheme = false;
  void toggleTheme(bool v) {
    isDarkTheme = v;
    notifyListeners();
  }

  // ---------------- Notifications ----------------
  bool notificationsEnabled = true;
  bool emailNotifications = true;
  bool smsNotifications = true;
  bool soundsEnabled = true;
  bool vibrationEnabled = true;
  bool promoNotifications = true;

  void toggleNotifications(bool v) { notificationsEnabled = v; notifyListeners(); }
  void toggleEmailNotifications(bool v) { emailNotifications = v; notifyListeners(); }
  void toggleSmsNotifications(bool v) { smsNotifications = v; notifyListeners(); }
  void toggleSounds(bool v) { soundsEnabled = v; notifyListeners(); }
  void toggleVibration(bool v) { vibrationEnabled = v; notifyListeners(); }
  void togglePromoNotifications(bool v) { promoNotifications = v; notifyListeners(); }

  // ---------------- Locale / Language ----------------
  String language = "uk";
  Locale _locale = const Locale('uk');
  Locale get locale => _locale;
  void setLocale(Locale newLocale) {
    _locale = newLocale;
    notifyListeners();
  }

  // ---------------- Currency ----------------
  String _currency = "UAH";
  String get currency => _currency;

  // ---------------- Order history limit ----------------
  int _orderHistoryLimit = 50;
  int get orderHistoryLimit => _orderHistoryLimit;
  void setOrderHistoryLimit(int limit) { _orderHistoryLimit = limit; notifyListeners(); }

  // ---------------- Google Translator ----------------
  final GoogleTranslator _translator = GoogleTranslator();
  Map<String, String> translated = {};

  // Усі тексти, які треба перекладати
 final List<String> allTexts = [
    "Налаштування",
    "Редагувати профіль",
    "Темна тема",
    "Оповіщення",
    "Звуки",
    "Вібрація",
    "Email-сповіщення",
    "SMS-сповіщення",
    "Промо-сповіщення",
    "Мова",
    "Українська",
    "English",
    "Ліміт історії замовлень",
    "Звязатись з фахівцем", // замінено апостроф на 'безпечний'
    "Про застосунок",
    "Вийти з акаунту",
    "Змінити ім'я",
    "Змінити Email",
    "Змінити пароль",
    "Новий пароль",
    "Пароль успішно змінено",
    "Зберегти",
    "Відміна",
    "Закрити",
    "Додати / редагувати машину",
    "Марка",
    "Модель",
    "Рік",
    "Пробіг",
    "Історія замовлень",
    "Поки що немає замовлень.",
    "Замовлення",
    "Замовлення #",
    "Тема додатку"
  ];

  Future<void> _saveCache() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("translate_$language", jsonEncode(translated));
  }

  Future<Map<String,String>?> _loadCache() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString("translate_$language");
    if (data == null) return null;
    return Map<String,String>.from(jsonDecode(data));
  }

  /// Міняє мову і автоматично перекладає тексти
  Future<void> changeLanguage(String lang) async {
    language = lang;
    _locale = Locale(lang);

    // Для української очищаємо переклади
    if (lang == "uk") {
      translated.clear();
      notifyListeners();
      return;
    }

    // Спробуємо завантажити з кешу
    final cached = await _loadCache();
    if (cached != null) {
      translated = cached;
      notifyListeners();
      return;
    }

    // Асинхронно перекладаємо тексти
    Map<String, String> temp = {};
    for (String text in allTexts) {
      try {
        final tr = await _translator.translate(text, to: lang);
        temp[text] = tr.text;
      } catch (_) {
        temp[text] = text;
      }
    }

    translated = temp;
    await _saveCache();
    notifyListeners();
  }

  /// Повертає переклад або оригінальний текст
  String tr(String key) {
    if (language == "uk") return key;
    return translated[key] ?? key;
  }
}
