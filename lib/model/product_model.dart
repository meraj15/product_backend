class Product {
  int id;
  String title;
  String description;
  num price;
  String image;
  String category;

  Product({
    required this.description,
    required this.id,
    required this.image,
    required this.price,
    required this.title,
    required this.category,
  });

  factory Product.fromJson(Map product) {
    return Product(
      description: product["description"] ?? "",
      id: product['id'] ?? 0,
      image: product['image'] ?? "",
      price: product["price"] ?? 0,
      title: product["title"] ?? "",
      category: product["category"] ?? "",
    );
  }
}

//"http://192.168.0.110:3000/api/userOrders"
