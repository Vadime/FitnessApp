library widgets;

import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class TextFieldWidget extends StatefulWidget {
  final TextFieldController? controller;
  final TextAlign? textAlign;
  final TextAlignVertical? textAlignVertical;
  final bool? autofocus;
  final bool? autocorrect;
  final bool? enableSuggestions;
  final int? maxLines;
  final int? minLines;
  final bool? expands;
  final int? maxLength;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final bool? enabled;
  final bool? enableInteractiveSelection;
  final GestureTapCallback? onTap;
  final Iterable<String>? autofillHints;
  final EdgeInsets margin;
  final EdgeInsets? padding;
  final double? maxWidth;

  const TextFieldWidget({
    this.controller,
    this.textAlign,
    this.textAlignVertical,
    this.autofocus,
    this.autocorrect,
    this.enableSuggestions,
    this.maxLines,
    this.minLines,
    this.expands,
    this.maxLength,
    this.onEditingComplete,
    this.onSubmitted,
    this.onChanged,
    this.enabled,
    this.enableInteractiveSelection,
    this.onTap,
    this.autofillHints,
    this.margin = EdgeInsets.zero,
    this.padding,
    this.maxWidth,
    super.key,
  });

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  void initState() {
    super.initState();
    firstBuild = false;
    widget.controller?.addListener(() {
      firstBuild = false;
      setState(() {});
    });
  }

  bool firstBuild = true;

  @override
  Widget build(BuildContext context) {
    if (widget.maxWidth == null) {
      return _build(context);
    } else {
      return Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: widget.maxWidth!),
          child: _build(context),
        ),
      );
    }
  }

  _build(BuildContext context) => CardWidget.single(
        margin: widget.margin,
        padding: widget.padding ??
            EdgeInsets.fromLTRB(context.config.padding, context.config.paddingH,
                context.config.padding, context.config.paddingH),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: widget.onTap,
                child: TextField(
                  controller: widget.controller,
                  style: context.textTheme.bodyMedium,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: widget.controller?.labelText,
                    errorText: widget.controller?.calcErrorText(firstBuild),
                    enabled: widget.enabled ?? true,
                    errorMaxLines: 1,
                    isDense: true,
                    labelStyle: context.textTheme.bodyMedium,
                    hintStyle: context.textTheme.bodyMedium,
                    contentPadding: EdgeInsets.zero,
                  ),
                  cursorColor: context.theme.primaryColor,
                  keyboardType: widget.controller?.keyboardType,
                  textAlignVertical: widget.textAlignVertical,
                  autofocus: widget.autofocus ?? false,
                  obscureText: (widget.controller?.obscureText ?? false) &&
                      (widget.controller?.visible ?? true),
                  autocorrect: widget.autocorrect ?? false,
                  enableSuggestions: widget.enableSuggestions ?? false,
                  maxLines: widget.maxLines ?? 1,
                  minLines: widget.minLines,
                  expands: widget.expands ?? false,
                  maxLength: widget.maxLength,
                  onEditingComplete: widget.onEditingComplete,
                  onSubmitted: widget.onSubmitted,
                  onChanged: widget.onChanged,
                  inputFormatters: widget.controller?.inputFormatters,
                  enabled: widget.enabled,
                  enableInteractiveSelection:
                      widget.enableInteractiveSelection ?? true,
                  //onTap: widget.onTap,
                  autofillHints: widget.autofillHints,
                ),
              ),
            ),
            if (widget.controller?.obscureText ?? false)
              SizedBox(
                height: 32,
                width: 32,
                child: IconButtonWidget(
                  widget.controller?.visible ?? false
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  iconSize: 20,
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  minimumSize: Size.zero,
                  onPressed: () => setState(() {
                    widget.controller?.visible =
                        !(widget.controller?.visible ?? false);
                  }),
                ),
              ),
          ],
        ),
      );
}
