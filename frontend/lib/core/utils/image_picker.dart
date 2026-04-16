import 'dart:io';

import 'package:image_picker/image_picker.dart';

class CentralizedImagePicker {
  CentralizedImagePicker._internal();

  static final CentralizedImagePicker _instance =
      CentralizedImagePicker._internal();

  factory CentralizedImagePicker() => _instance;

  final ImagePicker _imagePicker = ImagePicker();

  Future<File?> pickImageFromGallery() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) {
      return File(image.path);
    }
    return null;
  }

  Future<File?> pickImageFromCamera() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.camera,
    );
    if (image != null) {
      return File(image.path);
    }
    return null;
  }
}
