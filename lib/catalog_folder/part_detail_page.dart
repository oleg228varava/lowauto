import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/part.dart';
import '../providers/cart_provider.dart';
import '../floating_message.dart';

class PartDetailPage extends StatefulWidget {
  final Part part;
  const PartDetailPage({Key? key, required this.part}) : super(key: key);

  @override
  State<PartDetailPage> createState() => _PartDetailPageState();
}

class _PartDetailPageState extends State<PartDetailPage> {
  int imgIndex = 0;
  bool favorite = false;
  double rating = 0.0;

  @override
  Widget build(BuildContext context) {
    final part = widget.part;
    final cart = Provider.of<CartProvider>(context, listen: false);
    final theme = Theme.of(context);

    Widget star(double r, {double s = 20}) => Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(5, (i) {
          if (i < r.floor()) return Icon(Icons.star, color: Colors.amber, size: s);
          if (i < r) return Icon(Icons.star_half, color: Colors.amber, size: s);
          return Icon(Icons.star_border, color: Colors.amber, size: s);
        }));

    Widget bullet(String t) => Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [const Text('• ', style: TextStyle(color: Colors.white)), Expanded(child: Text(t, style: const TextStyle(color: Colors.white70)))],
    );

    Widget rowChar(String n, String v) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(n, style: const TextStyle(color: Colors.white70))),
          Expanded(flex: 5, child: Text(v, style: const TextStyle(color: Colors.white))),
        ],
      ),
    );

    Widget review(String u, int r, String c) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [Text(u, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)), const SizedBox(width: 8), star(r.toDouble(), s: 14)]),
        const SizedBox(height: 2),
        Text(c, style: const TextStyle(color: Colors.white70)),
      ]),
    );

    return Scaffold(
      backgroundColor: const Color(0xFF111827),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F2937),
        title: Text(part.title, style: const TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(favorite ? Icons.favorite : Icons.favorite_border, color: Colors.redAccent),
            onPressed: () {
              setState(() => favorite = !favorite);
              showFloatingMessage(context, favorite ? 'Додано до улюбленого' : 'Видалено з улюбленого');
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            height: 250,
            decoration: BoxDecoration(color: const Color(0xFF1F2937), borderRadius: BorderRadius.circular(12)),
            child: PageView.builder(
              itemCount: part.images.isEmpty ? 1 : part.images.length,
              onPageChanged: (i) => setState(() => imgIndex = i),
              itemBuilder: (_, i) => part.images.isEmpty
                  ? const Center(child: Icon(Icons.car_repair, size: 100, color: Colors.grey))
                  : Image.asset(part.images[i], fit: BoxFit.contain),
            ),
          ),
          if (part.images.length > 1)
            Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(part.images.length, (i) {
              return Container(
                margin: const EdgeInsets.all(4),
                width: imgIndex == i ? 12 : 8,
                height: imgIndex == i ? 12 : 8,
                decoration: BoxDecoration(color: imgIndex == i ? const Color(0xFF3B82F6) : Colors.grey[600], shape: BoxShape.circle),
              );
            })),
          const SizedBox(height: 16),
          Text(part.title, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
          Text('Бренд: ${part.brand}', style: theme.textTheme.titleMedium?.copyWith(color: Colors.white70)),
          const SizedBox(height: 8),
          Row(children: [star(rating), const SizedBox(width: 8), Text('${rating.toStringAsFixed(1)}/5', style: const TextStyle(color: Colors.white70))]),
          const SizedBox(height: 16),
          Text('${part.price} ₴', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.redAccent)),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text('Додати в кошик'),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3B82F6), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              onPressed: () {
                cart.addToCart(part);
                showFloatingMessage(context, 'Додано "${part.title}"');
              },
            ),
          ),
          const SizedBox(height: 24),
          Text('Опис товару', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 8),
          const Text(
            'Ця запчастина виготовлена з високоякісних матеріалів і пройшла строгий контроль якості. '
            'Вона сумісна з широким спектром автомобілів і забезпечує надійну роботу вашого авто. '
            'Має сертифікати ISO, гарантію від виробника та легко встановлюється.',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 12),
          Text('Переваги:', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
          bullet('Висока надійність і довговічність'),
          bullet('Легка установка без спеціальних інструментів'),
          bullet('Гарантія від виробника 12 місяців'),
          bullet('Оптимальне співвідношення ціни та якості'),
          const SizedBox(height: 16),
          Text('Технічні характеристики', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
          rowChar('Матеріал', 'Метал/пластик високої якості'),
          rowChar('Вага', '1.2 кг'),
          rowChar('Розміри', '15 x 10 x 5 см'),
          rowChar('Гарантія', '12 місяців'),
          rowChar('Сумісність', part.compatibleModels.join(', ')),
          rowChar('Тип', 'Оригінальна / Aftermarket'),
          rowChar('Країна виробництва', 'Німеччина'),
          const SizedBox(height: 16),
          Text('Відгуки користувачів', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
          review('Іван', 5, 'Запчастина чудова, швидко встановив!'),
          review('Олена', 4, 'Все добре, але упаковка була трохи пошкоджена.'),
          review('Сергій', 5, 'Рекомендую, працює відмінно!'),
        ]),
      ),
    );
  }
}
