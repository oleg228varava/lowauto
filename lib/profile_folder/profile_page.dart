import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:crop_your_image/crop_your_image.dart';
import '../providers/cart_provider.dart';
import '../providers/settings_provider.dart';
import 'car_card.dart';
 // <-- імпорт для картки машини

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = "Олег Варава";
  String userEmail = "oleg@example.com";
  String tr(String s) =>
    Provider.of<SettingsProvider>(context, listen: true).tr(s);

  Map<String, String>? carData; // <-- залишається тут, щоб передавати в картку

  File? _profileImage;
  Uint8List? _webImageBytes;
  ImageProvider<Object>? _croppedImageProvider;
  final CropController _cropController = CropController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }
void _showAddCarDialog() {
  final brandCtrl = TextEditingController(text: carData?['brand'] ?? '');
  final modelCtrl = TextEditingController(text: carData?['model'] ?? '');
  final yearCtrl = TextEditingController(text: carData?['year'] ?? '');
  final mileageCtrl = TextEditingController(text: carData?['mileage'] ?? '');

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Додати / редагувати машину"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: brandCtrl, decoration: const InputDecoration(labelText: "Марка")),
          TextField(controller: modelCtrl, decoration: const InputDecoration(labelText: "Модель")),
          TextField(controller: yearCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Рік")),
          TextField(controller: mileageCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Пробіг")),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Скасувати")),
        ElevatedButton(
          onPressed: () async {
            final car = {
              'brand': brandCtrl.text.trim(),
              'model': modelCtrl.text.trim(),
              'year': yearCtrl.text.trim(),
              'mileage': mileageCtrl.text.trim(),
            };
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('car_data', jsonEncode(car));
            setState(() => carData = car);
            Navigator.pop(context);
          },
          child: const Text("Зберегти"),
        ),
      ],
    ),
  );
}

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? userName;
      userEmail = prefs.getString('userEmail') ?? userEmail;

      // ---------- LOAD CAR DATA ----------
      final carJson = prefs.getString("car_data");
      if (carJson != null) {
        carData = Map<String, String>.from(jsonDecode(carJson));
      }

      String? base64Image = prefs.getString('profile_image');
      if (base64Image != null) {
        Uint8List bytes = base64Decode(base64Image);
        _croppedImageProvider = MemoryImage(bytes);
        if (kIsWeb) _webImageBytes = bytes;
      }
    });
  }

  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', userName);
    await prefs.setString('userEmail', userEmail);
  }

  Future<void> _pickImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.image, withData: true);
      if (result == null) return;

      Uint8List? bytes;
      if (kIsWeb) {
        bytes = result.files.single.bytes;
      } else if (result.files.single.path != null) {
        _profileImage = File(result.files.single.path!);
        bytes = await _profileImage!.readAsBytes();
      }
      if (bytes != null) _showCropDialog(bytes);
    } catch (e) {
      debugPrint("Image pick error: $e");
    }
  }

  void _showCropDialog(Uint8List imageData) {
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
                  controller: _cropController,
                  image: imageData,
                  aspectRatio: 1.0,
                  withCircleUi: true,
                  onCropped: (croppedData) {
                    setState(() => _croppedImageProvider = MemoryImage(croppedData));
                    SharedPreferences.getInstance().then(
                        (prefs) => prefs.setString('profile_image', base64Encode(croppedData)));
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Скасувати")),
                    ElevatedButton(onPressed: () => _cropController.crop(), child: const Text("Зберегти")),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final orders = Provider.of<CartProvider>(context).orders;
    final settings = Provider.of<SettingsProvider>(context);
    final dateFormat = DateFormat('dd.MM.yyyy HH:mm');

final imageProvider = _croppedImageProvider ??
    (kIsWeb
        ? (_webImageBytes != null ? MemoryImage(_webImageBytes!) : null)
        : (_profileImage != null ? FileImage(_profileImage!) : null));


    return Scaffold(
      backgroundColor: colors.surface,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            // ================== ПРОФІЛЬ ==================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  colors: [colors.primary, colors.primary.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: colors.primary.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Аватар
                  Stack(
                    children: [
                      CircleAvatar(
  radius: 55,
  backgroundImage: imageProvider != null ? imageProvider as ImageProvider<Object> : null,
  child: imageProvider == null
      ? const Icon(Icons.person, size: 60, color: Colors.white)
      : null,
),


                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: IconButton(
                          icon: const Icon(Icons.photo_camera, color: Colors.white),
                          onPressed: _pickImage,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Імʼя + редагування
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () => _showEditProfileMenu(context),
                        child: const Icon(Icons.edit, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    userEmail,
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ================= КАРТКА МАШИНИ =================
           // Приклад використання CarListTile
    if (carData != null)
      CarListTile(
        carData: carData!,
        onTap: () => _showAddCarDialog(),
      ),

    const SizedBox(height: 30),

            // ================= ІСТОРІЯ ЗАМОВЛЕНЬ =================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Історія замовлень",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: colors.onBackground),
                ),
                if (orders.isNotEmpty)
                  Text(
                    "${orders.length} замовлень",
                    style: TextStyle(fontSize: 14, color: colors.onBackground.withOpacity(0.6)),
                  ),
              ],
            ),

            const SizedBox(height: 12),
orders.isEmpty
    ? _buildEmptyOrdersCard(colors, tr)
    : Column(
        children: orders.reversed
            .map(
              (order) => _buildOrderCard(
                order,
                orders.indexOf(order) + 1,
                orders.length,
                dateFormat,
                colors,
                tr,
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

  // ===================== Картки замовлень =====================
  Widget _buildEmptyOrdersCard(ColorScheme colors, String Function(String) tr)
 => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 6))],
        ),
        child: Center(
          child: Text(tr("Поки що немає замовлень."),
            textAlign: TextAlign.center,
            style: TextStyle(color: colors.onSurface.withOpacity(0.6), fontSize: 16),
          ),
        ),
      );

Widget _buildOrderCard(
  order,
  int index,
  int totalOrders,
  DateFormat dateFormat,
  ColorScheme colors,
  String Function(String) tr,
) =>
    Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      shadowColor: colors.primary.withOpacity(0.2),

      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

        leading: CircleAvatar(
          backgroundColor: colors.primary.withOpacity(0.2),
          child: const Icon(Icons.receipt_long, color: Colors.blue),
        ),

        title: Text(
          "${tr("Замовлення")} #${totalOrders - index + 1}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colors.onSurface,
          ),
        ),

        subtitle: Text(
          "📅 ${dateFormat.format(order.date)}  •  💰 "
          "${order.total.toStringAsFixed(2)} ₴",
          style: TextStyle(
            fontSize: 13,
            color: colors.onSurface.withOpacity(0.7),
          ),
        ),

        children: [
          const Divider(thickness: 1, indent: 16, endIndent: 16),

          ...order.items.map(
            (part) => ListTile(
              leading: const Icon(Icons.car_repair, color: Colors.grey),

              title: Text(part.title),

              subtitle: Text(
                "${tr("Бренд")}: ${part.brand} — "
                "${part.price.toStringAsFixed(2)} ₴",
              ),
            ),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );


void _showEditProfileMenu(BuildContext context) {
  final colors = Theme.of(context).colorScheme;
  final settings = Provider.of<SettingsProvider>(context, listen: false);

  String tr(String s) => settings.tr(s);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20))
    ),
    builder: (_) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),

          ListTile(
            leading: const Icon(Icons.edit, color: Colors.orange),
            title: Text(tr("Змінити ім'я")),
            onTap: () => _showTextInputDialog(
              context,
              tr("Ім'я"),
              userName,
              (val) {
                setState(() => userName = val);
                _saveUserData();
              }
            )
          ),

          ListTile(
            leading: const Icon(Icons.email, color: Colors.purple),
            title: Text(tr("Змінити Email")),
            onTap: () => _showTextInputDialog(
              context,
              tr("Email"),
              userEmail,
              (val) {
                setState(() => userEmail = val);
                _saveUserData();
              }
            )
          ),

          ListTile(
            leading: const Icon(Icons.lock, color: Colors.teal),
            title: Text(tr("Змінити пароль")),
            onTap: () => _showTextInputDialog(
              context,
              tr("Новий пароль"),
              "",
              (val) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(tr("Пароль успішно змінено")))
                );
              }
            )
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(tr("Вийти з акаунта")),
            onTap: () {
              SharedPreferences.getInstance()
                  .then((prefs) => prefs.clear());
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),

          const SizedBox(height: 20),
        ],
      ),
    ),
  );
}


void _showTextInputDialog(
    BuildContext context,
    String fieldName,
    String initialValue,
    Function(String) onSave
) {
  final controller = TextEditingController(text: initialValue);

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(tr("Змінити") + " $fieldName"),
      content: TextField(
        controller: controller,
        decoration: InputDecoration(hintText: fieldName),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(tr("Скасувати")),
        ),

        ElevatedButton(
          onPressed: () {
            onSave(controller.text.trim());
            Navigator.pop(context);
          },
          child: Text(tr("Зберегти")),
        ),
      ],
    ),
  );
}

}
