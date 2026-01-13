import 'package:flutter/material.dart';
import 'package:product_task/core/constants/app_theme.dart';

enum BadgeType { success, error, warning, info, neutral }

class StatusBadge extends StatelessWidget {
  final String text;
  final BadgeType type;
  final bool showDot;
  final double? fontSize;
  final EdgeInsets? padding;

  const StatusBadge({
    super.key,
    required this.text,
    this.type = BadgeType.neutral,
    this.showDot = true,
    this.fontSize,
    this.padding,
  });

  factory StatusBadge.inStock() {
    return const StatusBadge(
      text: 'In Stock',
      type: BadgeType.success,
    );
  }

  factory StatusBadge.outOfStock() {
    return const StatusBadge(
      text: 'Out of Stock',
      type: BadgeType.error,
    );
  }

  factory StatusBadge.stock(bool isInStock) {
    return isInStock ? StatusBadge.inStock() : StatusBadge.outOfStock();
  }

  factory StatusBadge.category(String category) {
    return StatusBadge(
      text: category,
      type: BadgeType.info,
      showDot: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();

    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
          ],
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: fontSize ?? 12,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Color _getColor() {
    switch (type) {
      case BadgeType.success:
        return AppColors.success;
      case BadgeType.error:
        return AppColors.error;
      case BadgeType.warning:
        return AppColors.warning;
      case BadgeType.info:
        return AppColors.accent;
      case BadgeType.neutral:
        return AppColors.textSecondary;
    }
  }
}

class CategoryBadge extends StatelessWidget {
  final String category;
  final double? fontSize;

  const CategoryBadge({
    super.key,
    required this.category,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        category,
        style: TextStyle(
          color: AppColors.accent,
          fontSize: fontSize ?? 12,
          fontWeight: FontWeight.w500,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
