import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:product_admin/model/product_model.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<Product> products = [];
  final productTitle = TextEditingController();
  final productDescription = TextEditingController();
  final productPrice = TextEditingController();
  final productThumbnail = TextEditingController();
  final productCategory = TextEditingController();
  final searchProduct = TextEditingController();

  int selectedIndex = -1;
  int productIndex = -1;

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 1100;

    // Apply filter logic
    final filterProduct = searchProduct.text.isEmpty
        ? products
        : products.where((product) {
            final searchText = searchProduct.text.toLowerCase();
            return product.title.toLowerCase().contains(searchText) ||
                product.category.toLowerCase().contains(searchText);
          }).toList();

    return Row(
      children: [
        // Left Side: Product List
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Products',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchProduct,
                        decoration: InputDecoration(
                          hintText: 'Search product...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      height: 40,
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary),
                        label: const Text(
                          'Add New Product',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 250,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 3 / 4,
                    ),
                    itemCount: filterProduct.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          productTitle.text = products[index].title;
                          productDescription.text = products[index].description;
                          productPrice.text = products[index].price.toString();
                          productThumbnail.text = products[index].thumbnail;
                          productCategory.text = products[index].category;
                          setState(() {
                            selectedIndex = index;
                            productIndex = index;
                          });
                        },
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              color: selectedIndex == index
                                  ? Colors.red
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Container(
                                      width: double
                                          .infinity, // Take full width of the card
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color(0xfff3f3f3),
                                      ),
                                      child: Image.network(
                                        filterProduct[index].thumbnail,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                      filterProduct[index].title,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                      '\$ ${filterProduct[index].price}',
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                      'Stock: ${filterProduct[index].stock}',
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                ],
                              ),

                              if (isSmallScreen && selectedIndex == index)
                                Positioned(
                                  right: 5,
                                  top: 5,
                                  child: IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.black),
                                    onPressed: () {
                                      showEditDialog(filterProduct[index]);
                                    },
                                  ),
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
          ),
        ),
        // Right Side: Edit Product Details (only for larger screens)
        if (!isSmallScreen)
          Expanded(
            flex: 1,
            child: Container(
              color:const Color(0xfff3f3f3),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Edit Products',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView(
                        children: [
                          const Text(
                            'Description',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: productTitle,
                            decoration: InputDecoration(
                              labelText: 'Product Name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: productDescription,
                            decoration: InputDecoration(
                              labelText: 'Product Description',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: productPrice,
                            decoration: InputDecoration(
                              labelText: 'Product Price',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: productThumbnail,
                            decoration: InputDecoration(
                              labelText: 'Product Thumbnail',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: productCategory,
                            decoration: InputDecoration(
                              labelText: 'Product Category',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: 33,
                                width: 120,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    productTitle.clear();
                                    productPrice.clear();
                                    productDescription.clear();
                                    productThumbnail.clear();
                                    productCategory.clear();
                                    selectedIndex = -1;
                                    setState(() {});
                                  },
                                  icon: const Icon(
                                    Icons.cancel,
                                    color: Colors.black,
                                  ),
                                  style: ElevatedButton.styleFrom(),
                                  label: const Text(
                                    'Discard',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 35,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    updateData(productIndex);
                                    productTitle.clear();
                                    productPrice.clear();
                                    productDescription.clear();
                                    productThumbnail.clear();
                                    productCategory.clear();
                                    selectedIndex = -1;
                                    setState(() {});
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                  label: const Text(
                                    'Update Product',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      
      ],
    );
  }

  void getData() async {
    const url = "http://localhost:3000/api/products";
    final response = await http.get(Uri.parse(url));
    final decodeJson = jsonDecode(response.body) as List<dynamic>;
    setState(() {
      products = decodeJson.map((json) => Product.fromJson(json)).toList();
    });
  }

  void showEditDialog(Product product) {
    productTitle.text = product.title;
    productDescription.text = product.description;
    productPrice.text = product.price.toString();
    productThumbnail.text = product.thumbnail;
    productCategory.text = product.category;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Product'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: productTitle,
                    decoration:
                        const InputDecoration(labelText: 'Product Name'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: productDescription,
                    decoration:
                        const InputDecoration(labelText: 'Product Description'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: productPrice,
                    decoration:
                        const InputDecoration(labelText: 'Product Price'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: productThumbnail,
                    decoration:
                        const InputDecoration(labelText: 'Product Thumbnail'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: productCategory,
                    decoration:
                        const InputDecoration(labelText: 'Product Category'),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                updateData(products.indexOf(product));
                Navigator.of(context).pop();
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void postData(Map<String, dynamic> pdata) async {
    var url = Uri.parse("http://localhost:3000/api/products");
    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(pdata),
    );
    getData();
  }

  void deleteData(int index) async {
    final idToDelete = products[index].id;

    try {
      final url = Uri.parse("http://localhost:3000/api/products/$idToDelete");
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

    final url = Uri.parse("http://localhost:3000/api/products/$idToUpdate");

    final res = await http.patch(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "title": productTitle.text,
        "description": productDescription.text,
        "price": productPrice.text,
        "thumbnail": productThumbnail.text,
        "category": productCategory.text
      }),
    );
    debugPrint("Data updated successfully: ${res.body}");
    getData();
  }
}
