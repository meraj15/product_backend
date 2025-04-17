import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
    final theme = Theme.of(context); // Use theme to derive values

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'User Reviews',
          style: TextStyle(color: theme.colorScheme.onPrimary),
        ),
      ),
      backgroundColor: theme.scaffoldBackgroundColor, // Theme-based
      body: provider.productSpecificReviews.isEmpty
          ? Center(
              child: Text(
                "No reviews available",
                style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16) ?? const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            )
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
    final theme = Theme.of(context); // Use theme to derive values
    return Card(
      elevation: 2,
      color: theme.cardColor, // Theme-based
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RatingBarIndicator(
              rating: rating.toDouble(),
              itemBuilder: (context, _) =>const Icon(
                Icons.star,
                color: Colors.amber, // Theme-based
              ),
              itemCount: 5,
              itemSize: 20,
            ),
            const SizedBox(height: 6),
            Text(
              userName,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface, // Theme-based
              ) ?? const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
            ),
            const SizedBox(height: 4),
            Text(
              comment,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7) ?? (theme.brightness == Brightness.dark ? Colors.white70 : Colors.grey[600]),
              ) ??  TextStyle(color: Colors.grey[600]),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor:const Color(0xffdb3022), // Theme-based
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
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface, // Theme-based
                      ) ?? const TextStyle(fontWeight: FontWeight.w500, color: Colors.black87),
                    ),
                    Text(
                      DateTime.parse(timestamp).toString().substring(0, 16),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7) ?? (theme.brightness == Brightness.dark ? Colors.white70 : Colors.grey[600]),
                        fontSize: 12,
                      ) ??  TextStyle(color: Colors.grey[600], fontSize: 12),
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