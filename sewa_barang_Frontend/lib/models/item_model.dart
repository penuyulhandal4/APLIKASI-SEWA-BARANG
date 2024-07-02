class ItemModel {
  final int id;
  final String name;
  final String description;
  final double pricePerDay;
  final String imageUrl;

  ItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.pricePerDay,
    required this.imageUrl,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      pricePerDay: json['pricePerDay'],
      imageUrl: json['imageUrl'],
    );
  }
}
