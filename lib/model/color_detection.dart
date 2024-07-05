import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'dart:math';

class Pixel {
  final int color;
  final int x;
  final int y;

  Pixel(this.color, this.x, this.y);
}

class ColorDetection {
  List<Color> extractColors(Uint8List imageData, int numberOfColors) {
    final image = img.decodeImage(imageData);
    if (image == null) return [];

    final colorMap = <int, int>{};

    for (var y = 0; y < image.height; y++) {
      for (var x = 0; x < image.width; x++) {
        final pixel = image.getPixel(x, y);
        if (colorMap.containsKey(pixel)) {
          colorMap[pixel] = colorMap[pixel]! + 1;
        } else {
          colorMap[pixel] = 1;
        }
      }
    }

    final sortedColors = colorMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final dominantColors = sortedColors
        .take(numberOfColors)
        .map((entry) => Color(entry.key))
        .toList();

    return dominantColors;
  }

  List<Color> extractColorsUsingKMeans(Uint8List imageData, int k) {
    final image = img.decodeImage(imageData);
    if (image == null) return [];

    final pixels = <Pixel>[];

    for (var y = 0; y < image.height; y++) {
      for (var x = 0; x < image.width; x++) {
        pixels.add(Pixel(image.getPixel(x, y), x, y));
      }
    }

    // Initialize centroids
    final centroids =
        List<Pixel>.generate(k, (_) => pixels[Random().nextInt(pixels.length)]);

    List<Pixel> previousCentroids;
    bool centroidsChanged;

    do {
      final clusters = List<List<Pixel>>.generate(k, (_) => []);
      previousCentroids = List<Pixel>.from(centroids);

      // Assign pixels to the nearest centroid
      for (final pixel in pixels) {
        final distances = centroids.map((c) => _distance(pixel, c)).toList();
        final nearestIndex = distances.indexOf(distances.reduce(min));
        clusters[nearestIndex].add(pixel);
      }

      // Recalculate centroids
      for (var i = 0; i < k; i++) {
        if (clusters[i].isNotEmpty) {
          final avgColor = _averageColor(clusters[i]);
          centroids[i] = Pixel(avgColor, 0, 0);
        }
      }

      // Check if centroids have changed
      centroidsChanged = !centroids.asMap().entries.every(
          (entry) => _isSamePixel(entry.value, previousCentroids[entry.key]));
    } while (centroidsChanged);

    return centroids.map((c) => Color(c.color)).toList();
  }

  int _distance(Pixel a, Pixel b) {
    final rDiff = img.getRed(a.color) - img.getRed(b.color);
    final gDiff = img.getGreen(a.color) - img.getGreen(b.color);
    final bDiff = img.getBlue(a.color) - img.getBlue(b.color);
    return rDiff * rDiff + gDiff * gDiff + bDiff * bDiff;
  }

  int _averageColor(List<Pixel> pixels) {
    int r = 0, g = 0, b = 0;
    for (final p in pixels) {
      r += img.getRed(p.color);
      g += img.getGreen(p.color);
      b += img.getBlue(p.color);
    }
    final count = pixels.length;
    return img.getColor(r ~/ count, g ~/ count, b ~/ count);
  }

  bool _isSamePixel(Pixel a, Pixel b) {
    return a.color == b.color;
  }
}
