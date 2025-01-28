import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:product_admin/EndPoint/endpoint.dart';
import 'package:product_admin/model/product_model.dart';
// ignore: avoid_web_libraries_in_flutter


class ProductData extends ChangeNotifier {
  List<Product> products = [];
  int selectedIndex = -1;
  int productIndex = -1;
  List<dynamic> orders = [];
  List<dynamic> filteredOrders = [];
  DateTime selectedDate = DateTime.now();
  String selectedDateString = "";
  List<Product> orderedItems = [];
  String bottomSheetText = "Out for Delivery";
  String currentOrderStatus = "";
  // List<dynamic> uploadedImages = []; // dynamic can hold both types
  dynamic selectedImage;
  List<Uint8List> newProductImageUrls = [];

  void addImage(Uint8List imageData) {
    newProductImageUrls.add(imageData);
    notifyListeners();
  }

  final productTitle = TextEditingController();
  final productDescription = TextEditingController();
  final productPrice = TextEditingController();
  final productThumbnail = TextEditingController();
  final productCategory = TextEditingController();
  final searchProduct = TextEditingController();
  final productStock = TextEditingController();
  final newProductTitleController = TextEditingController();
  final newProductDescriptionController = TextEditingController();
  final newProductPriceController = TextEditingController();
  final newProductDiscountController = TextEditingController();
  final newProductStockController = TextEditingController();
  final newProductBrandController = TextEditingController();
  final newProductWarrantyController = TextEditingController();
  final newProductShippingInfoController = TextEditingController();
  final newProductAvailabilityStatusController = TextEditingController();
  final newProductReturnPolicyController = TextEditingController();
  final newProductCategoryController = TextEditingController();
  final newProductMinimumOrderQuantityController = TextEditingController();


  Future<void> getData() async {
    final response = await http.get(Uri.parse(APIEndpoint.productGetEndPoint));
    final decodeJson = jsonDecode(response.body) as List<dynamic>;

    products = decodeJson.map((json) => Product.fromJson(json)).toList();
    // debugPrint("products : $products");

    notifyListeners();
  }

  void postNewProduct(Map<String, dynamic> pdata) async {
    var url = Uri.parse(APIEndpoint.postNewProduct);
    await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(pdata),
    );
    getData();

    // Map<String, dynamic> updateProductData = {
    //   'title': newProductTitleController.text,
    //   'description': newProductDescriptionController.text,
    //   'price': double.tryParse(newProductPriceController.text) ?? 0.0,
    //   'thumbnail':
    //       newProductImageUrls.isNotEmpty ? newProductImageUrls.first : '',
    //   'discountpercentage':
    //       double.tryParse(newProductDiscountController.text) ?? 0.0,
    //   'category': newProductCategoryController.text,
    //   'stock': int.tryParse(newProductStockController.text) ?? 0,
    //   'brand': newProductBrandController.text,
    //   'warrantyinformation': newProductWarrantyController.text,
    //   'shippinginformation': newProductShippingInfoController.text,
    //   'availabilitystatus': newProductAvailabilityStatusController.text,
    //   'returnpolicy': newProductReturnPolicyController.text,
    //   'minimumorderquantity':
    //       int.tryParse(newProductMinimumOrderQuantityController.text) ?? 0,
    //   'images': newProductImageUrls,
    // };
  }

  void updateData(int index) async {
    if (index < 0 || index >= products.length) {
      debugPrint("Invalid index for update: $index");
      return;
    }
    final int idToUpdate = products[index].id;
    final url = Uri.parse("${APIEndpoint.updateData}/$idToUpdate");

    try {
      await http.patch(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'title': productTitle.text,
          'description': productDescription.text,
          'price': double.tryParse(productPrice.text) ?? 0.0,
          'thumbnail': productThumbnail.text,
          'category': productCategory.text,
          'stock': int.tryParse(productStock.text) ?? 0,
        }),
      );
      getData();
      selectedIndex = -1;
      notifyListeners();
    } catch (e) {
      debugPrint("Error updating product: $e");
    }
  }

  void getOrdersData() async {
    try {
      final response = await http.get(Uri.parse(APIEndpoint.getOrdersData));
      if (response.statusCode == 200) {
        final decodeJson = jsonDecode(response.body) as List<dynamic>;

        orders = decodeJson;
        filterOrders("All");
        notifyListeners();
      } else {
        debugPrint(
            "Failed to fetch orders. Status code: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching orders: $e");
    }
  }

  void filterOrders(String selectedStatus) {
    selectedDateString = DateFormat('yyyy-MM-dd').format(selectedDate);
    filteredOrders = orders.where((order) {
      final orderDate = order['order_date'] ?? '';
      final isDateMatch = orderDate.startsWith(selectedDateString);
      final isStatusMatch =
          selectedStatus == "All" || order['order_status'] == selectedStatus;
      return isDateMatch && isStatusMatch;
    }).toList();
    notifyListeners();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      notifyListeners();
      filterOrders("All");
    }
  }

  void fetchOrderStatus(String orderId) async {
    final url = "${APIEndpoint.fetchOrderStatus}/$orderId";
    try {
      final response = await http.get(Uri.parse(url));
      final decodedJson = jsonDecode(response.body);
      debugPrint("decodedJson : $decodedJson");
      currentOrderStatus = decodedJson['order_status'] ?? "";
      bottomSheetText =
          currentOrderStatus == "Delivered" ? "Delivered" : "Out for Delivery";
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching order status: $e");
    }
  }

  void logicBottemSheet(String orderId) {
    if (currentOrderStatus == "Confirm") {
      bottomSheetText = "Delivered";
      updateOrderStatus(orderId, "Out for Delivery");
      notifyListeners();
    }
    if (currentOrderStatus == "Out for Delivery") {
      bottomSheetText = "Delivered";
      currentOrderStatus = "Delivered";
      updateOrderStatus(orderId, "Delivered");
      notifyListeners();
    } else if (currentOrderStatus == "Delivered") {
      bottomSheetText = "Out for Delivery";
      currentOrderStatus = "Out for Delivery";
      updateOrderStatus(orderId, "Out for Delivery");
      notifyListeners();
    } else {
      debugPrint("Unexpected order status: $currentOrderStatus");
    }
  }

  void updateOrderStatus(String orderId, String newStatus) async {
    final url = "${APIEndpoint.updateOrderStatus}/$orderId";
    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode({"order_status": newStatus});
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: body,
      );
      if (response.statusCode == 200) {
        debugPrint("Order status successfully updated to $newStatus");
        currentOrderStatus = newStatus;
        notifyListeners();
      } else {
        debugPrint(
            "Failed to update order status. Status code: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error updating order status: $e");
    }
  }

  void getOrderItems(String orderId) async {
    final url = "${APIEndpoint.getOrderItems}/$orderId";
    final response = await http.get(Uri.parse(url));
    final decodeJson = jsonDecode(response.body) as List<dynamic>;

    orderedItems = decodeJson.map((json) => Product.fromJson(json)).toList();
    notifyListeners();
  }


}
