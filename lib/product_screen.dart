import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:product_admin/model/product_model.dart';
import 'package:product_admin/user_order.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key, required this.title});

  final String title;

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<Product> products = [];
  final productTitle = TextEditingController();
  final productDiscription = TextEditingController();
  final productPrice = TextEditingController();
  final productImage = TextEditingController();
  final productCategory = TextEditingController();

  bool isUpdate = false;
  int? updateIndex;

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Server Practice"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => OrdersScreen(),
                  ),
                );
            },
            icon: Icon(Icons.shopping_bag_outlined),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: productTitle,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter the product title",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              controller: productDiscription,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter the product discription",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: productPrice,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter the product price",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              controller: productImage,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter the product image url",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: productCategory,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter the product category",
              ),
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          ElevatedButton(
            onPressed: () {
              if (isUpdate) {
                updateData(updateIndex!);
              } else {
                var data = {
                  "title": productTitle.text,
                  "discription": productDiscription.text,
                  "price": productPrice.text,
                  "image": productImage.text,
                  "category": productCategory.text
                };
                postData(data);
              }

              productTitle.clear();
              productPrice.clear();
              productDiscription.clear();
              productImage.clear();
              productCategory.clear();
              isUpdate = false;
              updateIndex = null;
              setState(() {});
            },
            child: Text(isUpdate ? "Update" : "Submit"),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: Image.network(products[index].thumbnail),
                    title: Text(products[index].title),
                    subtitle: Row(
                      children: [
                        Text("\$${products[index].price.toString()}"),
                        const SizedBox(
                          width: 3.0,
                        ),
                        Text(products[index].category),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            productTitle.text = products[index].title;
                            productDiscription.text =
                                products[index].description;
                            productPrice.text =
                                products[index].price.toString();
                            productImage.text = products[index].thumbnail;
                            productCategory.text = products[index].category;

                            isUpdate = true;
                            updateIndex = index;
                            setState(() {});
                          },
                          icon: Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            deleteData(index);
                          },
                          icon: Icon(Icons.delete),
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
    );
  }

  void getData() async {
    const url = "http://192.168.0.110:3000/api/product";
    final response = await http.get(Uri.parse(url));
    final decodeJson = jsonDecode(response.body) as List<dynamic>;
    setState(() {
      products = decodeJson.map((json) => Product.fromJson(json)).toList();
    });
    // debugPrint("products:${decodeJson}");
  }

  void postData(Map<String, dynamic> pdata) async {
    // debugPrint("pdata: $pdata");
    var url = Uri.parse("http://192.168.0.110:3000/api/products");
    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(pdata),
    );
    // debugPrint("Data posted successfully: ${res.body}");
    getData();
  }

  void deleteData(int index) async {
    final idToDelete = products[index].id;

    try {
      final url = Uri.parse("http://192.168.0.110:3000/api/products/$idToDelete");
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        setState(() {
          products.removeAt(index);
        });
      } else {
        debugPrint(
            "Failed to delete data. Status code: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error deleting data: $e");
    }
  }

  void updateData(int index) async {
    final int idToUpdate = products[index].id;

    final url = Uri.parse("http://192.168.0.110:3000/api/products/$idToUpdate");

    await http.patch(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "title": productTitle.text,
        "discription": productDiscription.text,
        "price": productPrice.text,
        "image": productImage.text,
        "category": productCategory.text
      }),
    );

    getData();
  }
}
