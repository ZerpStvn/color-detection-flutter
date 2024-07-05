// import 'dart:typed_data';
// import 'package:colorpick/model/color_detection.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   Uint8List? _imageData;
//   List<Color>? _dominantColors;
//   List<Color>? _allColors;
//   Color? _objectColor;
//   final _colorDetection = ColorDetection();
//   Color? _centerColor;

//   Future<void> _pickImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       final imageData = await pickedFile.readAsBytes();
//       setState(() {
//         _imageData = imageData;
//         _dominantColors = _colorDetection.extractColors(imageData, 100);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Dominant and Possible Colors in Image'),
//       ),
//       body: SingleChildScrollView(
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               if (_imageData != null) Image.memory(_imageData!),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _pickImage,
//                 child: Text('Pick Image'),
//               ),
//               SizedBox(height: 20),
//               if (_dominantColors != null)
//                 Column(
//                   children: [
//                     Text('Dominant Colors:'),
//                     Wrap(
//                       children: _dominantColors!.map((color) {
//                         return Container(
//                           width: 50,
//                           height: 50,
//                           color: color,
//                         );
//                       }).toList(),
//                     ),
//                   ],
//                 ),
//               SizedBox(height: 20),
//               if (_allColors != null)
//                 Column(
//                   children: [
//                     Text('All Detected Colors:'),
//                     Container(
//                       height: 100, // Limiting the height for display
//                       child: SingleChildScrollView(
//                         child: Wrap(
//                           children: _allColors!.map((color) {
//                             return Container(
//                               width: 20,
//                               height: 20,
//                               color: color,
//                             );
//                           }).toList(),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               const SizedBox(height: 20),
//               if (_centerColor != null)
//                 Column(
//                   children: [
//                     const Text('Center Color:'),
//                     Container(
//                       width: 50,
//                       height: 50,
//                       color: _centerColor,
//                     ),
//                   ],
//                 ),
//               SizedBox(height: 20),
//               if (_objectColor != null)
//                 Column(
//                   children: [
//                     const Text('Object Color (Example ROI):'),
//                     Container(
//                       width: 50,
//                       height: 50,
//                       color: _objectColor,
//                     ),
//                   ],
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
