import 'package:flutter/material.dart';

class CatalogFilter extends StatefulWidget {
  final TextEditingController searchController;
  final String selectedModel;
  final List<String> carModels;
  final void Function(String) onModelChanged;
  final VoidCallback onReset;
  final VoidCallback onSearch;
  final void Function(double, double) onPriceChanged;

  const CatalogFilter({
    super.key,
    required this.searchController,
    required this.selectedModel,
    required this.carModels,
    required this.onModelChanged,
    required this.onReset,
    required this.onSearch,
    required this.onPriceChanged,
  });

  @override
  State<CatalogFilter> createState() => _CatalogFilterState();
}

class _CatalogFilterState extends State<CatalogFilter> {
  double _minPrice = 0;
  double _maxPrice = 2000;

  final TextEditingController _minController = TextEditingController();
  final TextEditingController _maxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _minController.text = _minPrice.toInt().toString();
    _maxController.text = _maxPrice.toInt().toString();
  }

  void _onSliderChanged(RangeValues values) {
    setState(() {
      _minPrice = values.start;
      _maxPrice = values.end;
      _minController.text = _minPrice.toInt().toString();
      _maxController.text = _maxPrice.toInt().toString();
    });
    widget.onPriceChanged(_minPrice, _maxPrice);
  }

  void _onMinChanged(String value) {
    double val = double.tryParse(value) ?? _minPrice;
    if (val < 0) val = 0;
    if (val > _maxPrice) val = _maxPrice;
    setState(() {
      _minPrice = val;
    });
    widget.onPriceChanged(_minPrice, _maxPrice);
  }

  void _onMaxChanged(String value) {
    double val = double.tryParse(value) ?? _maxPrice;
    if (val > 2000) val = 2000;
    if (val < _minPrice) val = _minPrice;
    setState(() {
      _maxPrice = val;
    });
    widget.onPriceChanged(_minPrice, _maxPrice);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF3A2323),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Знайди запчастину дешевше ніж на ринку',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),

            // Пошук
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: widget.searchController,
                    decoration: InputDecoration(
                      prefixIcon:
                          const Icon(Icons.search, color: Colors.white70),
                      hintText: 'Марка, модель або частина',
                      hintStyle: const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: const Color(0xFF2E2E2E),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: widget.onSearch,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD23A3A),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Шукати'),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Модель авто та скидання
            Row(
              children: [
                DropdownButton<String>(
                  value: widget.selectedModel,
                  dropdownColor: const Color(0xFF2E2E2E),
                  style: const TextStyle(color: Colors.white),
                  items: widget.carModels
                      .map((m) => DropdownMenuItem(
                            value: m,
                            child: Text(
                              m,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) widget.onModelChanged(v);
                  },
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: widget.onReset,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white24),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Скинути',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Ползунок
            Text(
              'Ціна: ${_minPrice.toInt()}₴ - ${_maxPrice.toInt()}₴',
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600),
            ),
            RangeSlider(
              values: RangeValues(_minPrice, _maxPrice),
              min: 0,
              max: 2000,
              divisions: 2000,
              activeColor: const Color(0xFFD23A3A),
              inactiveColor: Colors.white24,
              labels: RangeLabels(
                _minPrice.toInt().toString(),
                _maxPrice.toInt().toString(),
              ),
              onChanged: _onSliderChanged,
            ),

            // Текстові поля
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _minController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Мінімальна ціна',
                      labelStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: const Color(0xFF2E2E2E),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
                    ),
                    style: const TextStyle(color: Colors.white),
                    onChanged: _onMinChanged,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _maxController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Максимальна ціна',
                      labelStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: const Color(0xFF2E2E2E),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
                    ),
                    style: const TextStyle(color: Colors.white),
                    onChanged: _onMaxChanged,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
