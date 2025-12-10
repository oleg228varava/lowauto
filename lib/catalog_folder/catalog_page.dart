import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/part.dart';
import '../providers/cart_provider.dart';
import '../floating_message.dart';
import '../widgets/part_card.dart';
import 'part_detail_page.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({Key? key}) : super(key: key);

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Part> allParts = [];
  List<Part> filteredParts = [];
  int itemsToShow = 6;

  // Фільтри
  List<String> selectedCategories = [];
  List<String> selectedBrands = [];
  RangeValues priceRange = const RangeValues(0, 1000);

  final List<String> categories = ['Масла', 'Гальма', 'Фари', 'Шини', 'Акумулятори'];
  final List<String> brands = ['Бренд 1', 'Бренд 2', 'Бренд 3', 'Бренд 4'];

  @override
  void initState() {
    super.initState();
    allParts = _generateParts();
    filteredParts = List.from(allParts);
    _searchController.addListener(_applyFilter);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilter() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      filteredParts = allParts.where((p) {
        final matchesQuery = query.isEmpty ||
            p.title.toLowerCase().contains(query) ||
            p.brand.toLowerCase().contains(query);

        final matchesCategory = selectedCategories.isEmpty ||
            selectedCategories.contains(p.category);

        final matchesBrand = selectedBrands.isEmpty ||
            selectedBrands.contains(p.brand);

        final matchesPrice = p.price >= priceRange.start && p.price <= priceRange.end;

        return matchesQuery && matchesCategory && matchesBrand && matchesPrice;
      }).toList();
      itemsToShow = 6;
    });
  }

  List<Part> _generateParts() {
    return List.generate(
      20,
      (i) => Part(
        id: i.toString(),
        title: 'Товар ${i + 1}',
        brand: brands[i % brands.length],
        price: 100 + i * 50,
        compatibleModels: ['Model A', 'Model B'],
        category: categories[i % categories.length],
      ),
    );
  }

  void _openPartDetails(Part part) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PartDetailPage(part: part)),
    );
  }

  void _loadMore() {
    setState(() {
      itemsToShow += 6;
    });
  }

  void _openFilterDrawer() {
    Scaffold.of(context).openDrawer();
  }

  void _resetFilters() {
    setState(() {
      selectedCategories.clear();
      selectedBrands.clear();
      priceRange = const RangeValues(0, 1000);
      _applyFilter();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);
    final theme = Theme.of(context);

    final showParts = filteredParts.take(itemsToShow).toList();

    return Scaffold(
      drawer: Drawer(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Фільтри", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                const Text("Категорії", style: TextStyle(fontWeight: FontWeight.bold)),
                Wrap(
                  spacing: 8,
                  children: categories.map((cat) {
                    final isSelected = selectedCategories.contains(cat);
                    return FilterChip(
                      label: Text(cat),
                      selected: isSelected,
                      onSelected: (val) {
                        setState(() {
                          if (val) {
                            selectedCategories.add(cat);
                          } else {
                            selectedCategories.remove(cat);
                          }
                          _applyFilter();
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                const Text("Бренди", style: TextStyle(fontWeight: FontWeight.bold)),
                Wrap(
                  spacing: 8,
                  children: brands.map((brand) {
                    final isSelected = selectedBrands.contains(brand);
                    return FilterChip(
                      label: Text(brand),
                      selected: isSelected,
                      onSelected: (val) {
                        setState(() {
                          if (val) {
                            selectedBrands.add(brand);
                          } else {
                            selectedBrands.remove(brand);
                          }
                          _applyFilter();
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                const Text("Ціна", style: TextStyle(fontWeight: FontWeight.bold)),
                RangeSlider(
                  values: priceRange,
                  min: 0,
                  max: 2000,
                  divisions: 20,
                  labels: RangeLabels('${priceRange.start.round()}', '${priceRange.end.round()}'),
                  onChanged: (val) {
                    setState(() {
                      priceRange = val;
                      _applyFilter();
                    });
                  },
                ),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _resetFilters,
                        child: const Text("Скинути"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Застосувати"),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      backgroundColor: theme.colorScheme.background,
      body: Builder(
        builder: (context) => Stack(
          children: [
            // Градієнтний фон
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: theme.brightness == Brightness.dark
                        ? [Colors.black, Colors.deepPurple.shade900]
                        : [Colors.blue.shade50, Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      // Пошук + кнопка фільтр
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: theme.inputDecorationTheme.fillColor,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: TextField(
                                controller: _searchController,
                                style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                                decoration: InputDecoration(
                                  hintText: 'Пошук товарів',
                                  hintStyle: theme.inputDecorationTheme.hintStyle,
                                  prefixIcon: Icon(Icons.search, color: theme.textTheme.bodySmall?.color),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.filter_list, color: Colors.white),
                              onPressed: () => Scaffold.of(context).openDrawer(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Рекомендовано вам
                      Text(
                        'Рекомендовано вам',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      // Список товарів
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: showParts.length + 1,
                        itemBuilder: (context, index) {
                          if (index == showParts.length) {
                            if (itemsToShow < filteredParts.length) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                child: Center(
                                  child: ElevatedButton(
                                    onPressed: _loadMore,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: theme.colorScheme.primary,
                                    ),
                                    child: const Text('Завантажити ще'),
                                  ),
                                ),
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          }

                          final part = showParts[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: PartCard(
                              part: part,
                              onOpen: () => _openPartDetails(part),
                              onAdd: () {
                                cart.addToCart(part);
                                showFloatingMessage(context, 'Товар додано до кошика');
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
