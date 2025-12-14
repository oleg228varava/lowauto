import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:autolowparts_web/pages/settings_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:crop_your_image/crop_your_image.dart';
import '/providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/settings_provider.dart';
import 'car_card.dart';
import '/pages/settings_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = "user2345243";
  String userEmail = "user@example.com";

  Map<String, String>? carData;

  File? _profileImage;
  Uint8List? _webBytes;
  ImageProvider<Object>? imageProvider;

  final CropController crop = CropController();

  String tr(String s) =>
      Provider.of<SettingsProvider>(context, listen: true).tr(s);

  @override
  void initState() {
    super.initState();
    _load();
  }

  // ================= LOAD =================
  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
final auth = context.read<AuthProvider>();


    setState(() {
final auth = context.read<AuthProvider>();
userName = auth.userName ?? prefs.getString('userName') ?? userName;
userEmail = auth.userEmail ?? prefs.getString('userEmail') ?? userEmail;


      final car = prefs.getString("car_data");
      if (car != null) {
        carData = Map<String, String>.from(jsonDecode(car));
      }

      final img = prefs.getString("profile_image");
      if (img != null) {
        final bytes = base64Decode(img);
        imageProvider = MemoryImage(bytes);
        if (kIsWeb) _webBytes = bytes;
      }
    });
  }

  // ================= PICK IMAGE =================
  Future<void> _pick() async {
    final result = await FilePicker.platform.pickFiles(
        type: FileType.image, withData: true);

    if (result == null) return;

    Uint8List? bytes;

    if (kIsWeb) {
      bytes = result.files.single.bytes;
    } else {
      final path = result.files.single.path;
      if (path != null) bytes = File(path).readAsBytesSync();
    }

    if (bytes != null) _crop(bytes);
  }

  // ================= CROP =================
  void _crop(Uint8List data) {
  showDialog(
    context: context,
    builder: (_) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        width: 300,
        height: 400,
        child: Column(
          children: [
            Expanded(
              child: Crop(
                controller: crop,
                image: data,
                aspectRatio: 1,
                withCircleUi: true,
                onCropped: (out) async { // ✅ додали async
                  setState(() => imageProvider = MemoryImage(out));

                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString("profile_image", base64Encode(out)); // ✅ зберігаємо

                  Navigator.pop(context);
                },
              ),
            ),

            // кнопки
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Скасувати"),
                  ),
                  ElevatedButton(
                    onPressed: () => crop.crop(),
                    child: const Text("Зберегти"),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}


  // ================= CAR DIALOG =================
  void _showCarDialog() {
    final b = TextEditingController(text: carData?['brand']);
    final m = TextEditingController(text: carData?['model']);
    final y = TextEditingController(text: carData?['year']);
    final km = TextEditingController(text: carData?['mileage']);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Машина"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: b, decoration: const InputDecoration(labelText: "Марка")),
            TextField(controller: m, decoration: const InputDecoration(labelText: "Модель")),
            TextField(controller: y, decoration: const InputDecoration(labelText: "Рік"), keyboardType: TextInputType.number),
            TextField(controller: km, decoration: const InputDecoration(labelText: "Пробіг"), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Скасувати")),
          ElevatedButton(
            onPressed: () async {
              final car = {
                "brand": b.text,
                "model": m.text,
                "year": y.text,
                "mileage": km.text,
              };

              final prefs = await SharedPreferences.getInstance();
              await prefs.setString("car_data", jsonEncode(car));

              setState(() => carData = car);

              Navigator.pop(context);
            },
            child: const Text("Зберегти"),
          )
        ],
      ),
    );
  }

  // ================= BUILD =================
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final orders = Provider.of<CartProvider>(context).orders;

    final avatar = imageProvider ??
        (kIsWeb && _webBytes != null
            ? MemoryImage(_webBytes!)
            : (_profileImage != null
                ? FileImage(_profileImage!)
                : null));

    return Scaffold(
      backgroundColor: colors.surface,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ====== PROFILE ======
            Padding(
  padding: const EdgeInsets.symmetric(horizontal: 1), // відступи від країв екрану
  child: Container(
    width: double.infinity, // ✅ картка на всю ширину
    padding: const EdgeInsets.all(20), // внутрішні відступи
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(24),
      gradient: LinearGradient(
        colors: [
          colors.primary,
          colors.primary.withOpacity(.8)
        ],
      ),
    ),
    child: Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 55,
              backgroundImage: avatar as ImageProvider<Object>?,
              child: avatar == null
                  ? const Icon(Icons.person, size: 55, color: Colors.white)
                  : null,
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: IconButton(
                icon: const Icon(Icons.photo_camera, color: Colors.white),
                onPressed: _pick,
              ),
            )
          ],
        ),
        const SizedBox(height: 16),
        Text(
          userName,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          userEmail,
          style: const TextStyle(color: Colors.white70),
        ),
      ],
    ),
  ),
),

const SizedBox(height: 30),

            // ===== SETTINGS =====
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(tr("Налаштування")),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const SettingsPage()),
              ),
            ),

            const SizedBox(height: 20), 

            // ===== ORDERS =====
            Text(
              tr("Історія замовлень"),
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            orders.isEmpty
                ? Text(tr("Поки немає замовлень"))
                : Column(
                    children: orders
                        .reversed
                        .map(
                          (o) => Card(
                            child: ListTile(
                              title:
                                  const Text("Замовлення"),
                              subtitle: Text(
                                  "${DateFormat('dd.MM.yyyy HH:mm').format(o.date)} • ${o.total}₴"),
                            ),
                          ),
                        )
                        .toList(),
                  ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
