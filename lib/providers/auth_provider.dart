// lib/providers/auth_provider.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool isLogged = false;

  String? userEmail;
  String? userName;

  // [{email, password, name}]
  List<Map<String, String>> users = [];

  // -----------------------------
  // LOAD
  // -----------------------------
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();

    isLogged = prefs.getBool("isLogged") ?? false;
    userEmail = prefs.getString("userEmail");
    userName = prefs.getString("userName");

    final jsonUsers = prefs.getString("users");
    if (jsonUsers != null) {
      users = List<Map<String, String>>.from(
        (jsonDecode(jsonUsers) as List).map(
          (e) => Map<String, String>.from(e),
        ),
      );
    }

    notifyListeners();
  }

  // -----------------------------
  // REGISTER
  // -----------------------------
  Future<String?> register(
    String name,
    String email,
    String password,
  ) async {
    if (users.any((u) => u["email"] == email)) {
      return "Користувач вже існує";
    }

    users.add({
      "name": name,
      "email": email,
      "password": password,
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("users", jsonEncode(users));

    return null;
  }

  // -----------------------------
  // LOGIN
  // -----------------------------
Future<String?> login(String email, String password) async {
  final user = users.firstWhere(
    (u) => u["email"] == email && u["password"] == password,
    orElse: () => {},
  );

  if (user.isEmpty) {
    return "Невірний email або пароль";
  }

  final prefs = await SharedPreferences.getInstance();

  final name = user["name"] ?? "Користувач";

  await prefs.setBool("isLogged", true);
  await prefs.setString("userEmail", user["email"]!);
  await prefs.setString("userName", name);

  isLogged = true;
  userEmail = user["email"];
  userName = name;

  notifyListeners();
  return null;
}


  // -----------------------------
  // LOGOUT
  // -----------------------------
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove("isLogged");
    await prefs.remove("userEmail");
    await prefs.remove("userName");

    isLogged = false;
    userEmail = null;
    userName = null;

    notifyListeners();
  }
}
