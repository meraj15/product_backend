import 'package:flutter/material.dart';
import 'package:product_admin/model/product_model.dart';
import 'package:product_admin/provider/product_provider.dart';
import 'package:product_admin/screens/add_cart_screen.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    await context.read<ProductData>().getData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final providerRead = Provider.of<ProductData>(context, listen: true);
    final filterProduct = providerRead.searchProduct.text.isEmpty
        ? providerRead.products
        : providerRead.products.where((product) {
            final searchText = providerRead.searchProduct.text.toLowerCase();
            return product.title.toLowerCase().contains(searchText) ||
                product.category.toLowerCase().contains(searchText);
          }).toList();
    return Row(
      children: [
        // Main Content
        Expanded(
          flex: 2,
          child: Container(
            color: Colors.grey.shade50,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Products',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: providerRead.searchProduct,
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>const AddNewProduct(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text(
                        'Add New Product',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
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
                      final product = filterProduct[index];
                      return _buildProductCard(index, product, context);
                    },
                  ),
                )
              ],
            ),
          ),
        ),

        // Edit Form
        Container(
          width: 450,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              left: BorderSide(color: Colors.grey.shade200),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Edit Product',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              _buildTextField(
                controller: providerRead.productThumbnail,
                label: 'Product Thumbnail URL',
              ),
              _buildTextField(
                controller: providerRead.productTitle,
                label: 'Product Title',
              ),
              _buildTextField(
                controller: providerRead.productDescription,
                label: 'Product Description',
              ),
              _buildTextField(
                controller: providerRead.productPrice,
                label: 'Product Price',
              ),
              _buildTextField(
                controller: providerRead.productStock,
                label: 'Product Stock',
              ),
              _buildTextField(
                controller: providerRead.productCategory,
                label: 'Category',
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 35,
                    child: OutlinedButton.icon(
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
                      label: const Text('Clear'),
                      icon: const Icon(Icons.cancel),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 35,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        providerRead.updateData(providerRead.productIndex);
                        providerRead.productTitle.clear();
                        providerRead.productPrice.clear();
                        providerRead.productDescription.clear();
                        providerRead.productThumbnail.clear();
                        providerRead.productCategory.clear();
                        providerRead.productStock.clear();
                        providerRead.selectedIndex = -1;
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      label: const Text(
                        'Update Product',
                        style: TextStyle(color: Colors.white),
                      ),
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(int index, Product product, BuildContext context) {
    final providerRead = context.read<ProductData>();
    return GestureDetector(
      onTap: () {
        providerRead.productTitle.text = providerRead.products[index].title;
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xfff3f3f3),
              ),
              child: Image.network(
                product.thumbnail,
                height: 230,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  debugPrint('Error loading image: $error');
                  return const Icon(Icons.error);
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                product.title,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                '\$ ${product.price}',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Stock: ${product.stock}',
              ),
            ),
            const SizedBox(height: 2),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
