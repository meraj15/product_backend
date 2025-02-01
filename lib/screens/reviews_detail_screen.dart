import 'package:flutter/material.dart';
import 'package:product_admin/provider/product_provider.dart';
import 'package:provider/provider.dart';

class ReviewScreen extends StatefulWidget {
  final int productId;
  const ReviewScreen({super.key, required this.productId});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductData>().getReviews(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductData>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'User Reviews',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: provider.productSpecificReviews.isEmpty
          ? const Center(child: Text("No reviews available"))
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Responsive grid
                childAspectRatio: 2.5,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),
              itemCount: provider.productSpecificReviews.length,
              itemBuilder: (context, index) {
                final reviews = provider.productSpecificReviews[index];

                return ReviewCard(
                  rating: reviews["rating"] ?? 0,
                  userName: reviews["reviewer_name"] ?? 'Unknown',
                  comment: reviews["comment"] ?? 'No comment',
                  reviewerInitial:
                      (reviews["reviewer_name"]?.isNotEmpty ?? false)
                          ? reviews["reviewer_name"]![0].toUpperCase()
                          : 'U',
                  reviewerName: reviews["reviewer_name"] ?? 'Unknown',
                  timestamp:
                      reviews["timestamp"] ?? DateTime.now().toIso8601String(),
                );
              },
            ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  final int rating;
  final String userName;
  final String comment;
  final String reviewerInitial;
  final String reviewerName;
  final String timestamp;

  const ReviewCard({
    super.key,
    required this.rating,
    required this.userName,
    required this.comment,
    required this.reviewerInitial,
    required this.reviewerName,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StarRating(rating: rating),
            const SizedBox(height: 6),
            Text(
              userName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              comment,
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: 16,
                  child: Text(
                    reviewerInitial,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reviewerName,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      DateTime.parse(timestamp).toString().substring(0, 16),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StarRating extends StatelessWidget {
  final int rating;

  const StarRating({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 20,
        );
      }),
    );
  }
}
