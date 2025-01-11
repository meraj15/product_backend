import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:product_admin/order_items.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<dynamic> orders = [];
  List<dynamic> filteredOrders = [];
  DateTime selectedDate = DateTime.now();
String selectedDateString ="";
  @override
  void initState() {
    super.initState();
    getOrdersData();
  }

  void getOrdersData() async {
    const url = "http://localhost:3000/api/userOrders";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final decodeJson = jsonDecode(response.body) as List<dynamic>;
        setState(() {
          orders = decodeJson;
          filterOrders("All");
        });
      } else {
        debugPrint(
            "Failed to fetch orders. Status code: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching orders: $e");
    }
  }

  void filterOrders(String selectedStatus) {
    setState(() {
       selectedDateString = DateFormat('yyyy-MM-dd').format(selectedDate);
      filteredOrders = orders.where((order) {
        final orderDate = order['order_date'] ?? '';
        final isDateMatch = orderDate.startsWith(selectedDateString);
        final isStatusMatch =
            selectedStatus == "All" || order['order_status'] == selectedStatus;
        return isDateMatch && isStatusMatch;
      }).toList();
    });
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      filterOrders("All"); // Reapply the filter after changing the date
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("All Orders"),
          bottom: TabBar(
            indicatorColor: Colors.blue,
            labelColor: Colors.blue,
            isScrollable: true,
            unselectedLabelColor: Colors.grey,
            indicatorWeight: 3,
            onTap: (index) {
              final selectedStatus = getStatusFromTabIndex(index);
              filterOrders(selectedStatus);
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
                    '${filteredOrders.length} orders found',
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                                  icon: const Icon(Icons.calendar_today),
                                  onPressed: () {
                                    selectDate(context);
                                  },
                                ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right:8.0),
                      child: Text(selectedDateString),
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
                itemCount: filteredOrders.length,
                itemBuilder: (context, index) {
                  final order = filteredOrders[index];
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
