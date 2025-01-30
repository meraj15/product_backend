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
    debugPrint("providerRead.orderedItems : ${providerRead.orderedItems}");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text(
          "User Order Products",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: providerRead.orderedItems.isEmpty
          ? Center(child: Text("No items found for this order."))
          : Container(
              margin: EdgeInsets.all(20),
              child: ListView.builder(
                itemCount: providerRead.orderedItems.length,
                itemBuilder: (context, index) {
                  final product = providerRead.orderedItems[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                    ),
                    padding:const EdgeInsets.symmetric(horizontal: 8),
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
                            ),
                          ),
                        ),
                        SizedBox(width: 10),

                        // Product Details
                        Expanded(
                          child: Text(
                            product.title,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                'Price',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey),
                              ),
                              Text(
                                '\$${product.price.toStringAsFixed(2)}',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                'Quantity',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey),
                              ),
                              Text(
                                '${product.quantity}',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                'Total Price',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey),
                              ),
                              Text(
                                '\$${(product.price * product.quantity).toStringAsFixed(2)}',
                                style: TextStyle(fontWeight: FontWeight.w500),
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
          providerRead.logicBottemSheet(widget.orderId);
        },
        child: Container(
          width: double.infinity,
          height: 50,
          decoration:
              BoxDecoration(color: Theme.of(context).colorScheme.primary),
          child: Center(
              child: Text(
            providerRead.bottomSheetText,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          )),
        ),
      ),
    );
  }
}
