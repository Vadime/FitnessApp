import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class UploadFiles extends StatefulWidget {
  final List<Uint8List>? imageFiles;
  final Function(List<Uint8List>? images)? onChanged;
  final EdgeInsets margin;
  const UploadFiles({
    this.imageFiles,
    this.onChanged,
    this.margin = EdgeInsets.zero,
    super.key,
  });

  @override
  State<UploadFiles> createState() => _UploadFilesState();
}

class _UploadFilesState extends State<UploadFiles> {
  List<Uint8List>? imageFiles;

  @override
  void initState() {
    super.initState();
    imageFiles = widget.imageFiles;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // TODO: show all images
          // in Horizontal scroll view
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (var imageFile in imageFiles ?? [])
                  ImageWidget(
                    MemoryImage(imageFile),
                    height: 200,
                    width: 200,
                    margin: const EdgeInsets.all(4),
                  ),
              ],
            ),
          ),
          TextButtonWidget(
            'Bilder hochladen',
            margin: EdgeInsets.only(top: context.config.paddingH),
            onPressed: () async {
              var files = await FilePicking.pickImages();
              if (files == null) {
                return;
              }
              setState(() {
                imageFiles = files;
              });
              widget.onChanged?.call(files);
            },
          ),
        ],
      ),
    );
  }
}
