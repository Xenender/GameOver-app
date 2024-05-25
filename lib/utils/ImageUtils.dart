import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class ImageUtils {
  static Future<Uint8List?> compressImage(Uint8List imageBytes, int quality) async {
    try {
      // Décodez l'Uint8List en une image
      img.Image image = img.decodeImage(imageBytes)!;

      // Encodez l'image avec la qualité spécifiée
      Uint8List compressedImage = img.encodeJpg(image, quality: quality);

      // Convertissez l'image compressée en Uint8List
      //Uint8List compressedBytes = Uint8List.fromList(img.encodeJpg(compressedImage));

      return compressedImage;
    } catch (e) {
      print('Erreur lors de la compression de l\'image : $e');
      return null;
    }
  }
}