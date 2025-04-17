import 'package:flutter/material.dart';
import 'package:product_admin/provider/product_provider.dart';
import 'package:provider/provider.dart';

class OrderItems extends StatefulWidget {
  final String orderId;

  const OrderItems({super.key, required this.orderId});

  @override
  State<OrderItems> createState() => _OrderItemsState();
}

class _OrderItemsState extends State<OrderItems> {
  @override
  void initState() {
    super.initState();
    context.read<ProductData>().getOrderItems(widget.orderId);
    context.read<ProductData>().fetchOrderStatus(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    final providerRead = context.watch<ProductData>();
    final theme = Theme.of(context); // Use theme to derive values
    debugPrint("providerRead.orderedItems : ${providerRead.orderedItems}");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        title: Text(
          "User Order Products",
          style: TextStyle(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        iconTheme: IconThemeData(
          color: theme.colorScheme.onPrimary,
        ),
      ),
      backgroundColor: theme.scaffoldBackgroundColor, // Theme-based
      body: providerRead.orderedItems.isEmpty
          ? Center(
              child: Text(
                "No items found for this order.",
                style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16) ?? const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            )
          : Container(
              margin: const EdgeInsets.all(20),
              child: ListView.builder(
                itemCount: providerRead.orderedItems.length,
                itemBuilder: (context, index) {
                  final product = providerRead.orderedItems[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: theme.cardColor, // Theme-based
                      border: Border(
                        bottom: BorderSide(
                          color: theme.brightness == Brightness.dark ? theme.cardColor : Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        // Product Image
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              product.thumbnail,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.error, size: 100);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Product Details
                        Expanded(
                          child: Text(
                            product.title,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: theme.colorScheme.onSurface, // Theme-based
                            ) ?? const TextStyle(fontWeight: FontWeight.w500, color: Colors.black87),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                'Price',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7) ?? (theme.brightness == Brightness.dark ? Colors.white70 : Colors.grey),
                                ) ?? const TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),
                              ),
                              Text(
                                '\$${product.price.toStringAsFixed(2)}',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: theme.colorScheme.onSurface, // Theme-based
                                ) ?? const TextStyle(fontWeight: FontWeight.w500, color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                'Quantity',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7) ?? (theme.brightness == Brightness.dark ? Colors.white70 : Colors.grey),
                                ) ?? const TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),
                              ),
                              Text(
                                '${product.quantity}',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: theme.colorScheme.onSurface, // Theme-based
                                ) ?? const TextStyle(fontWeight: FontWeight.w500, color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                'Total Price',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7) ?? (theme.brightness == Brightness.dark ? Colors.white70 : Colors.grey),
                                ) ?? const TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),
                              ),
                              Text(
                                '\$${(product.price * product.quantity).toStringAsFixed(2)}',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: theme.colorScheme.onSurface, // Theme-based
                                ) ?? const TextStyle(fontWeight: FontWeight.w500, color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
      bottomSheet: GestureDetector(
        onTap: () {
          providerRead.logicBottomSheet(widget.orderId);
        },
        child: Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
          ),
          child: Center(
            child: Text(
              providerRead.bottomSheetText,
              style: TextStyle(
                fontSize: 16,
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}