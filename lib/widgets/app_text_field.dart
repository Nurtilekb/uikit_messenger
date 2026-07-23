import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppInputWidget extends StatefulWidget {
  final String? hintText;
  final TextEditingController? controller;
  final bool? isPasswordField;
  final String? label;
  final FormFieldValidator<String>? validator;
  final TextInputType? inputType;
  final VoidCallback? onTap;
  final void Function(String)? onChanged;
  final Color? filledColor;
  final int? maxLines;
  final int? maxLength;
  final Widget? leading;
  final bool? isReadOnly;
  final String? initalValue;
  final bool? isBorder;
  final double? radius;
  final List<TextInputFormatter>? inputFormatter;
  final Widget? trailing;
  final bool? labelRequired;
  final Color? borderColor;
  final Color? hintColor;
  final EdgeInsets? contentPadding;
  final Color? labelColor;
  final void Function(String?)? onSaved;
  final FocusNode? focusNode;
  final TextStyle? labelStyle;
  final int? minLines;
  final TextInputAction? textInputAction;

  const AppInputWidget({
    super.key,
    this.hintText,
    this.controller,
    this.isPasswordField,
    this.validator,
    this.inputType,
    this.label,
    this.onTap,
    this.onChanged,
    this.filledColor,
    this.maxLines = 1,
    this.leading,
    this.isReadOnly = false,
    this.initalValue,
    this.inputFormatter,
    this.maxLength,
    this.isBorder = true,
    this.trailing,
    this.radius = 14,
    this.labelRequired = false,
    this.borderColor,
    this.hintColor,
    this.contentPadding,
    this.labelColor,
    this.onSaved,
    this.focusNode,
    this.labelStyle,
    this.minLines = 1,
    this.textInputAction,
  });

  @override
  State<AppInputWidget> createState() => _AppInputWidgetState();
}

class _AppInputWidgetState extends State<AppInputWidget> {
  bool _obsecureText = true;
  bool isReadOnly = false;

  @override
  void initState() {
    super.initState();
    isReadOnly = widget.onTap == null ? (widget.isReadOnly ?? false) : true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null)
          RichText(
            text: TextSpan(
              text: widget.label ?? '',
              style:
                  widget.labelStyle ??
                  theme.textTheme.bodyLarge?.copyWith(
                    color:
                        widget.labelColor ?? theme.colorScheme.onSurfaceVariant,
                  ),
              children: widget.labelRequired == true
                  ? [
                      const TextSpan(
                        text: ' *',
                        style: TextStyle(color: Colors.red),
                      ),
                    ]
                  : [],
            ),
          ),
        if (widget.label != null) const SizedBox(height: 4),
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.inputType,
          initialValue: widget.controller == null ? widget.initalValue : null,
          obscureText: widget.isPasswordField == true ? _obsecureText : false,
          cursorColor: theme.colorScheme.onSurface.withOpacity(.6),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onTap: widget.onTap,
          style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16),
          readOnly: isReadOnly,
          enableInteractiveSelection: true,
          validator: widget.validator,
          onChanged: widget.onChanged,
          inputFormatters: widget.inputFormatter,
          textInputAction: widget.textInputAction,
          onSaved: widget.onSaved,
          minLines: widget.minLines,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          focusNode: widget.focusNode,
          decoration: InputDecoration(
            enabled: true,
            prefixIcon: widget.leading,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: widget.isBorder == false
                    ? Colors.transparent
                    : widget.borderColor ?? theme.colorScheme.outlineVariant,
                width: widget.isBorder == true ? .6 : 0,
              ),
              borderRadius: BorderRadius.circular(widget.radius ?? 10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: widget.isBorder == false
                    ? Colors.transparent
                    : widget.borderColor ??
                          theme.colorScheme.outline.withOpacity(.4),
              ),
              borderRadius: BorderRadius.circular(widget.radius ?? 10),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red, width: 1),
              borderRadius: BorderRadius.all(
                Radius.circular(widget.radius ?? 10),
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red, width: 1),
              borderRadius: BorderRadius.all(
                Radius.circular(widget.radius ?? 10),
              ),
            ),
            filled: true,
            fillColor: widget.filledColor ?? theme.colorScheme.surface,
            hintText: widget.hintText,
            hintStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: widget.hintColor ?? theme.colorScheme.outline,
            ),
            contentPadding:
                widget.contentPadding ??
                const EdgeInsets.fromLTRB(12, 6, 12, 6),
            suffixIcon: widget.trailing != null
                ? widget.trailing!
                : widget.onTap == null
                ? widget.isPasswordField == true
                      ? GestureDetector(
                          onTap: () {
                            _obsecureText = !_obsecureText;
                            setState(() {});
                          },
                          child: Icon(
                            _obsecureText
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: theme.colorScheme.outline,
                          ),
                        )
                      : null
                : isReadOnly
                ? null
                : null,
          ),
        ),
      ],
    );
  }
}
