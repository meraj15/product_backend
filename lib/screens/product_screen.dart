import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:product_admin/provider/product_provider.dart';
import 'package:product_admin/screens/add_cart_screen.dart';
import 'package:product_admin/model/product_model.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  void initState() {
    loadData();
    super.initState();
  }

  void loadData() async {
    await context.read<ProductData>().getData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 1100;
    final providerRead = context.read<ProductData>();
    // Apply filter logic
    final filterProduct = providerRead.searchProduct.text.isEmpty
        ? providerRead.products
        : providerRead.products.where((product) {
            final searchText = providerRead.searchProduct.text.toLowerCase();
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
                        controller: providerRead.searchProduct,
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
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>  AddNewProduct()),
                          );
                        },
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
                          providerRead.productTitle.text =
                              providerRead.products[index].title;
                          providerRead.productDescription.text =
                              providerRead.products[index].description;
                          providerRead.productPrice.text =
                              providerRead.products[index].price.toString();
                          providerRead.productThumbnail.text =
                              providerRead.products[index].thumbnail;
                          providerRead.productCategory.text =
                              providerRead.products[index].category;
                          providerRead.productStock.text =
                              providerRead.products[index].stock.toString();
                          setState(() {
                            providerRead.selectedIndex = index;
                            providerRead.productIndex = index;
                          });
                        },
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              color: providerRead.selectedIndex == index
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
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color(0xfff3f3f3),
                                      ),
                                      child: Image.network(
                                        filterProduct[index].thumbnail,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          debugPrint(
                                              'Error loading image: $error');
                                          return const Icon(Icons.error);
                                        },
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        },
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
                              if (isSmallScreen &&
                                  providerRead.selectedIndex == index)
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
                )
              ],
            ),
          ),
        ),
        // Right Side: Edit Product Details (only for larger screens)
        if (!isSmallScreen)
          Expanded(
            flex: 1,
            child: Container(
              color: const Color(0xfff3f3f3),
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
                            controller: providerRead.productTitle,
                            decoration: InputDecoration(
                              labelText: 'Product Name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: providerRead.productDescription,
                            decoration: InputDecoration(
                              labelText: 'Product Description',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: providerRead.productPrice,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d*$')),
                            ],
                            decoration: InputDecoration(
                              labelText: 'Product Price',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: providerRead.productThumbnail,
                            decoration: InputDecoration(
                              labelText: 'Product Thumbnail',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: providerRead.productCategory,
                            decoration: InputDecoration(
                              labelText: 'Product Category',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: providerRead.productStock,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              labelText: 'Product Stock',
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
                                    providerRead.productTitle.clear();
                                    providerRead.productPrice.clear();
                                    providerRead.productDescription.clear();
                                    providerRead.productThumbnail.clear();
                                    providerRead.productCategory.clear();
                                    providerRead.productStock.clear();
                                    providerRead.selectedIndex = -1;
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
                                    providerRead
                                        .updateData(providerRead.productIndex);
                                    setState(() {});
                                    providerRead.productTitle.clear();
                                    providerRead.productPrice.clear();
                                    providerRead.productDescription.clear();
                                    providerRead.productThumbnail.clear();
                                    providerRead.productCategory.clear();
                                    providerRead.productStock.clear();
                                    providerRead.selectedIndex = -1;
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

  void showEditDialog(Product product) {
    final providerRead = context.read<ProductData>();
    providerRead.productTitle.text = product.title;
    providerRead.productDescription.text = product.description;
    providerRead.productPrice.text = product.price.toString();
    providerRead.productThumbnail.text = product.thumbnail;
    providerRead.productCategory.text = product.category;
    providerRead.productStock.text = product.stock.toString();

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
                    controller: providerRead.productTitle,
                    decoration:
                        const InputDecoration(labelText: 'Product Name'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: providerRead.productDescription,
                    decoration:
                        const InputDecoration(labelText: 'Product Description'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: providerRead.productPrice,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                    ],
                    decoration:
                        const InputDecoration(labelText: 'Product Price'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: providerRead.productThumbnail,
                    decoration:
                        const InputDecoration(labelText: 'Product Thumbnail'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: providerRead.productCategory,
                    decoration:
                        const InputDecoration(labelText: 'Product Category'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: providerRead.productStock,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration:
                        const InputDecoration(labelText: 'Product Stock'),
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
                providerRead.updateData(
                    context.read<ProductData>().products.indexOf(product));
                Navigator.of(context).pop();
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  // void deleteData(int index) async {
  //   final idToDelete = products[index].id;

  //   try {
  //     final url = Uri.parse("http://localhost:3000/api/products/$idToDelete");
  //     final response = await http.delete(url);

  //     if (response.statusCode == 200) {
  //       setState(() {
  //         products.removeAt(index);
  //       });
  //     } else {
  //       debugPrint(
  //           "Failed to delete data. Status code: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     debugPrint("Error deleting data: $e");
  //   }
  // }
}
