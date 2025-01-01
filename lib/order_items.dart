import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:product_admin/model/product_model.dart';
import 'package:http/http.dart' as http;

class OrderItems extends StatefulWidget {
  final String orderId;

  const OrderItems({super.key, required this.orderId});

  @override
  State<OrderItems> createState() => _OrderItemsState();
}

class _OrderItemsState extends State<OrderItems> {
  List<Product> orderedItems = [];
  String bottomSheetText = "Out for Delivery";
  String currentOrderStatus = "";

  @override
  void initState() {
    super.initState();
    getOrderItems(widget.orderId);
    fetchOrderStatus(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Details"),
      ),
      body: orderedItems.isEmpty
          ? Center(child: Text("No items found for this order."))
          : ListView.builder(
              itemCount: orderedItems.length,
              itemBuilder: (context, index) {
                final order = orderedItems[index];
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
          logicBottemSheet();
        },
        child: Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(color: Colors.orange),
          child: Center(
              child: Text(
            bottomSheetText,
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

  void fetchOrderStatus(String orderId) async {
    final url = "http://192.168.0.110:3000/api/orders/status/$orderId";
    final response = await http.get(Uri.parse(url));
    final decodedJson = jsonDecode(response.body);
    debugPrint("decodedJson : $decodedJson");
    setState(() {
      currentOrderStatus = decodedJson['order_status'] ?? "";
      bottomSheetText =
          currentOrderStatus == "Delivered" ? "Delivered" : "Out for Delivery";
    });
  }

  void logicBottemSheet() {
    if (bottomSheetText == "Out for Delivery") {
      setState(() {
        bottomSheetText = "Delivered";
      });
      updateOrderStatus(widget.orderId, "Out for Delivery");
    } else if (bottomSheetText == "Delivered") {
      setState(() {
        bottomSheetText = "Delivered";
      });
      updateOrderStatus(widget.orderId, "Delivered");
    }
  }

  void updateOrderStatus(String orderId, String newStatus) async {
    final url = "http://192.168.0.110:3000/api/orders/$orderId";
    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode({"order_status": newStatus});
    await http.put(
      Uri.parse(url),
      headers: headers,
      body: body,
    );
  }

  void getOrderItems(String orderId) async {
    final url = "http://192.168.0.110:3000/api/orderitems/$orderId";
    final response = await http.get(Uri.parse(url));
    final decodeJson = jsonDecode(response.body) as List<dynamic>;
    setState(() {
      orderedItems = decodeJson.map((json) => Product.fromJson(json)).toList();
    });
  }
}
