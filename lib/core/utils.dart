import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void showSnackBar(BuildContext context,String content){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}

String getNameFromEmail(String email){
  return email.split("@")[0];
}

Future<List<File>> pickImages() async {
  List<File> images = [];
  final ImagePicker imagePicker = ImagePicker();
  final imageFiles = await imagePicker.pickMultiImage();
  for(final image in imageFiles){
    images.add(File(image.path));
  }
  return images;
}