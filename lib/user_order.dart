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
  String selectedStatus = "All";
  DateTime selectedDate = DateTime.now(); 

  @override
  void initState() {
    super.initState();
    getOrdersData();
  }

  // Fetch orders from API
  void getOrdersData() async {
    const url = "http://192.168.0.110:3000/api/userOrders";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final decodeJson = jsonDecode(response.body) as List<dynamic>;
        setState(() {
          orders = decodeJson;
          filterOrders(); 
        });
      } else {
        debugPrint(
            "Failed to fetch orders. Status code: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching orders: $e");
    }
  }

  
  void filterOrders() {
    setState(() {
      final selectedDateString = DateFormat('yyyy-MM-dd').format(selectedDate);
      filteredOrders = orders.where((order) {
        final orderDate = order['order_date'];
        final isDateMatch = orderDate == selectedDateString;
        final isStatusMatch = selectedStatus == "All" ||
            order['order_status'] == selectedStatus;
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
        filterOrders(); 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All orders"),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              selectDate(context);
            },
          ),
          DropdownButton<String>(
            value: selectedStatus,
            items: const [
              DropdownMenuItem(
                value: "All",
                child: Text("All"),
              ),
              DropdownMenuItem(
                value: "Confirm",
                child: Text("Confirm"),
              ),
              DropdownMenuItem(
                value: "Out for Delivery",
                child: Text("Out for Delivery"),
              ),
              DropdownMenuItem(
                value: "Delivered",
                child: Text("Delivered"),
              ),
            ],
            onChanged: (newValue) {
              if (newValue != null) {
                setState(() {
                  selectedStatus = newValue;
                  filterOrders(); // Filter orders based on the new status
                });
              }
            },
          ),
        ],
      ),
      body: filteredOrders.isEmpty
          ? const Center(child: Text("No orders found."))
          : ListView.builder(
              itemCount: filteredOrders.length,
              itemBuilder: (context, index) {
                final order = filteredOrders[index];
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
                  child: Card(
                    margin: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Name: ${order['name']}",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          Text("Price: ₹${order['price']}",
                              style: const TextStyle(fontSize: 16)),
                          Text("Address: ${order['address']}",
                              style: const TextStyle(fontSize: 16)),
                          Text("Mobile: ${order['mobile']}",
                              style: const TextStyle(color: Colors.blue)),
                          Text("Status: ${order['order_status']}",
                              style: const TextStyle(fontSize: 14)),
                          Text("Date: ${order['order_date']}",
                              style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
