import 'package:translator/translator.dart';

class LocalizationService {
  final GoogleTranslator _translator = GoogleTranslator();

  final Map<String, Map<String, String>> _cache = {};

  Future<String> translate(String key, String lang) async {
    if (lang == 'uk') return key;

    if (_cache[key] != null && _cache[key]![lang] != null) {
      return _cache[key]![lang]!;
    }

    final res = await _translator.translate(key, to: lang);

    _cache[key] ??= {};
    _cache[key]![lang] = res.text;

    return res.text;
  }

  Future<Map<String, String>> translateAll(List<String> keys, String lang) async {
    Map<String, String> out = {};
    for (var k in keys) {
      out[k] = await translate(k, lang);
    }
    return out;
  }
}
