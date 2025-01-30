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
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Admin Panel',
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xfff9f9f9),
          colorScheme: const ColorScheme.light(primary: Color(0xffdb3022)),
        ),
        home:const SideBar(),
      ),
    );
  }
}
