import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'dart:io';

import 'package:loading_animation_widget/loading_animation_widget.dart';

class ColorDetectresult extends StatefulWidget {
  final XFile imagepicked;

  const ColorDetectresult({super.key, required this.imagepicked});

  @override
  State<ColorDetectresult> createState() => _ColorDetectresultState();
}

class _ColorDetectresultState extends State<ColorDetectresult> {
  List<Color> _colors = [];
  String hexcolor = "";
  String rgbcolor = "";
  Color? dominantColor;
  Color? centerColor;
  bool islaoding = false;

  @override
  void initState() {
    super.initState();
    loadingDelay();
  }

  void loadingDelay() {
    setState(() {
      islaoding = true;
    });

    Future.delayed(const Duration(seconds: 5)).then((value) {
      _getColors();
      setState(() {
        islaoding = false;
      });
    });
  }

  Future<void> _getColors() async {
    try {
      if (widget.imagepicked.path.isEmpty) return;

      final bytes = await widget.imagepicked.readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) {
        return;
      }

      final colorCounts = <int, int>{};
      final data = image.getBytes();
      final pixels = data.length ~/ 4;

      // Calculate dominant color
      int dominantColorCount = 0;
      int? dominantColorValue;

      // Calculate color at the center of the image
      int centerX = image.width ~/ 2;
      int centerY = image.height ~/ 2;
      int centerIndex = (centerY * image.width + centerX) * 4;
      int centerColorValue = _getColorValue(data, centerIndex);

      for (int i = 0; i < pixels; i++) {
        final index = i * 4;
        final color = _getColorValue(data, index);

        if (colorCounts.containsKey(color)) {
          colorCounts[color] = colorCounts[color]! + 1;
        } else {
          colorCounts[color] = 1;
        }

        // Update dominant color
        if (colorCounts[color]! > dominantColorCount) {
          dominantColorCount = colorCounts[color]!;
          dominantColorValue = color;
        }
      }

      // Set dominant color
      dominantColor = Color(dominantColorValue!);

      // Set center color
      centerColor = Color(centerColorValue);

      final sortedColors = colorCounts.keys.toList()
        ..sort((a, b) => colorCounts[b]!.compareTo(colorCounts[a]!));

      setState(() {
        _colors = sortedColors.take(10).map((c) => Color(c)).toList();
      });
    } catch (error) {
      debugPrint("Error processing image: $error");
    }
  }

  int _getColorValue(Uint8List data, int index) {
    final r = data[index];
    final g = data[index + 1];
    final b = data[index + 2];
    final a = data[index + 3];
    return (a << 24) | (r << 16) | (g << 8) | b;
  }

  void _setColorValues(Color color) {
    setState(() {
      hexcolor =
          '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
      rgbcolor = 'RGB(${color.red}, ${color.green}, ${color.blue})';
    });
  }

  @override
  Widget build(BuildContext context) {
    return islaoding == false
        ? Scaffold(
            appBar: AppBar(
              title: const Text('Color Detection Result'),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  if (widget.imagepicked.path.isNotEmpty)
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 350,
                      child: Image.file(
                        fit: BoxFit.cover,
                        File(widget.imagepicked.path),
                      ),
                    ),
                  if (_colors.isNotEmpty)
                    const SizedBox(
                      height: 20,
                    ),
                  const Center(
                    child: Text(
                      "Color Detected from the Image",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _colors
                        .map((color) => GestureDetector(
                              onTap: () {
                                _setColorValues(color);
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                    color: color,
                                    border: Border.all(
                                        width: 1, color: Colors.black)),
                              ),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 20),
                  if (hexcolor.isNotEmpty && rgbcolor.isNotEmpty)
                    Column(
                      children: [
                        Text(
                          'Hex: $hexcolor',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          'RGB: $rgbcolor',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  if (dominantColor != null && centerColor != null)
                    Column(
                      children: [
                        const Text(
                          'Dominant Color:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              color: dominantColor,
                              border:
                                  Border.all(width: 1, color: Colors.black)),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          )
        : Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: LoadingAnimationWidget.inkDrop(
                      color: Colors.lightBlueAccent, size: 26),
                )
              ],
            ),
          );
  }
}
