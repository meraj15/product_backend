import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:product_admin/provider/product_provider.dart';
import 'package:product_admin/screens/reviews_detail_screen.dart';
import 'package:provider/provider.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchReviews();
  }

  Future<void> fetchReviews() async {
    final provider = context.read<ProductData>();
    await provider.getAllReviews(); // Fetch all reviews once
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductData>();
    final theme = Theme.of(context); // Use theme to derive values

    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: theme.colorScheme.primary,
        ),
      );
    }

    final products = provider.products;
    final reviews = provider.productAllReviews;

    final reviewedProducts = products.where((product) {
      return reviews.any((review) => review['product_id'] == product.id);
    }).toList();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // Theme-based
      body: reviewedProducts.isEmpty
          ? Center(
              child: Text(
                "No products with reviews available",
                style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16) ?? const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            )
          : ListView.builder(
              itemCount: reviewedProducts.length,
              itemBuilder: (context, index) {
                final product = reviewedProducts[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            ReviewScreen(productId: product.id),
                      ),
                    );
                  },
                  child: ProductCard(
                    product: product,
                    rating: reviews[index]['rating'],
                  ),
                );
              },
            ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final dynamic product;
  final double rating;

  const ProductCard({super.key, required this.product, required this.rating});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Use theme to derive values
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor, // Theme-based
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: theme.brightness == Brightness.dark ? Colors.black26 : Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              product.thumbnail,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.error, size: 80);
              },
            ),
          ),
          const SizedBox(width: 12),
          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onPrimary, // Theme-based
                  ) ?? const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xffdb3022)),
                ),
                const SizedBox(height: 4),
                Text(
                  product.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7) ?? (theme.brightness == Brightness.dark ? Colors.white70 : Colors.grey),
                  ) ?? const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                // Reviews Link
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            ReviewScreen(productId: product.id),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.brightness == Brightness.dark ? theme.colorScheme.primary : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'See All Reviews',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 12,
                        color: theme.brightness == Brightness.dark ? theme.colorScheme.onSurface : Colors.red.shade700,
                      ) ??  TextStyle(fontSize: 12, color: Colors.red.shade700),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                RatingBarIndicator(
                  rating: rating.toDouble(),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  itemCount: 5,
                  itemSize: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}