import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'providers/settings_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/auth_provider.dart';

import 'catalog_folder/catalog_page.dart';
import 'pages/cart_page.dart';
import 'profile_folder/profile_page.dart';
import 'pages/login_page.dart';
import 'themes/app_themes.dart';
import 'utils/currency_service.dart';
import 'pages/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await CurrencyService.fetchRates();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const AutoLowPartsApp(),
    ),
  );
}

// ======================= Custom Text Widget =======================
class T extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;

  const T(this.text, {super.key, this.style, this.textAlign});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    return Text(
      settings.tr(text),
      style: style,
      textAlign: textAlign,
    );
  }
}

// ======================= Main App =======================
class AutoLowPartsApp extends StatelessWidget {
  const AutoLowPartsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'AutoLowParts.ua',

          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          themeMode: settings.isDarkTheme ? ThemeMode.dark : ThemeMode.light,

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

          initialRoute: "/",
          routes: {
            "/": (context) => const SplashPage(),
            "/home": (context) => const MainNavigator(),
            "/login": (context) => const LoginPage(),
          },
        );
      },
    );
  }
}

// ====================== Головний навігатор ======================
class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _currentIndex = 0;

  final pages = const [
    CatalogPage(),
    CartContent(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final settings = Provider.of<SettingsProvider>(context);

    return Scaffold(
      backgroundColor: colors.surface,

      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, anim) {
          return FadeTransition(
            opacity: anim,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.97, end: 1.0).animate(anim),
              child: child,
            ),
          );
        },
        child: KeyedSubtree(
          key: ValueKey(_currentIndex),
          child: pages[_currentIndex],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,

        selectedItemColor: colors.primary,
        unselectedItemColor: colors.onSurface.withOpacity(.6),

        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.storefront),
            label: settings.tr('Каталог'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.shopping_cart),
            label: settings.tr('Кошик'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: settings.tr('Профіль'),
          ),
        ],
      ),
    );
  }
}
