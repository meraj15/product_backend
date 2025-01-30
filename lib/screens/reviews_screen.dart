import 'package:flutter/material.dart';
import 'package:product_admin/provider/product_provider.dart';
import 'package:product_admin/screens/reviews_detail_screen.dart';
import 'package:provider/provider.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = context.read<ProductData>();

    // Filter products that have reviews
    final reviewedProducts = provider.products;

    return Scaffold(
      body: reviewedProducts.isEmpty
          ? const Center(child: Text("No products with reviews available"))
          : ListView.builder(
              itemCount: reviewedProducts.length,
              itemBuilder: (context, index) {
                final product = reviewedProducts[index]; // ✅ Correct variable name

                return Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
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
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              product.description,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Reviews Link (Pass correct product ID)
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ReviewScreen(productId: product.id), // ✅ Dynamic product ID
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'See All Reviews',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.red.shade700,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Rating Stars
                            Row(
                              children: [
                                Text(
                                  'RATING: ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                ...List.generate(5, (index) {
                                  return const Icon(
                                    Icons.star_border_outlined,
                                    color: Colors.amber,
                                    size: 16,
                                  );
                                }),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
