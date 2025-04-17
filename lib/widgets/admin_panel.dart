import 'package:flutter/material.dart';
import 'package:product_admin/screens/analytics.dart';
import 'package:product_admin/screens/product_screen.dart';
import 'package:product_admin/screens/reviews_screen.dart';
import 'package:product_admin/screens/user_order_screen.dart';
import 'package:product_admin/provider/product_provider.dart';
import 'package:provider/provider.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  int selectedSideBar = 1;
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductData>(context, listen: false);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900]! : Colors.grey[100],
      body: Row(
        children: [
          Container(
            width: 270,
            color: isDark ? const Color(0xff303030) : Colors.white,
            child: Column(
              children: [
                const SizedBox(height: 16),
                Row(
                  children: [
                    const SizedBox(width: 22),
                    Text(
                      'AM Admin',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(thickness: 2, color: Colors.grey),
                _buildMenuItem(
                  isSelected: selectedSideBar == 1,
                  title: 'Products',
                  icon: Icons.inventory_2_outlined,
                  onTap: () {
                    setState(() {
                      selectedSideBar = 1;
                    });
                  },
                ),
                _buildMenuItem(
                  isSelected: selectedSideBar == 2,
                  title: 'Orders',
                  icon: Icons.shopping_cart_outlined,
                  onTap: () {
                    setState(() {
                      selectedSideBar = 2;
                    });
                  },
                ),
                _buildMenuItem(
                  isSelected: selectedSideBar == 3,
                  title: 'Reviews',
                  icon: Icons.reviews_outlined,
                  onTap: () {
                    setState(() {
                      selectedSideBar = 3;
                    });
                  },
                ),
                _buildMenuItem(
                  isSelected: selectedSideBar == 4,
                  title: 'Analytics',
                  icon: Icons.analytics_outlined,
                  onTap: () {
                    setState(() {
                      selectedSideBar = 4;
                    });
                  },
                ),
                const Divider(thickness: 2, color: Colors.grey),
                _buildMenuItem(
                  isSelected: selectedSideBar == 5,
                  title: 'Dark Mode',
                  icon: isDark ? Icons.dark_mode : Icons.light_mode,
                  onTap: () {},
                  switchNightOrLightMode: Switch(
                    value: isDarkMode,
                    onChanged: (value) {
                      setState(() {
                        isDarkMode = value;
                      });
                      provider.isDarkMode = value;
                      provider.notifyListeners();
                    },
                    activeColor: isDark ? Colors.white : const Color(0xffdb3022),
                  ),
                ),
              ],
            ),
          ),
          if (selectedSideBar == 1)
            const Expanded(
              child: ProductScreen(),
            ),
          if (selectedSideBar == 2)
            const Expanded(
              child: OrdersScreen(),
            ),
          if (selectedSideBar == 3)
            const Expanded(
              child: ReviewsScreen(),
            ),
          if (selectedSideBar == 4)
            const Expanded(
              child: AnalyticsOrdersScreen(),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? Colors.grey[700]!.withOpacity(0.5) : const Color(0xffdb3022).withOpacity(0.1))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          leading: Icon(
            icon,
            color: isSelected
                ? (isDark ? Colors.white : const Color(0xffdb3022))
                : (isDark ? Colors.white70 : Colors.grey[600]),
            size: 24, // Consistent icon size
          ),
          title: Text(
            title,
            style: TextStyle(
              color: isSelected
                  ? (isDark ? Colors.white : const Color(0xffdb3022))
                  : (isDark ? Colors.white70 : Colors.grey[600]),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          trailing: switchNightOrLightMode,
        ),
      ),
    );
  }
}