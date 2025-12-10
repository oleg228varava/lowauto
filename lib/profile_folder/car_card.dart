import 'package:flutter/material.dart';

class CarListTile extends StatelessWidget {
  final Map<String, String> carData;
  final VoidCallback onTap;

  const CarListTile({Key? key, required this.carData, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 3))
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.directions_car, size: 32, color: Colors.blue),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${carData['brand'] ?? ''} ${carData['model'] ?? ''}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: colors.onSurface),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      if (carData['year'] != null && carData['year']!.isNotEmpty)
                        Text(
                          "Рік: ${carData['year']}",
                          style: TextStyle(fontSize: 12, color: colors.onSurface.withOpacity(0.7)),
                        ),
                      if (carData['year'] != null && carData['year']!.isNotEmpty &&
                          carData['mileage'] != null && carData['mileage']!.isNotEmpty)
                        const SizedBox(width: 12),
                      if (carData['mileage'] != null && carData['mileage']!.isNotEmpty)
                        Text(
                          "Пробіг: ${carData['mileage']} км",
                          style: TextStyle(fontSize: 12, color: colors.onSurface.withOpacity(0.7)),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
