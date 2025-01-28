
import 'package:flutter/material.dart';
import 'package:product_admin/screens/product_screen.dart';
import 'package:product_admin/screens/user_order_screen.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const ProductScreen(),
    const OrdersScreen(),
    const Center(child: Text('Reviews Content')),
    const Center(child: Text('Settings Content')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // NavigationRail
          NavigationRail(
            backgroundColor:const Color(0xfff9f9f9),
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            indicatorColor: const Color(0xffdb3022),
            leading: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                'Admin',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
            ),
            selectedIconTheme: const IconThemeData(color: Colors.white),
            unselectedIconTheme: IconThemeData(color: Colors.grey.shade600),
            selectedLabelTextStyle: const TextStyle(
              color: Color(0xffdb3022),
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelTextStyle: TextStyle(
              color: Colors.grey.shade600,
            ),
            destinations: const [
              NavigationRailDestination(
                padding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
                icon: Icon(Icons.inventory),
                selectedIcon: Icon(Icons.inventory_2),
                label: Text('Products'),
              ),
              NavigationRailDestination(

                icon: Icon(Icons.shopping_bag_outlined),
                selectedIcon: Icon(Icons.shopping_bag),
                label: Text('Orders'),
              ),
              NavigationRailDestination(
                padding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),

                icon: Icon(Icons.reviews_outlined),
                selectedIcon: Icon(Icons.reviews),
                label: Text('Reviews'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // Main Content
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _pages[_selectedIndex],
              ),
            ),
          ),
        ],
      ),
    );
  }

}
