import 'package:flutter/material.dart';
import 'package:product_admin/screens/product_screen.dart';
import 'package:product_admin/screens/reviews_screen.dart';
import 'package:product_admin/screens/user_order_screen.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  int selectedSideBar = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Row(
        children: [
          Container(
            width: 270,
            color: Colors.white,
            child: Column(
              children: [
                const SizedBox(height: 16),
                // Logo
                const Row(
                  children: [
                    SizedBox(width: 22),
                    Text(
                      'AM Admin',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(thickness: 2,color: Colors.grey,),
                _buildMenuItem(
                    isSelected: selectedSideBar == 1,
                    title: 'Products',
                    icon: Icons.inventory_2_outlined,
                    onTap: () {
                      selectedSideBar = 1;
                      setState(() {});
                    }),
                _buildMenuItem(
                    isSelected: selectedSideBar == 2,
                    title: 'Orders',
                    icon: Icons.shopping_cart_outlined,
                    onTap: () {
                      selectedSideBar = 2;
                      setState(() {});
                    }),
                _buildMenuItem(
                    isSelected: selectedSideBar == 3,
                    title: 'Reviews',
                    icon: Icons.reviews_outlined,
                    onTap: () {
                      selectedSideBar = 3;
                      setState(() {});
                    }),
                   const Divider(thickness: 2,color: Colors.grey,),
                _buildMenuItem(
                  isSelected: selectedSideBar == 4,
                  title: 'Dark Mode',
                  icon: Icons.dark_mode_outlined,
                  onTap: () {
                    selectedSideBar = 4;
                    setState(() {});
                  },
                  switchNightOrLightMode: Switch(
                    value: false,
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
          ),
          if (selectedSideBar == 1)
            Expanded(
              child: ProductScreen(),
            ),
          if (selectedSideBar == 2)
            Expanded(
              child: OrdersScreen(),
            ),
          if (selectedSideBar == 3)
            Expanded(
              child: ReviewsScreen(),
            ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required bool isSelected,
    Switch? switchNightOrLightMode,
  }) {
    return InkWell(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xffdb3022).withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          onTap: onTap,
          leading: Icon(
            icon,
            color: isSelected ? const Color(0xffdb3022) : Colors.grey[600],
          ),
          title: Text(
            title,
            style: TextStyle(
              color: isSelected ? const Color(0xffdb3022) : Colors.grey[600],
            ),
          ),
          selected: isSelected,
          trailing: switchNightOrLightMode,
        ),
      ),
    );
  }
}