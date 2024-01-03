import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class ImagesWidget extends StatefulWidget {
  final List<ImageProvider>? images;
  final double? width;
  final double? height;
  final BoxFit fit;
  final EdgeInsets margin;
  final double? radius;
  final Function()? onTap;
  final bool fitChangeEnabled;
  final Color? backgroundColor;
  const ImagesWidget(
    this.images, {
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
  State<ImagesWidget> createState() => _ImagesWidgetState();
}

class _ImagesWidgetState extends State<ImagesWidget> {
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
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (var image in widget.images ?? [])
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          widget.radius ?? context.config.radius),
                      child: Container(
                        color: widget.backgroundColor,
                        child: widget.images == null
                            ? buildWidget(context)
                            : Image(
                                image: image,
                                fit: fit,
                                width: widget.width,
                                height: widget.height,
                                errorBuilder: (context, error, stackTrace) =>
                                    buildWidget(context),
                                frameBuilder: (context, child, frame,
                                        wasSynchronouslyLoaded) =>
                                    child,
                                loadingBuilder: (context, child,
                                        loadingProgress) =>
                                    loadingProgress == null
                                        ? child
                                        : buildWidget(context),
                              ),
                      ),
                    ),
                  ),
              ],
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
