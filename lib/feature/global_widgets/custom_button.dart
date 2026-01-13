import 'package:flutter/material.dart';
import 'package:product_task/core/constants/app_theme.dart';

enum ButtonVariant { primary, secondary, outline, text, danger }
enum ButtonSize { small, medium, large }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final IconData? icon;
  final bool iconLeading;
  final bool isLoading;
  final bool fullWidth;
  final double? borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.icon,
    this.iconLeading = true,
    this.isLoading = false,
    this.fullWidth = false,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = _getButtonStyle();
    final padding = _getPadding();
    final fontSize = _getFontSize();

    Widget child = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: _getLoadingColor(),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null && iconLeading) ...[
                Icon(icon, size: fontSize + 4),
                const SizedBox(width: 8),
              ],
              Text(text, style: TextStyle(fontSize: fontSize)),
              if (icon != null && !iconLeading) ...[
                const SizedBox(width: 8),
                Icon(icon, size: fontSize + 4),
              ],
            ],
          );

    Widget button;
    switch (variant) {
      case ButtonVariant.primary:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle.copyWith(
            padding: WidgetStateProperty.all(padding),
          ),
          child: child,
        );
        break;
      case ButtonVariant.secondary:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle.copyWith(
            padding: WidgetStateProperty.all(padding),
            backgroundColor: WidgetStateProperty.all(AppColors.accent),
          ),
          child: child,
        );
        break;
      case ButtonVariant.outline:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle.copyWith(
            padding: WidgetStateProperty.all(padding),
            side: WidgetStateProperty.all(BorderSide(color: AppColors.primary)),
          ),
          child: child,
        );
        break;
      case ButtonVariant.text:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle.copyWith(
            padding: WidgetStateProperty.all(padding),
          ),
          child: child,
        );
        break;
      case ButtonVariant.danger:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle.copyWith(
            padding: WidgetStateProperty.all(padding),
            backgroundColor: WidgetStateProperty.all(AppColors.error),
          ),
          child: child,
        );
        break;
    }

    return fullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }

  ButtonStyle _getButtonStyle() {
    return ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 10),
      ),
    );
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
      case ButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 16);
    }
  }

  double _getFontSize() {
    switch (size) {
      case ButtonSize.small:
        return 12;
      case ButtonSize.medium:
        return 14;
      case ButtonSize.large:
        return 16;
    }
  }

  Color _getLoadingColor() {
    switch (variant) {
      case ButtonVariant.outline:
      case ButtonVariant.text:
        return AppColors.primary;
      default:
        return Colors.white;
    }
  }
}

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? backgroundColor;
  final String? tooltip;
  final double size;
  final double iconSize;

  const CustomIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.color,
    this.backgroundColor,
    this.tooltip,
    this.size = 36,
    this.iconSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    final button = InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor ?? (color ?? AppColors.primary).withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          color: color ?? AppColors.primary,
          size: iconSize,
        ),
      ),
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: button);
    }
    return button;
  }
}

class ActionButtonGroup extends StatelessWidget {
  final VoidCallback? onView;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final double spacing;

  const ActionButtonGroup({
    super.key,
    this.onView,
    this.onEdit,
    this.onDelete,
    this.spacing = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onView != null) ...[
          CustomIconButton(
            icon: Icons.visibility_outlined,
            color: AppColors.info,
            tooltip: 'View',
            onPressed: onView,
          ),
          SizedBox(width: spacing),
        ],
        if (onEdit != null) ...[
          CustomIconButton(
            icon: Icons.edit_outlined,
            color: AppColors.warning,
            tooltip: 'Edit',
            onPressed: onEdit,
          ),
          SizedBox(width: spacing),
        ],
        if (onDelete != null)
          CustomIconButton(
            icon: Icons.delete_outline,
            color: AppColors.error,
            tooltip: 'Delete',
            onPressed: onDelete,
          ),
      ],
    );
  }
}
