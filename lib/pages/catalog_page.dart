import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/part.dart';
import '../providers/cart_provider.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({Key? key}) : super(key: key);

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  final List<String> carModels = [
    'Всі авто',
    'Toyota Corolla',
    'BMW X5',
    'Audi A6',
    'Volkswagen Golf',
    'Honda Civic',
    'Renault Megane',
    'Mazda 6',
    'Ford Focus',
    'Mercedes C-Class',
    'Skoda Octavia',
    'Nissan Qashqai',
    'Kia Sportage',
    'Hyundai Tucson',
  ];

  String selectedModel = 'Всі авто';
  String searchText = '';

  List<Part> allParts = [];
  List<Part> filteredParts = [];

  @override
  void initState() {
    super.initState();
    allParts = _generateParts();
    filteredParts = List.from(allParts);
  }

  List<Part> _generateParts() {
    return [
      Part(id: "2", title: 'Повітряний фільтр Bosch', brand: 'Bosch', price: 450, carModel: 'BMW X5'),
      Part(id: "3", title: 'Свічка запалювання NGK', brand: 'NGK', price: 180, carModel: 'Audi A6'),
      Part(id: "4", title: 'Масляний фільтр Mann', brand: 'MANN', price: 320, carModel: 'Volkswagen Golf'),
      Part(id: "5", title: 'Амортизатор KYB', brand: 'KYB', price: 2400, carModel: 'Toyota Corolla'),
      Part(id: "6", title: 'Паливний фільтр Bosch', brand: 'Bosch', price: 380, carModel: 'Renault Megane'),
      Part(id: "7", title: 'Гальмівний диск Brembo', brand: 'Brembo', price: 2100, carModel: 'BMW X5'),
      Part(id: "8", title: 'Ремінь генератора Contitech', brand: 'Contitech', price: 560, carModel: 'Audi A6'),
      Part(id: "9", title: 'Комплект зчеплення Luk', brand: 'LUK', price: 3500, carModel: 'Honda Civic'),
      Part(id: "10", title: 'Фара Depo', brand: 'Depo', price: 2800, carModel: 'Volkswagen Golf'),
      Part(id: "11", title: 'Радіатор NRF', brand: 'NRF', price: 3200, carModel: 'Ford Focus'),
      Part(id: "12", title: 'Паливний насос Pierburg', brand: 'Pierburg', price: 2700, carModel: 'Nissan Qashqai'),


    ];
  }

  void filterParts() {
    setState(() {
      filteredParts = allParts.where((part) {
        final matchesModel = selectedModel == 'Всі авто' ||
            part.carModel.toLowerCase() == selectedModel.toLowerCase();
        final matchesText = searchText.isEmpty ||
            part.title.toLowerCase().contains(searchText.toLowerCase()) ||
            part.brand.toLowerCase().contains(searchText.toLowerCase());
        return matchesModel && matchesText;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: Column(
        children: [
          Container(
            color: Colors.blue.shade800,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    dropdownColor: Colors.white,
                    decoration: InputDecoration(
                      labelText: "Модель авто",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    value: selectedModel,
                    items: carModels.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                    onChanged: (v) {
                      if (v != null) {
                        selectedModel = v;
                        filterParts();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Пошук запчастини...",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onChanged: (v) {
                      searchText = v;
                      filterParts();
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: filteredParts.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final part = filteredParts[index];
                return ListTile(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  tileColor: Colors.white,
                  title: Text(part.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("Бренд: ${part.brand}\nАвто: ${part.carModel}"),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${part.price} ₴", style: const TextStyle(fontSize: 16, color: Colors.blue)),
                      IconButton(
                        icon: const Icon(Icons.add_shopping_cart, color: Colors.blue),
                        onPressed: () {
                          cart.addToCart(part);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Додано до кошика: ${part.title}"),
                            duration: const Duration(seconds: 1),
                          ));
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
