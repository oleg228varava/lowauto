import 'package:flutter/material.dart';
import '../models/part.dart';
import 'package:flutter/material.dart';
import 'catalog_page.dart';
import 'cart_page.dart';
import 'profile_page.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = const [
    CatalogPage(),
    CartPage(),
    ProfilePage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AutoLowParts.ua"),
        backgroundColor: Colors.blue.shade800,
        centerTitle: true,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.car_rental), label: "Каталог"),
          NavigationDestination(icon: Icon(Icons.shopping_cart), label: "Кошик"),
          NavigationDestination(icon: Icon(Icons.person), label: "Профіль"),
          NavigationDestination(icon: Icon(Icons.settings), label: "Налашт."),
        ],
      ),
    );
  }
}

