import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fitnessapp/utils/utils.dart';

class FilePicking {
  // pick image
  static Future<File?> pickImage() async {
    Navigation.disableInput();

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    Navigation.enableInput();

    if (result != null && result.files.single.path != null) {
      return File(result.files.single.path!);
    } else {
      return null;
    }
  }
}
