import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/part.dart';
import '../providers/cart_provider.dart';
import '../floating_message.dart';
import '../widgets/part_card.dart';
import 'part_detail_page.dart';
import '../providers/settings_provider.dart';
import '../utils/currency_service.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({Key? key}) : super(key: key);

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

// ======================= Custom Text Widget =======================
class T extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;

  const T(this.text, {super.key, this.style, this.textAlign});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    return Text(
      settings.tr(text),
      style: style,
      textAlign: textAlign,
    );
  }
}

class _CatalogPageState extends State<CatalogPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Part> allParts = [];
  List<Part> filteredParts = [];
  int itemsToShow = 6;

  List<String> selectedCategories = [];
  List<String> selectedBrands = [];
  RangeValues priceRange = const RangeValues(0, 1000);

  final List<String> categories = ['Масла', 'Гальма', 'Фари', 'Шини', 'Акумулятори'];
  final List<String> brands = ['Бренд 1', 'Бренд 2', 'Бренд 3', 'Бренд 4'];

  @override
  void initState() {
    super.initState();
    CurrencyService.fetchRates().then((_) {
      setState(() {});
    });
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
    final settings = Provider.of<SettingsProvider>(context);
    final showParts = filteredParts.take(itemsToShow).toList();

    return Scaffold(
      drawer: Drawer(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                T("Фільтри", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                T("Категорії", style: const TextStyle(fontWeight: FontWeight.bold)),
                Wrap(
                  spacing: 8,
                  children: categories.map((cat) {
                    final isSelected = selectedCategories.contains(cat);
                    return FilterChip(
                      label: T(cat),
                      selected: isSelected,
                      onSelected: (val) {
                        setState(() {
                          if (val) selectedCategories.add(cat);
                          else selectedCategories.remove(cat);
                          _applyFilter();
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                T("Бренди", style: const TextStyle(fontWeight: FontWeight.bold)),
                Wrap(
                  spacing: 8,
                  children: brands.map((brand) {
                    final isSelected = selectedBrands.contains(brand);
                    return FilterChip(
                      label: T(brand),
                      selected: isSelected,
                      onSelected: (val) {
                        setState(() {
                          if (val) selectedBrands.add(brand);
                          else selectedBrands.remove(brand);
                          _applyFilter();
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                T("Ціна", style: const TextStyle(fontWeight: FontWeight.bold)),
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
                        child: T("Скинути"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: T("Застосувати"),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      backgroundColor: theme.colorScheme.surface,
      body: Builder(
        builder: (context) => Stack(
          children: [
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
                                  hintText: settings.tr('Пошук товарів'),
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
                      T('Рекомендовано вам', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
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
                                    child: T('Завантажити ще'),
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
                                showFloatingMessage(context, settings.tr('Товар додано до кошика'));
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
