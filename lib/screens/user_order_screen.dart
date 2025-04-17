import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:product_admin/provider/product_provider.dart';
import 'package:product_admin/screens/order_items_screen.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductData>().getOrdersData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final providerRead = Provider.of<ProductData>(context, listen: true);
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Column(
          children: [
            PreferredSize(
              preferredSize: const Size.fromHeight(30.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: TabBar(
                  indicatorColor: Theme.of(context).colorScheme.primary,
                  labelColor: Theme.of(context).colorScheme.primary,
                  isScrollable: true,
                  unselectedLabelColor:
                      Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.7),
                  indicatorWeight: 3,
                  dividerColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                  dividerHeight: 2,
                  onTap: (index) {
                    final selectedStatus = getStatusFromTabIndex(index);
                    context.read<ProductData>().filterOrders(selectedStatus);
                  },
                  tabs: [
                    Tab(
                      child: Text(
                        "All Orders",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Confirm",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Out for Delivery",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Delivered",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Cancelled",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  buildOrdersList(providerRead, "All"),
                  buildOrdersList(providerRead, "Confirm"),
                  buildOrdersList(providerRead, "Out for Delivery"),
                  buildOrdersList(providerRead, "Delivered"),
                  buildOrdersList(providerRead, "Cancelled"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOrdersList(ProductData providerRead, String status) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                !providerRead.isOrdersLoaded
                    ? 'Loading...'
                    : '${providerRead.filteredOrders.length} orders found',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: IconButton(
                    icon: Icon(
                      Icons.calendar_today,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    onPressed: () {
                      context.read<ProductData>().selectDate(context);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    providerRead.selectedDateString,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                    "Order ID",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: Text(
                    "Name",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Center(
                  child: Text(
                    "Address",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: Text(
                    "Mobile",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: Text(
                    "Price",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                    "Time",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: Text(
                    "Status",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    "Actions",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: !providerRead.isOrdersLoaded
              ? Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                )
              : providerRead.filteredOrders.isEmpty
                  ? Center(
                      child: Text(
                        'No Orders Found for $status on ${providerRead.selectedDateString}',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: providerRead.filteredOrders.length,
                      itemBuilder: (context, index) {
                        if (index >= providerRead.filteredOrders.length) {
                          return const SizedBox.shrink();
                        }
                        final order = providerRead.filteredOrders[index];
                        final price = NumberFormat.currency(symbol: "\$").format(
                            double.tryParse(order['price']?.toString() ?? '0') ?? 0);
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => OrderItems(
                                  orderId: order['order_id']?.toString() ?? '-',
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Center(
                                    child: Text(
                                      order['order_id']?.toString() ?? '-',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Center(
                                    child: Text(
                                      order['name']?.toString() ?? '-',
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Center(
                                    child: Text(
                                      order['address']?.toString() ?? '-',
                                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Center(
                                    child: Text(
                                      order['mobile']?.toString() ?? '-',
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Center(
                                    child: Text(
                                      price,
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Center(
                                    child: Text(
                                      order['order_time']?.toString() ?? '-',
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Center(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: _getStatusColor(order['order_status']?.toString(), context),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        order['order_status']?.toString() ?? '-',
                                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                              color: Theme.of(context).colorScheme.onPrimary,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                                if (order['order_status'] != "Delivered" &&
                                    order['order_status'] != "Cancelled")
                                  Expanded(
                                    child: PopupMenuButton<String>(
                                      onSelected: (value) {
                                        if (value == 'Cancel Order') {
                                          providerRead.updateOrderStatus(
                                              order['order_id']?.toString() ?? '-', 'Cancelled');
                                        }
                                      },
                                      iconColor: Theme.of(context).colorScheme.onSurface,
                                      itemBuilder: (context) => [
                                        PopupMenuItem<String>(
                                          value: 'Cancel Order',
                                          child: Text(
                                            'Cancel Order',
                                            style: Theme.of(context).textTheme.bodyMedium,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                else
                                  const Expanded(child: SizedBox.shrink()),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ],
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
      case 4:
        return "Cancelled";
      default:
        return "All";
    }
  }

  Color _getStatusColor(String? status, BuildContext context) {
    final theme = Theme.of(context);
    switch (status?.toLowerCase()) {
      case "confirm":
        return theme.colorScheme.primary.withOpacity(0.8);
      case "out for delivery":
        return Colors.red.withOpacity(0.5);
      case "delivered":
        return Colors.green.withOpacity(0.8);
      case "cancelled":
      case "canceled":
        return Colors.red.withOpacity(0.8);
      default:
        return theme.cardColor;
    }
  }
}