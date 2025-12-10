class Part {
  final String id;
  final String title;
  final String brand;
  final double price;
  final String category;
  final List<String> compatibleModels;
  final List<String> images;
   // для картинок

  Part({
    required this.id,
    required this.title,
    required this.brand,
    required this.price,
    required this.category,
    required this.compatibleModels,
    this.images = const [],
    
  });
}
