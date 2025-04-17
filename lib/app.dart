import 'package:flutter/material.dart';
import 'package:product_admin/provider/product_provider.dart';
import 'package:product_admin/widgets/admin_panel.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductData(),
      child: Consumer<ProductData>(
        builder: (context, productData, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'AM Admin Panel',
            theme: ThemeData(
              scaffoldBackgroundColor: const Color(0xfff9f9f9),
              colorScheme: const ColorScheme.light(
                primary: Color(0xffdb3022),
                onPrimary: Colors.white,
                surface: Color(0xfff9f9f9),
                onSurface: Colors.black87,
              ),
              textTheme: const TextTheme(
                bodyMedium: TextStyle(color: Colors.black87, fontSize: 16),
                headlineSmall: TextStyle(
                    color: Colors.black87, fontWeight: FontWeight.bold),
              ),
              cardColor: Colors.white,
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffdb3022),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Color(0xffdb3022)), // Red border in light mode
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  elevation: 4,
                ),
              ),
              outlinedButtonTheme: OutlinedButtonThemeData(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xffdb3022)), // Red border in light mode
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  foregroundColor: Colors.black87, // Black87 text in light mode
                ),
              ),
            ),
            darkTheme: ThemeData(
              scaffoldBackgroundColor: Colors.grey[900]!,
              colorScheme:  ColorScheme.dark(
                primary: Colors.grey[800]!,
                onPrimary: Colors.white,
                surface: Colors.grey[900]!,
                onSurface: Colors.white, // White in dark mode
              ),
              textTheme: const TextTheme(
                bodyMedium: TextStyle(color: Colors.white70, fontSize: 16),
                headlineSmall: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              cardColor: Color(0xff303030),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff303030),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.white), // White border in dark mode
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  elevation: 4,
                ),
              ),
              outlinedButtonTheme: OutlinedButtonThemeData(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white, width: 2), // Thicker white border in dark mode
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Adjusted padding
                  foregroundColor: Colors.white, // White text in dark mode
                ),
              ),
            ),
            themeMode: productData.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const SideBar(),
          );
        },
      ),
    );
  }
}