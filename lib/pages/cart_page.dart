import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/settings_provider.dart';

class CartContent extends StatelessWidget {
  final Function(int)? onNavigate;
  const CartContent({Key? key, this.onNavigate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final colors = Theme.of(context).colorScheme;
    final settings = Provider.of<SettingsProvider>(context);
    final tr = settings.tr; // функція перекладу

    final groupedItems = <String, Map<String, dynamic>>{};
    for (var item in cart.items) {
      if (groupedItems.containsKey(item.id)) {
        groupedItems[item.id]!['quantity']++;
      } else {
        groupedItems[item.id] = {'item': item, 'quantity': 1};
      }
    }

    OverlayEntry? overlayEntry;
    void showFloatingMessage(String message) {
      overlayEntry?.remove();
      overlayEntry = OverlayEntry(
        builder: (_) => Positioned(
          top: MediaQuery.of(context).padding.top + 16,
          left: 16,
          right: 16,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: Theme.of(context).brightness == Brightness.dark
                      ? [Colors.deepPurple.shade700, Colors.black87]
                      : [Colors.blue.shade300, Colors.blue.shade600],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 8, offset: const Offset(0, 4)),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      message,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      Overlay.of(context)?.insert(overlayEntry!);
      Future.delayed(const Duration(seconds: 2), () {
        overlayEntry?.remove();
        overlayEntry = null;
      });
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: Theme.of(context).brightness == Brightness.dark
              ? [Colors.black, Colors.deepPurple.shade900]
              : [Colors.blue.shade50, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: cart.items.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_cart_outlined, size: 80, color: colors.primary),
                    const SizedBox(height: 16),
                    Text(tr("Кошик порожній"), style: TextStyle(fontSize: 20, color: colors.onBackground)),
                    const SizedBox(height: 24),
                    OutlinedButton.icon(
                      icon: Icon(Icons.store, color: colors.primary),
                      label: Text(tr("Перейти до покупок"), style: TextStyle(color: colors.primary)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
                        side: BorderSide(color: colors.primary.withOpacity(0.6), width: 1.4),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => onNavigate?.call(0),
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: groupedItems.entries.map((entry) {
                        final item = entry.value['item'];
                        final quantity = entry.value['quantity'];
                        return Card(
                          color: colors.surface.withOpacity(0.8),
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            title: Text(item.title, style: TextStyle(color: colors.onSurface)),
                            subtitle: Text(
                              '${item.price} ₴ x $quantity = ${item.price * quantity} ₴',
                              style: TextStyle(color: colors.primary),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove, color: colors.error),
                                  onPressed: () => cart.removeOne(item),
                                ),
                                Text("$quantity", style: TextStyle(color: colors.onSurface, fontSize: 16)),
                                IconButton(
                                  icon: Icon(Icons.add, color: colors.primary),
                                  onPressed: () => cart.addToCart(item),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.payment),
                    label: Text(tr('Оформити замовлення')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primary,
                      foregroundColor: colors.onPrimary,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    ),
                    onPressed: () {
                      if (cart.items.isNotEmpty) {
                        cart.checkout();
                        showFloatingMessage(tr('Замовлення успішно оформлено'));
                      }
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
