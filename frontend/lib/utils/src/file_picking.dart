import 'dart:io';

import 'package:file_picker/file_picker.dart';

class FilePicking {
  // pick image
  static Future<File?> pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result != null && result.files.single.path != null) {
      return File(result.files.single.path!);
    } else {
      return null;
    }
  }
}
