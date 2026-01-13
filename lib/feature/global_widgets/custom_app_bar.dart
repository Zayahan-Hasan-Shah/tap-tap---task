import 'package:flutter/material.dart';
import 'package:product_task/core/constants/app_theme.dart';
import 'package:product_task/core/utils/responsive.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? mobileTitle;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showLogo;
  final VoidCallback? onRefresh;
  final Widget? avatar;
  final bool centerTitle;
  final Color? backgroundColor;

  const CustomAppBar({
    super.key,
    required this.title,
    this.mobileTitle,
    this.actions,
    this.leading,
    this.showLogo = true,
    this.onRefresh,
    this.avatar,
    this.centerTitle = false,
    this.backgroundColor,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return AppBar(
      elevation: 0,
      backgroundColor: backgroundColor ?? AppColors.primary,
      centerTitle: centerTitle,
      leading: leading,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showLogo && !isMobile) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.inventory_2, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Text(
              isMobile ? (mobileTitle ?? title) : title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: isMobile ? 18 : 20,
              ),
            ),
          ),
        ],
      ),
      actions: [
        if (onRefresh != null)
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: onRefresh,
          ),
        if (actions != null) ...actions!,
        if (avatar != null && !isMobile) ...[
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: avatar,
          ),
        ],
      ],
    );
  }
}

class AppBarAvatar extends StatelessWidget {
  final String initial;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const AppBarAvatar({
    super.key,
    required this.initial,
    this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        backgroundColor: backgroundColor ?? AppColors.accent,
        radius: 18,
        child: Text(
          initial.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
