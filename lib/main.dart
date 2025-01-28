import 'package:flutter/material.dart';
import 'package:product_admin/app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main()async {
   WidgetsFlutterBinding.ensureInitialized();
    await Supabase.initialize(
    url: 'https://njzvyrsxbwxpcyclztzo.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5qenZ5cnN4Ynd4cGN5Y2x6dHpvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzcyMjM3MjUsImV4cCI6MjA1Mjc5OTcyNX0.vGwsuM9G2YzWBpPN0V89gisK6IvXvZF2nldihkwrZmI',
  );

  runApp(MyApp());
}

// final List<Uint8List> images = [];
//   final picker = ImagePicker();
//   Uint8List? selectedImage;

//   Future<void> pickImage() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       final bytes = await pickedFile.readAsBytes(); 
//       setState(() {
//         images.add(bytes);
//         selectedImage = bytes;
//       });
//     }
//   }


