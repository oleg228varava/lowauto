import 'package:flutter/material.dart';
import '../models/part.dart';

class PartCard extends StatelessWidget {
  final Part part;
  final VoidCallback onTap;
  final VoidCallback onAdd;

  const PartCard({
    Key? key,
    required this.part,
    required this.onTap,
    required this.onAdd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(part.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(part.brand),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text("${part.price} ₴", style: TextStyle(fontWeight: FontWeight.bold)),
                  Spacer(),
                  ElevatedButton(
                    onPressed: onAdd,
                    child: Text("Додати в кошик"),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
