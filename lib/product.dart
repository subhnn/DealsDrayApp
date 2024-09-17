class Product {
  final String icon;
  final String offer;
  final String label;
  final String subLabel;

  Product({
    required this.icon,
    required this.offer,
    required this.label,
    required this.subLabel,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      icon: json['icon'] ?? '',
      offer: json['offer'] ?? '',
      label: json['label'] ?? '',
      subLabel: json['Sublabel'] ?? '',  // Handle key name inconsistencies
    );
  }
}
