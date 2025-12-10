import 'package:autolowparts_web/utils/auto_translate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../catalog_folder/catalog_page.dart';
import '../profile_folder/profile_page.dart';
import 'settings_page.dart';
import 'cart_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {

    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        final List<Widget> pages = [
          const CatalogPage(),
          const CartContent(),
          const ProfilePage(),
          const SettingsPage(),
        ];

        return Scaffold(
          body: pages[_selectedIndex],
          bottomNavigationBar: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) => setState(() => _selectedIndex = index),
            destinations: [
              NavigationDestination(
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.store),
                  ],
                ),
                label: 'Каталог',
              ),
              NavigationDestination(
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.shopping_cart),
                    if (cart.items.isNotEmpty)
                      Positioned(
                        right: -6,
                        top: -6,
                        child: CircleAvatar(
                          radius: 8,
                          backgroundColor: const Color.fromARGB(255, 82, 135, 250),
                          child: Text(
                            cart.items.length.toString(),
                            style: const TextStyle(fontSize: 10, color: Colors.white),
                          ),
                        ),
                      ),
                  ],
                ),
                label: 'Кошик',
              ),
              const NavigationDestination(
                icon: Icon(Icons.person),
                label: 'Профіль',
              ),
              const NavigationDestination(
                icon: Icon(Icons.settings),
                label: 'Налаштування',
              ),
            ],
          ),
        );
      },
    );
  }
}
