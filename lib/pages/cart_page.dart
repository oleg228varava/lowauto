import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: cart.items.isEmpty
            ? const Center(child: Text("Кошик порожній 🛒"))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Ваш кошик", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      itemCount: cart.items.length,
                      itemBuilder: (context, index) {
                        final part = cart.items[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            title: Text(part.title),
                            subtitle: Text("${part.price} ₴"),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => cart.removeFromCart(part),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(),
                  Text("Разом: ${cart.totalPrice} ₴",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Center(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.payment),
                      label: const Text("Оформити замовлення"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                      ),
                      onPressed: () {
  cart.checkout();
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Замовлення оформлено ✅")),
  );


                        cart.clear();
                      },
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
