import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final tr = settings.tr;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            tr("Налаштування"),
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Темна тема
          SwitchListTile(
            title: Text(tr("Темна тема")),
            value: settings.isDarkTheme,
            onChanged: settings.toggleTheme,
          ),
          const Divider(),

          // Оповіщення
          SwitchListTile(
            title: Text(tr("Оповіщення")),
            value: settings.notificationsEnabled,
            onChanged: settings.toggleNotifications,
          ),
          const Divider(),

          // Звуки
          SwitchListTile(
            title: Text(tr("Звуки")),
            value: settings.soundsEnabled,
            onChanged: settings.toggleSounds,
          ),
          const Divider(),

          // Мова
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(tr("Мова")),
            subtitle: Text(
              settings.language == "uk"
                  ? tr("Українська")
                  : tr("Англійська"),
            ),
            onTap: () => _showLanguageDialog(context),
          ),
          const Divider(),

          // Про застосунок
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(tr("Про застосунок")),
            subtitle: Text(tr(
                "Цей застосунок дозволяє керувати каталогом автозапчастин та замовленнями.")),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final tr = settings.tr;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(tr("Виберіть мову")),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile(
                title: Text(tr("Українська")),
                value: "uk",
                groupValue: settings.language,
                onChanged: (value) {
                  settings.changeLanguage(value!);
                  Navigator.pop(context);
                },
              ),
              RadioListTile(
                title: Text(tr("Англійська")),
                value: "en",
                groupValue: settings.language,
                onChanged: (value) {
                  settings.changeLanguage(value!);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
