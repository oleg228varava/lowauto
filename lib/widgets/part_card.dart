import 'package:flutter/material.dart';
import '../models/part.dart';

class PartCard extends StatelessWidget {
  final Part part;
  final VoidCallback onOpen;
  final VoidCallback onAdd;

  const PartCard({
    Key? key,
    required this.part,
    required this.onOpen,
    required this.onAdd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 3,
      child: InkWell(
        onTap: onOpen,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Картинка / іконка
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: colorScheme.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: part.images.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Icon(
                          Icons.car_repair,
                          size: 60,
                          color: colorScheme.onSurface.withOpacity(0.5),
                        ),
                      )
                    : Icon(
                        Icons.car_repair,
                        size: 60,
                        color: colorScheme.onSurface.withOpacity(0.3),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Назва запчастини
                    Text(
                      part.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyLarge
                          ?.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    // Бренд
                    Text(
                      part.brand,
                      style: theme.textTheme.bodyMedium?.copyWith(fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    // Сумісні моделі
                    Text(
                      'Сумісні моделі: ${part.compatibleModels.join(", ")}',
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Ціна
                        Text(
                          '${part.price.toInt()} ₴',
                          style: theme.textTheme.bodyLarge
                              ?.copyWith(color: Colors.redAccent, fontWeight: FontWeight.bold),
                        ),
                        // Кнопка додати в кошик
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: ElevatedButton(
                            onPressed: onAdd,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Icon(
                              Icons.add_shopping_cart,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
