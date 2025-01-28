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
     final providerRead = context.read<ProductData>();
    return Scaffold(
      appBar: AppBar(
        title:const Text("Order Details"),
      ),
      body: providerRead.orderedItems.isEmpty
          ? Center(child: Text("No items found for this order."))
          : ListView.builder(
              itemCount: providerRead.orderedItems.length,
              itemBuilder: (context, index) {
                final order = providerRead.orderedItems[index];
                return Card(
                  child: ListTile(
                    leading: Image.network(
                      order.thumbnail,
                      width: 100,
                      height: 100,
                    ),
                    title: Text(order.title),
                    subtitle: Row(
                      children: [
                        Text("\$${order.price.toString()}"),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Text(order.category),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomSheet: GestureDetector(
        onTap: () {
          providerRead.logicBottemSheet(widget.orderId);
        },
        child: Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(color: Colors.orange),
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
