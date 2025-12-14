import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/settings_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String userName = "User";
  String userEmail = "example@gmail.com";

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final colors = Theme.of(context).colorScheme;
    final tr = settings.tr; // локальна функція перекладу

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          tr("Налаштування"),
          style: TextStyle(fontWeight: FontWeight.bold, color: colors.onSurface),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Редагувати профіль
          ListTile(
            leading: Icon(Icons.person, color: colors.primary),
            title: Text(tr("Редагувати профіль")),
            onTap: () => _showEditProfileMenu(context, settings),
          ),
          const Divider(),

          // Темна тема
          SwitchListTile(
            title: Text(tr("Темна тема")),
            value: settings.isDarkTheme,
            onChanged: settings.toggleTheme,
          ),
          const Divider(),

          // Сповіщення
          SwitchListTile(
            title: Text(tr("Оповіщення")),
            value: settings.notificationsEnabled,
            onChanged: settings.toggleNotifications,
          ),
          const Divider(),

          SwitchListTile(
            title: Text(tr("Звуки")),
            value: settings.soundsEnabled,
            onChanged: settings.toggleSounds,
          ),
          const Divider(),

          SwitchListTile(
            title: Text(tr("Вібрація")),
            value: settings.vibrationEnabled,
            onChanged: settings.toggleVibration,
          ),
          const Divider(),


SwitchListTile(
  title: Text(tr("Email-сповіщення")),
  value: settings.emailNotifications,
  onChanged: settings.toggleEmailNotifications,
),
          const Divider(),

SwitchListTile(
  title: Text(tr("SMS-сповіщення")),
  value: settings.smsNotifications,
  onChanged: settings.toggleSmsNotifications,
),
          const Divider(),

      
SwitchListTile(
  title: Text(tr("Промо-сповіщення")),
  value: settings.promoNotifications,
  onChanged: settings.togglePromoNotifications,
),
          const Divider(),

          // Мова
          ListTile(
            leading: Icon(Icons.language, color: colors.primary),
            title: Text(tr("Мова")),
            subtitle: Text(
              settings.language == "uk" ? tr("Українська") : tr("English"),
            ),
            onTap: () => _showLanguageDialog(settings),
          ),
          const Divider(),

          // Ліміт історії замовлень
          ListTile(
            leading: Icon(Icons.history, color: colors.primary),
            title: Text(tr("Ліміт історії замовлень")),
            subtitle: Text("${settings.orderHistoryLimit}"),
            onTap: () => _showOrderHistoryLimitDialog(settings),
          ),
          const Divider(),

          // Контактна підтримка
 ListTile(
  leading: Icon(Icons.support_agent, color: Colors.blue),
  title: Text(tr("Звязатись з фахівцем")), // тепер збігається з allTexts
  onTap: _contactSupport,
),
          const Divider(),

          // Про застосунок
          ListTile(
            leading: Icon(Icons.info, color: Colors.green),
            title: Text(tr("Про застосунок")),
            onTap: () => _showAboutDialog(settings),
          ),
          const Divider(),

          // Вийти з акаунту
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text(tr("Вийти з акаунту")),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("/login", (route) => false);
            },
          ),
        ],
      ),
    );
  }

  // ================= Діалоги =================
  void _showEditProfileMenu(BuildContext context, SettingsProvider settings) {
    final tr = settings.tr;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.orange),
              title: Text(tr("Змінити ім'я")),
              onTap: () => _showInputDialog(tr("Ім'я"), userName, (val) {
                setState(() => userName = val);
              }),
            ),
            ListTile(
              leading: const Icon(Icons.email, color: Colors.purple),
              title: Text(tr("Змінити Email")),
              onTap: () => _showInputDialog(tr("Email"), userEmail, (val) {
                setState(() => userEmail = val);
              }),
            ),
            ListTile(
              leading: const Icon(Icons.lock, color: Colors.teal),
              title: Text(tr("Змінити пароль")),
              onTap: () => _showInputDialog(tr("Новий пароль"), "", (val) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(tr("Пароль успішно змінено"))),
                );
              }),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showInputDialog(String title, String initial, Function(String) onSave) {
    final controller = TextEditingController(text: initial);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(title), // Можна додати tr("Відміна") якщо потрібно
          ),
          ElevatedButton(
            onPressed: () {
              onSave(controller.text.trim());
              Navigator.pop(context);
            },
            child: const Text("Зберегти"),
          ),
        ],
      ),
    );
  }

  void _contactSupport() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'support@example.com',
      query: 'subject=Підтримка',
    );
    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    }
  }

  void _showAboutDialog(SettingsProvider settings) {
    final tr = settings.tr;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(tr("Про застосунок")),
        content: Text(tr(
            "Цей застосунок дозволяє керувати каталогом автозапчастин та замовленнями.")),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(tr("Закрити"))),
        ],
      ),
    );
  }

  void _showLanguageDialog(SettingsProvider settings) {
    final tr = settings.tr;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(tr("Виберіть мову")),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(tr("Українська")),
              onTap: () async {
                await settings.changeLanguage("uk");
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(tr("English")),
              onTap: () async {
                await settings.changeLanguage("en");
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showOrderHistoryLimitDialog(SettingsProvider settings) {
    final tr = settings.tr;
    final controller =
        TextEditingController(text: settings.orderHistoryLimit.toString());

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(tr("Ліміт історії замовлень")),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(tr("Відміна"))),
          ElevatedButton(
              onPressed: () {
                settings
                    .setOrderHistoryLimit(int.tryParse(controller.text) ?? 50);
                Navigator.pop(context);
              },
              child: Text(tr("Зберегти"))),
        ],
      ),
    );
  }
}
