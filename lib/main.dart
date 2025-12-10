import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'providers/settings_provider.dart';
import 'providers/cart_provider.dart';

import 'catalog_folder/catalog_page.dart';
import 'pages/cart_page.dart';
import 'profile_folder/profile_page.dart';
import 'pages/settings_page.dart';

import 'themes/app_themes.dart';

void main() {
  runApp(const AutoLowPartsApp());
}

class AutoLowPartsApp extends StatelessWidget {
  const AutoLowPartsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'AutoLowParts.ua',
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            themeMode:
                settings.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
            home: const MainNavigator(),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('uk'),
              Locale('en'),
            ],
            locale: settings.locale,
          );
        },
      ),
    );
  }
}

// ====================== Головний навігатор з анімацією ======================
class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  void _onPageChanged(int index) {
    setState(() => _currentIndex = index);
  }

  void _onBottomNavTap(int index) {
    if ((index - _currentIndex).abs() == 1) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _pageController.jumpToPage(index);
    }
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final List<Widget> pages = [
      CatalogPage(),
      CartContent(onNavigate: _onBottomNavTap), // ← ДОДАНО
      ProfilePage(),
      SettingsPage(),
    ];

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: pages,
        physics: const BouncingScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: colors.primary,
        unselectedItemColor:
            colors.onBackground.withOpacity(0.5),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.storefront), label: 'Каталог'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Кошик'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: 'Профіль'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Налаштування'),
        ],
      ),
    );
  }
}
