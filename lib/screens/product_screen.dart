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
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    await context.read<ProductData>().getData();
  }

  void _onAddNewProduct() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddNewProduct(),
      ),
    );
  }

  void _onClearForm() {
    final providerRead = context.read<ProductData>();
    providerRead.productTitle.clear();
    providerRead.productPrice.clear();
    providerRead.productDescription.clear();
    providerRead.productThumbnail.clear();
    providerRead.productCategory.clear();
    providerRead.productStock.clear();
    providerRead.selectedIndex = -1;
    setState(() {});
  }

  void _onUpdateProduct() {
    final providerRead = context.read<ProductData>();
    providerRead.updateData(providerRead.productIndex);
    providerRead.productTitle.clear();
    providerRead.productPrice.clear();
    providerRead.productDescription.clear();
    providerRead.productThumbnail.clear();
    providerRead.productCategory.clear();
    providerRead.productStock.clear();
    providerRead.selectedIndex = -1;
    setState(() {});
  }

  void _onProductCardTap(int index) {
    final providerRead = context.read<ProductData>();
    providerRead.productTitle.text = providerRead.products[index].title;
    providerRead.productDescription.text = providerRead.products[index].description;
    providerRead.productPrice.text = providerRead.products[index].price.toString();
    providerRead.productThumbnail.text = providerRead.products[index].thumbnail;
    providerRead.productCategory.text = providerRead.products[index].category;
    providerRead.productStock.text = providerRead.products[index].stock.toString();
    setState(() {
      providerRead.selectedIndex = index;
      providerRead.productIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
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
            color: Theme.of(context).scaffoldBackgroundColor,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Products',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: providerRead.searchProduct,
                        cursorColor: isDark ? Colors.white : Theme.of(context).colorScheme.onSurface,
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          hintStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface, // White in dark mode
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Theme.of(context).colorScheme.onSurface, // White in dark mode
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.onSurface, // White in dark mode
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.onSurface, // White in dark mode
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.onSurface, // White in dark mode
                            ),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).cardColor,
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      height: 47,
                      child: ElevatedButton.icon(
                        onPressed: _onAddNewProduct,
                        icon: const Icon(Icons.add),
                        label: const Text('Add New Product'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: providerRead.isProductsLoaded
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xffdb3022),
                          ),
                        )
                      : GridView.builder(
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
                           providerRead.hoveredScales.putIfAbsent(index, () => 1.0);
                            return _buildProductCard(index, product, context,providerRead.hoveredScales);
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: 450,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border(
              left: BorderSide(color: Theme.of(context).dividerColor),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit Product',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface, // White in dark mode
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
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 35,
                    child: OutlinedButton.icon(
                      onPressed: _onClearForm,
                      icon: const Icon(Icons.cancel),
                      label: const Text('Clear'),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Color(0xffdb3022), 
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 35,
                    child: ElevatedButton.icon(
                      onPressed: _onUpdateProduct,
                      icon: const Icon(Icons.edit),
                      label: const Text('Update Product'),
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

  Widget _buildProductCard(int index, Product product, BuildContext context,hoveredScales) {
    final providerRead = context.read<ProductData>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => _onProductCardTap(index),
      child: Card(
        elevation: 5,
        color: Theme.of(context).cardColor,
       shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: providerRead.selectedIndex == index
              ? (isDark ? Colors.white : Theme.of(context).colorScheme.primary)
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
    borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
    color: Theme.of(context).cardColor,
  ),
  child: Center(
    child: MouseRegion(
      onEnter: (_) => setState(() => hoveredScales[index] = 1.1), // Zoom in on hover
      onExit: (_) => setState(() => hoveredScales[index] = 1.0), // Reset on exit
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 1.0, end:providerRead.hoveredScales[index]),
        duration: const Duration(milliseconds: 400),
        builder: (context, scale, child) {
          return Transform.scale(
            scale: scale,
            child: child,
          );
        },
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          child: Image.network(
            product.thumbnail ?? '', // Use product.thumbnail with fallback
            height: 230,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              debugPrint('Error loading image: $error');
              return const Icon(Icons.error, color: Colors.white);
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    ),
  ),
),
            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                product.title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Theme.of(context).textTheme.bodyMedium?.color, // White in dark, black87 in light
                ),
              ),
            ),
            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                '\$ ${product.price}',
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6), // White in dark, black87 in light
                ),
              ),
            ),
            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Stock: ${product.stock}',
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Theme.of(context).textTheme.bodyMedium?.color, // White in dark, black87 in light
                ),
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
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: TextField(
      controller: controller,
      style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
      cursorColor: isDark ? Colors.white : Theme.of(context).colorScheme.onSurface, // White in dark mode, default in light
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurface, // White in dark mode
        ),
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurface, // White in dark mode
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.onSurface, // White in dark mode
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.onSurface, // White in dark mode
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.onSurface, // White in dark mode
          ),
        ),
        filled: true,
        fillColor: Theme.of(context).cardColor,
      ),
    ),
  );
}
}