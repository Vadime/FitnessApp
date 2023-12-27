import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class ImageWidget extends StatefulWidget {
  final ImageProvider? image;
  final double? width;
  final double? height;
  final BoxFit fit;
  final EdgeInsets margin;
  final double? radius;
  final Function()? onTap;
  final bool fitChangeEnabled;
  final Color? backgroundColor;
  const ImageWidget(
    this.image, {
    this.fit = BoxFit.cover,
    this.margin = EdgeInsets.zero,
    this.radius,
    this.height,
    this.width,
    this.onTap,
    this.backgroundColor,
    this.fitChangeEnabled = true,
    super.key,
  });

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  late BoxFit fit;

  @override
  void initState() {
    fit = widget.fit;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.margin,
      child: GestureDetector(
        onTap: () async {
          if (widget.fitChangeEnabled) {
            fit = fit == BoxFit.cover ? BoxFit.contain : BoxFit.cover;
            setState(() {});
          }

          if (widget.onTap is Future Function()) {
            LoadingController().loadingProcess(widget.onTap);
          } else {
            widget.onTap?.call();
          }
        },
        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(widget.radius ?? context.config.radius),
          child: Container(
            color: widget.backgroundColor,
            child: widget.image == null
                ? buildWidget(context)
                : Image(
                    image: widget.image!,
                    fit: fit,
                    width: widget.width,
                    height: widget.height,
                    errorBuilder: (context, error, stackTrace) =>
                        buildWidget(context),
                    frameBuilder:
                        (context, child, frame, wasSynchronouslyLoaded) =>
                            child,
                    loadingBuilder: (context, child, loadingProgress) =>
                        loadingProgress == null ? child : buildWidget(context),
                  ),
          ),
        ),
      ),
    );
  }

  Widget buildWidget(BuildContext context) => Container(
      color: context.config.neutralColor.withOpacity(0.2),
      width: widget.width,
      height: widget.height);
}
