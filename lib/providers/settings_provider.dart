import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

class SettingsProvider extends ChangeNotifier {
  bool isDarkTheme = false;
  void toggleTheme(bool v) { isDarkTheme = v; notifyListeners(); }

  bool notificationsEnabled = true;
  bool soundsEnabled = true;

  void toggleNotifications(bool v) { notificationsEnabled = v; notifyListeners(); }
  void toggleSounds(bool v) { soundsEnabled = v; notifyListeners(); }

  // ---------------- Локаль / Мова ----------------
  String language = "uk";
  Locale _locale = const Locale('uk');
  Locale get locale => _locale;

  void setLocale(Locale newLocale) {
    _locale = newLocale;
    notifyListeners();
  }

  // ---------------- Google Translate ----------------
  final GoogleTranslator _translator = GoogleTranslator();

  /// ключ → переклад
  Map<String, String> translated = {};

  /// Тексти, які треба перекласти (всі, що в інтерфейсі)
  final List<String> allTexts = [
    "Налаштування",
    "Темна тема",
    "Оповіщення",
    "Звуки",
    "Мова",
    "Українська",
    "Англійська",
    "Про застосунок",
    "Цей застосунок дозволяє керувати каталогом автозапчастин та замовленнями.",
    "Виберіть мову",
    "Додати / редагувати машину",
    "Марка",
    "Модель",
    "Рік",
    "Пробіг",
    "Зберегти",
    "Скасувати",
    "Історія замовлень",
    "Поки що немає замовлень.",
    "Замовлення",
    "Змінити ім'я",
    "Змінити Email",
    "Змінити пароль",
    "Новий пароль",
    "Пароль успішно змінено",
    "Тема додатку",
    "Вийти з акаунта",
    "Поки що немає замовлень.",
    "Історія замовлень",
    "Замовлення",
    "Бренд",
    "замовлень",
    "Замовлення #",
  ];

  /// Перекладає увесь список одним натиском
  Future<void> changeLanguage(String lang) async {
    language = lang;

    // якщо українська — не треба переклад
    if (lang == "uk") {
      translated.clear();
      notifyListeners();
      return;
    }

    Map<String, String> temp = {};

    for (String text in allTexts) {
      try {
        var tr = await _translator.translate(text, to: lang);
        temp[text] = tr.text;
      } catch (_) {
        temp[text] = text; // fallback
      }
    }

    translated = temp;
    notifyListeners();
  }

  /// Метод для використання у UI
  String tr(String key) {
    if (language == "uk") return key;
    return translated[key] ?? key;
  }
}
