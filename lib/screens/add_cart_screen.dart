import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:product_admin/app.dart';
import 'package:product_admin/provider/product_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddNewProduct extends StatefulWidget {
  const AddNewProduct({super.key});

  @override
  State<AddNewProduct> createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct> {
  final List<Uint8List> images = [];
  final picker = ImagePicker();
  Uint8List? selectedImage;

  // Method to pick an image from the gallery
  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        images.add(bytes);
        selectedImage = bytes;
      });
    }
  }

  // Convert List<Uint8List> to List<String> Base64 encoded images
  List<String> getBase64Images() {
    return images.map((image) => base64Encode(image)).toList();
  }

  Future<List<String>> uploadBase64Images(List<String> base64Images) async {
    final supabaseClient = Supabase.instance.client;
    List<String> uploadedUrls = [];
    for (var i = 0; i < base64Images.length; i++) {
      Uint8List imageBytes = base64Decode(base64Images[i]);

      // Generate a unique file name for each image
      final fileName = 'image_${DateTime.now().millisecondsSinceEpoch}_$i.jpg';

      try {
        // Upload image to Supabase storage (product_images bucket)
        await supabaseClient.storage
            .from('product_images')
            .uploadBinary(fileName, imageBytes);

        // Get the public URL of the uploaded image
        final String publicUrl = supabaseClient.storage
            .from('product_images')
            .getPublicUrl(fileName);

        uploadedUrls.add(publicUrl);
      } catch (e) {
        debugPrint('Error uploading image $i: $e');
      }
    }
    return uploadedUrls;
  }

  @override
  Widget build(BuildContext context) {
    final providerRead = context.read<ProductData>();
    final theme = Theme.of(context); // Use theme to derive values
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // Theme-based
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        elevation: 0.5,
        title: Text(
          "Add New Product",
          style: TextStyle(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton.icon(
              onPressed: () async {
                // Upload images to Supabase
                List<String> productImages =
                    await uploadBase64Images(getBase64Images());
                providerRead.postNewProduct(productImages);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Product added successfully',
                      style: TextStyle(
                        color: theme.textTheme.bodyMedium?.color ?? (theme.brightness == Brightness.dark ? Colors.white : Colors.black87),
                      ),
                    ),
                    backgroundColor: theme.cardColor, // Theme-based
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.elevatedButtonTheme.style?.backgroundColor?.resolve({}) ?? theme.cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: theme.brightness == Brightness.dark ? theme.colorScheme.onPrimary : Colors.transparent),
                ),
              ),
              label: Text(
                "Add Product",
                style: TextStyle(
                  color: theme.elevatedButtonTheme.style?.foregroundColor?.resolve({}) ?? theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              icon: Icon(
                Icons.add,
                color: theme.elevatedButtonTheme.style?.foregroundColor?.resolve({}) ?? theme.colorScheme.onPrimary,
              ),
            ),
          ),
        ],
        iconTheme: IconThemeData(
          color: theme.colorScheme.onPrimary,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Section
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'General Information',
                      style: theme.textTheme.headlineSmall?.copyWith(fontSize: 20) ?? const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87),
                    ),
                    const SizedBox(height: 24),
                    buildInputField(
                      'Name Product',
                      'Enter the product name',
                      providerRead.newProductTitleController,
                    ),
                    const SizedBox(height: 24),
                    buildInputField(
                      'Description Product',
                      'Enter the product description',
                      providerRead.newProductDescriptionController,
                      maxLines: 4,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: buildInputField(
                            'Stock',
                            'Enter stock quantity',
                            providerRead.newProductStockController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: buildInputField(
                            'Category',
                            'Enter category name',
                            providerRead.newProductCategoryController,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z\s]'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Shipping Information',
                      style: theme.textTheme.headlineSmall?.copyWith(fontSize: 20) ?? const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: buildInputField(
                            'Product Shipping Information',
                            'Enter shipping Information',
                            providerRead.newProductShippingInfoController,
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: buildInputField(
                            'Availability Status',
                            'Enter availability',
                            providerRead.newProductAvailabilityStatusController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: buildInputField(
                            'Return Policy',
                            'Enter the return policy',
                            providerRead.newProductReturnPolicyController,
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: buildInputField(
                            'Minimum Order Quantity',
                            'Enter the minimum order quantity',
                            providerRead.newProductMinimumOrderQuantityController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Brand Details',
                      style: theme.textTheme.headlineSmall?.copyWith(fontSize: 20) ?? const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: buildInputField(
                            'Product Brand',
                            'Enter product brand',
                            providerRead.newProductBrandController,
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: buildInputField(
                            'Product Warranty',
                            'Enter product warranty',
                            providerRead.newProductWarrantyController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Pricing',
                      style: theme.textTheme.headlineSmall?.copyWith(fontSize: 20) ?? const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: buildInputField(
                            'Price',
                            'Enter the product price',
                            providerRead.newProductPriceController,
                            keyboardType:
                                const TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d*$'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: buildInputField(
                            'Discount(%)',
                            'Enter the product discount',
                            providerRead.newProductDiscountController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d*$'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 48),
              // Right Section - Upload Images
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.cardColor, // Theme-based
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Upload Product Images',
                          style: theme.textTheme.headlineSmall?.copyWith(fontSize: 18) ?? const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
                        ),
                        const SizedBox(height: 16),
                        // Image Upload Box (Default & Selected Image)
                        GestureDetector(
                          onTap: pickImage,
                          child: Container(
                            height: 300,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: theme.colorScheme.onSurface, // Theme-based
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: selectedImage == null
                                ? Center(
                                    child: Text(
                                      "No Image Selected",
                                      style: TextStyle(
                                        color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7) ?? (theme.brightness == Brightness.dark ? Colors.white70 : Colors.grey),
                                      ),
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.memory(
                                      selectedImage!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Image Picker List (Horizontal Scroll)
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: pickImage,
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: theme.colorScheme.onSurface, // Theme-based
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    color: theme.textTheme.bodyMedium?.color ?? (theme.brightness == Brightness.dark ? Colors.white : Colors.black),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              ...images.map(
                                (image) => GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedImage = image;
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                        image: MemoryImage(image),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
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
          ),
        ),
      ),
    );
  }

  Widget buildInputField(
    String label,
    String hintText,
    TextEditingController controller, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    final theme = Theme.of(context); // Use theme to derive values
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.headlineSmall?.copyWith(fontSize: 14, fontWeight: FontWeight.w500) ?? const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          cursorColor: theme.textTheme.bodyMedium?.color == Colors.white70 ? Colors.white : null, // Theme-based cursor color
          decoration: InputDecoration(
            filled: true,
            fillColor: theme.cardColor, // Theme-based
            hintText: hintText,
            hintStyle: theme.textTheme.bodyMedium?.copyWith(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7)) ?? TextStyle(color: theme.brightness == Brightness.dark ? Colors.white70 : Colors.grey),
            contentPadding: const EdgeInsets.all(12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: theme.colorScheme.onSurface, // Theme-based
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: theme.colorScheme.onSurface, // Theme-based
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: theme.colorScheme.onSurface, // Theme-based
              ),
            ),
          ),
          style: theme.textTheme.bodyMedium, // Theme-based text style
        ),
      ],
    );
  }
}