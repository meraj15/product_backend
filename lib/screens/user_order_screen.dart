import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:product_admin/provider/product_provider.dart';
import 'package:product_admin/screens/order_items_screen.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
 
  @override
  void initState() {
    super.initState();
    context.read<ProductData>().getOrdersData();
  }

  

  @override
  Widget build(BuildContext context) {
     final providerRead = context.read<ProductData>();
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
              title: Text("All Orders", style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w500)),
          bottom: TabBar(
            indicatorColor: Theme.of(context).colorScheme.primary,
            labelColor: Theme.of(context).colorScheme.primary,
            isScrollable: true,
            unselectedLabelColor: Colors.grey,
            indicatorWeight: 3,
            onTap: (index) {
              final selectedStatus = getStatusFromTabIndex(index);
              context.read<ProductData>().filterOrders(selectedStatus);
            },
            tabs: const [
              Tab(text: "All Orders"),
              Tab(text: "Confirm"),
              Tab(text: "Out for Delivery"),
              Tab(text: "Delivered"),
            ],
          ),
          
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    '${providerRead.filteredOrders.length} orders found',
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical:8.0),
                      child: IconButton(
                                  icon: const Icon(Icons.calendar_today),
                                  onPressed: () {
                                    context.read<ProductData>().selectDate(context);
                                  },
                                ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right:8.0),
                      child: Text(providerRead.selectedDateString),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xfff9f9f9),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: const [
                  Expanded(flex: 1, child: Center(child: Text("Order ID"))),
                  Expanded(flex: 2, child: Center(child: Text("Name"))),
                  Expanded(flex: 3, child: Center(child: Text("Address"))),
                  Expanded(flex: 2, child: Center(child: Text("Date"))),
                  Expanded(flex: 2, child: Center(child: Text("Price"))),
                  Expanded(flex: 2, child: Center(child: Text("Status"))),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: providerRead.filteredOrders.length,
                itemBuilder: (context, index) {
                  final order = providerRead.filteredOrders[index];
                  final price = NumberFormat.currency(symbol: "\u20B9")
                      .format(double.tryParse(order['price']?.toString() ?? '0'));
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => OrderItems(
                            orderId: order['order_id'],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: Text(
                                order['order_id'] ?? '-',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Text(
                                order['name'] ?? '-',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Center(
                              child: Text(
                                order['address'] ?? '-',
                                style: const TextStyle(
                                    fontSize: 14,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Text(
                                order['order_date'] ?? '-',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Text(
                                price,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      _getStatusColor(order['order_status']),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  order['order_status'] ?? '-',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getStatusFromTabIndex(int index) {
    switch (index) {
      case 1:
        return "Confirm";
      case 2:
        return "Out for Delivery";
      case 3:
        return "Delivered";
      default:
        return "All";
    }
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case "Confirm":
        return Colors.orange;
      case "Out for Delivery":
        return Colors.blue;
      case "Delivered":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
