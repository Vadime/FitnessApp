import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class UploadFile extends StatefulWidget {
  final Uint8List? imageFile;
  final Function(Uint8List? image)? onChanged;
  const UploadFile({
    this.imageFile,
    this.onChanged,
    super.key,
  });

  @override
  State<UploadFile> createState() => _UploadFileState();
}

class _UploadFileState extends State<UploadFile> {
  Uint8List? imageFile;

  @override
  void initState() {
    super.initState();
    imageFile = widget.imageFile;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(context.config.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ImageWidget(
            imageFile == null ? null : MemoryImage(imageFile!),
            height: 200,
            width: double.infinity,
          ),
          SizedBox(height: context.config.paddingH),
          TextButtonWidget(
            'Upload Image',
            onPressed: () async {
              var file = await FilePicking.pickImage();
              if (file == null) {
                return;
              }
              setState(() {
                imageFile = file;
              });
              widget.onChanged?.call(file);
            },
          ),
        ],
      ),
    );
  }
}
