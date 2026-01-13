import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:product_task/core/constants/app_theme.dart';

class CustomText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final bool selectable;

  const CustomText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.selectable = false,
  });

  factory CustomText.heading1(
    String text, {
    Color? color,
    TextAlign? textAlign,
  }) {
    return CustomText(
      text,
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: color ?? AppColors.textPrimary,
      ),
      textAlign: textAlign,
    );
  }

  factory CustomText.heading2(
    String text, {
    Color? color,
    TextAlign? textAlign,
  }) {
    return CustomText(
      text,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.textPrimary,
      ),
      textAlign: textAlign,
    );
  }

  factory CustomText.heading3(
    String text, {
    Color? color,
    TextAlign? textAlign,
  }) {
    return CustomText(
      text,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.textPrimary,
      ),
      textAlign: textAlign,
    );
  }

  factory CustomText.title(
    String text, {
    Color? color,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return CustomText(
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.textPrimary,
      ),
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.ellipsis,
    );
  }

  factory CustomText.subtitle(String text, {Color? color, int? maxLines}) {
    return CustomText(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: color ?? AppColors.textSecondary,
      ),
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }

  factory CustomText.body(
    String text, {
    Color? color,
    int? maxLines,
    TextAlign? textAlign,
  }) {
    return CustomText(
      text,
      style: TextStyle(fontSize: 14, color: color ?? AppColors.textPrimary),
      maxLines: maxLines,
      textAlign: textAlign,
    );
  }

  factory CustomText.caption(String text, {Color? color}) {
    return CustomText(
      text,
      style: TextStyle(fontSize: 12, color: color ?? AppColors.textMuted),
    );
  }

  factory CustomText.label(String text, {Color? color, double? letterSpacing}) {
    return CustomText(
      text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.textSecondary,
        letterSpacing: letterSpacing ?? 0.5,
      ),
    );
  }

  factory CustomText.price(String text, {Color? color, double? fontSize}) {
    return CustomText(
      text,
      style: TextStyle(
        fontSize: fontSize ?? 16,
        fontWeight: FontWeight.w700,
        color: color ?? AppColors.accent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (selectable) {
      return SelectableText(
        text,
        style: style,
        textAlign: textAlign,
        maxLines: maxLines,
      );
    }
    return Text(
      text,
      style: style,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final bool readOnly;
  final TextInputType? keyboardType;
  final int? maxLines;
  final VoidCallback? onTap;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? borderColor;
  final double? borderRadius;
  final double? borderWidth;
  final String? hintText;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;
  final Color? fillColor;
  final Color? textColor;
  final Color? hintTextColor;

  const CustomTextField({
    super.key,
    required this.controller,
    this.validator,
    this.obscureText = false,
    this.readOnly = false,
    this.keyboardType,
    this.maxLines = 1,
    this.onTap,
    this.prefixIcon,
    this.suffixIcon,
    this.borderColor,
    this.borderRadius,
    this.hintText,
    this.inputFormatters,
    this.onChanged,
    this.fillColor,
    this.hintTextColor,
    this.textColor,
    this.borderWidth,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      readOnly: readOnly,
      style: TextStyle(color: textColor ?? Colors.black),
      keyboardType: keyboardType,
      maxLines: maxLines,
      inputFormatters: inputFormatters ?? [],
      onTap: onTap,
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor ?? Colors.transparent,
        hintText: hintText ?? '',
        hintStyle: TextStyle(color: hintTextColor ?? Colors.black54),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: borderColor ?? Colors.grey,
            width: borderWidth ?? 4,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: borderColor ?? Colors.grey,
            width: borderWidth ?? 4,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: borderColor ?? Colors.grey,
            width: borderWidth ?? 4,
          ),
        ),
      ),
    );
  }
}
