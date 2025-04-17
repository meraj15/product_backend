import 'package:flutter/material.dart';

class AnalyticsOrdersScreen extends StatefulWidget {
  const AnalyticsOrdersScreen({super.key});

  @override
  State<AnalyticsOrdersScreen> createState() => __AnalyticsOrdersScreenState();
}

class __AnalyticsOrdersScreenState extends State<AnalyticsOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child:  Text(
          "Analytics not available now , it will available soon !!",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
