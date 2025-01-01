class Product {
  int id;
  String title;
  String description;
  num price;
  String thumbnail;
  String category;

  Product({
    required this.description,
    required this.id,
    required this.thumbnail,
    required this.price,
    required this.title,
    required this.category,
  });

  factory Product.fromJson(Map product) {
    return Product(
      description: product["description"] ?? "",
      id: product['id'] ?? 0,
      thumbnail: product['thumbnail'] ?? "",
      price: product["price"] ?? 0,
      title: product["title"] ?? "",
      category: product["category"] ?? "",
    );
  }
}

//"http://192.168.0.110:3000/api/userOrders"
