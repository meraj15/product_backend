import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';

class AddNewProduct extends StatefulWidget {
  const AddNewProduct({super.key});

  @override
  State<AddNewProduct> createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct> {
 final List<Uint8List> images = [];
  final picker = ImagePicker();
  Uint8List? selectedImage;

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
  @override
  Widget build(BuildContext context) {
    // final providerRead = context.read<ProductData>();
    return Scaffold(
      backgroundColor: const Color(0xfff9f9f9),
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 0.5,
        title: const Text(
          "Add New Product",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton(
              onPressed: () async {
                  // final newProduct = {
                  //   'title': providerRead.newProductTitleController.text,
                  //   'description': providerRead.newProductDescriptionController.text,
                  //   'category': providerRead.newProductCategoryController.text,
                  //   'price': double.tryParse(providerRead.newProductPriceController.text) ?? 0.0,
                  //   'discountpercentage': double.tryParse(providerRead.newProductDiscountController.text) ?? 0.0,
                  //   'stock': int.tryParse(providerRead.newProductStockController.text) ?? 0,
                  //   'brand': providerRead.newProductBrandController.text,
                  //   'warrantyinformation': providerRead.newProductWarrantyController.text,
                  //   'shippinginformation': providerRead.newProductShippingInfoController.text,
                  //   'availabilitystatus': providerRead.newProductAvailabilityStatusController.text,
                  //   'returnpolicy': providerRead.newProductReturnPolicyController.text,
                  //   'minimumorderquantity': int.tryParse(providerRead.newProductMinimumOrderQuantityController.text) ?? 0,
                  //   'images': providerRead.newProductImageUrls,
                  //   'thumbnail': providerRead.newProductImageUrls.isNotEmpty ? providerRead.newProductImageUrls.first : '',
                  // };

                  // List<String> imageUrls = await _uploadImages();
                  // debugPrint("imageUrls : $imageUrls");
                  // // Uncomment the following line to post the new product after uploading images
                  // // providerRead.postNewProduct(newProduct);
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   const SnackBar(content: Text('Product added successfully')),
                  // );
                },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text(
                "Add Product",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24, 24, 24, 40),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Section
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('General Information',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600)),
                    SizedBox(height: 24),
                    buildInputField('Name Product', 'Enter the product name'),
                    SizedBox(height: 24),
                    buildInputField(
                        'Description Product', 'Enter the product description',
                        maxLines: 4),
                    SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: buildInputField(
                            'Stock',
                            'Enter stock quantity',
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                        ),
                        SizedBox(width: 24),
                        Expanded(
                          child: buildInputField(
                            'Category',
                            'Enter category name',
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[a-zA-Z\s]'))
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32),
                    Text('Shipping Information',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600)),
                    SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: buildInputField(
                            'Shipping Price',
                            'Enter shipping price',
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d*$'))
                            ],
                          ),
                        ),
                        SizedBox(width: 24),
                        Expanded(
                          child: buildInputField(
                            'Availability Status',
                            'Enter availability',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                            child: buildInputField(
                                'Return Policy', 'Enter the return policy')),
                        SizedBox(width: 24),
                        Expanded(
                          child: buildInputField(
                            'Minimum Order Quantity',
                            'Enter the minimum order quantity',
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32),
                    Text('Pricing',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600)),
                    SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: buildInputField(
                            'Price',
                            'Enter the product price',
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d*$'))
                            ],
                          ),
                        ),
                        SizedBox(width: 24),
                        Expanded(
                          child: buildInputField(
                            'Discount(%)',
                            'Enter the product discount',
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*$'))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 48),

              // Right Section - Upload Images
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Upload Product Images',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600)),
                        SizedBox(height: 16),

                        // Image Upload Box (Default & Selected Image)
                        GestureDetector(
                          onTap: pickImage,
                          child: Container(
                            height: 300,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: selectedImage == null
                                ? Center(
                                    child: Text("No Image Selected",
                                        style: TextStyle(color: Colors.grey)))
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.memory(selectedImage!,
                                        fit: BoxFit.cover),
                                  ),
                          ),
                        ),
                        SizedBox(height: 16),

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
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(Icons.add, color: Colors.black),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              ...images.map((image) => GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedImage = image;
                                      });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(right: 8),
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: selectedImage == image
                                              ? Colors.black
                                              : Colors.grey,
                                          width: selectedImage == image ? 2 : 1,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.memory(image,
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                  )),
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
    String hintText, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 8),
        TextFormField(
          maxLines: maxLines,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: hintText,
            contentPadding: EdgeInsets.all(12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}