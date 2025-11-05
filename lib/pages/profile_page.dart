import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'package:intl/intl.dart'; // для форматування дат

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<CartProvider>(context).orders;
    final dateFormat = DateFormat('dd.MM.yyyy HH:mm');

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=3"),
            ),
            const SizedBox(height: 12),
            const Center(
              child: Column(
                children: [
                  Text("Олег Варава", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  Text("Київ, Україна", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text("Історія замовлень", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            if (orders.isEmpty)
              const Text("Поки що немає замовлень.", style: TextStyle(color: Colors.grey))
            else
              for (var i = 0; i < orders.length; i++)
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 3,
                  child: ExpansionTile(
                    leading: const Icon(Icons.receipt_long, color: Colors.blue),
                    title: Text("Замовлення #${orders.length - i}"),
                    subtitle: Text(
                      "📅 ${dateFormat.format(orders[i].date)}\n💰 ${orders[i].total} ₴",
                      style: const TextStyle(fontSize: 13),
                    ),
                    children: [
                      ...orders[i].items.map(
                        (part) => ListTile(
                          title: Text(part.title),
                          subtitle: Text("Бренд: ${part.brand} — ${part.price} ₴"),
                        ),
                      ),
                    ],
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
