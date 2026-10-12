import 'package:driver_diary/app/theme/theme_context.dart';
import 'package:driver_diary/shared/ui/app_field_frame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Текстовое поле с подписью сверху: серая заливка, акцентное кольцо в фокусе.
class AppTextField extends StatefulWidget {
  const AppTextField({
    required this.controller,
    required this.label,
    this.hint,
    this.errorText,
    this.helperText,
    this.suffixText,
    this.suffixIcon,
    this.keyboardType,
    this.inputFormatters,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final String? errorText;
  final String? helperText;

  /// Например, знак валюты справа от текста.
  final String? suffixText;

  /// Кнопка справа внутри поля (например, значок выбора времени).
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  FocusNode? _ownFocusNode;
  FocusNode get _focusNode =>
      widget.focusNode ?? (_ownFocusNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void didUpdateWidget(AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      (oldWidget.focusNode ?? _ownFocusNode)?.removeListener(_onFocusChanged);
      _focusNode.addListener(_onFocusChanged);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChanged);
    _ownFocusNode?.dispose();
    super.dispose();
  }

  void _onFocusChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.textTheme;

    return AppFieldFrame(
      label: widget.label,
      errorText: widget.errorText,
      helperText: widget.helperText,
      child: DecoratedBox(
        decoration: fieldDecoration(
          context,
          hasError: widget.errorText != null,
          focused: _focusNode.hasFocus,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: kFieldHeight),
          child: Center(
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              keyboardType: widget.keyboardType,
              inputFormatters: widget.inputFormatters,
              textInputAction: widget.textInputAction,
              onChanged: widget.onChanged,
              onSubmitted: widget.onSubmitted,
              style: text.bodyLarge,
              cursorColor: colors.accent,
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: text.bodyLarge?.copyWith(
                  color: colors.labelTertiary,
                ),
                suffixText: widget.suffixText,
                suffixIcon: widget.suffixIcon,
                suffixStyle: text.bodyLarge?.copyWith(
                  color: colors.labelSecondary,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 15,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
