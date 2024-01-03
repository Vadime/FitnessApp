import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class FilePicking {
  static Future<Uint8List?> pickImage() async {
    FilePickerResult? result;

    try {
      result = await FilePicker.platform.pickFiles(
        dialogTitle: 'Select an image',
        type: FileType.image,
        withData: true,
      );
      if (result != null && result.files.single.path != null) {
        final file = result.files.single;

        if (file.path == null && file.bytes == null) return null;

        Uint8List? output = await FlutterImageCompress.compressWithFile(
          file.path!,
          quality: 10,
          format: CompressFormat.jpeg,
        );

        return output;
      }
    } catch (_) {}
    return null;
  }

  static Future<List<Uint8List>?> pickImages() async {
    FilePickerResult? result;
    List<Uint8List>? output;
    try {
      result = await FilePicker.platform.pickFiles(
        dialogTitle: 'Select an image',
        type: FileType.image,
        withData: true,
        allowMultiple: true,
        allowCompression: true,
      );
      if (result != null && result.files.isNotEmpty) {
        final files = result.files;

        for (var i = 0; i < files.length; i++) {
          final file = files[i];
          if (file.path == null && file.bytes == null) return null;

          Uint8List? image = await FlutterImageCompress.compressWithFile(
            file.path!,
            quality: 10,
            format: CompressFormat.jpeg,
          );
          output ??= [];
          output.add(image!);
        }
        return output;
      }
    } catch (_) {}
    return null;
  }
}
