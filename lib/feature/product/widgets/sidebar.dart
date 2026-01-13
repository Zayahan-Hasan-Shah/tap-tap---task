import 'package:flutter/material.dart';
import 'package:product_task/core/constants/app_theme.dart';

class Sidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final bool isCollapsed;

  const Sidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    this.isCollapsed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isCollapsed ? 70 : 240,
      color: AppColors.sidebarBackground,
      child: Column(
        children: [
          _buildHeader(),
          const Divider(color: Colors.white12, height: 1),
          const SizedBox(height: 16),
          _buildItem(Icons.dashboard_outlined, 'Dashboard', 0),
          _buildItem(Icons.inventory_2, 'Products', 1),
          _buildItem(Icons.category_outlined, 'Categories', 2),
          _buildItem(Icons.analytics_outlined, 'Analytics', 3),
          const Spacer(),
          const Divider(color: Colors.white12, height: 1),
          _buildItem(Icons.settings_outlined, 'Settings', 4),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(isCollapsed ? 16 : 24),
      child: isCollapsed
          ? _buildLogo()
          : Row(
              children: [
                _buildLogo(),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Product Pro',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Admin Panel',
                        style: TextStyle(color: Colors.white54, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildLogo() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(Icons.inventory_2, color: Colors.white, size: 24),
    );
  }

  Widget _buildItem(IconData icon, String title, int index) {
    final isSelected = selectedIndex == index;
    
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isCollapsed ? 8 : 12,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.sidebarItemActive : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: isCollapsed
          ? Tooltip(
              message: title,
              child: InkWell(
                onTap: () => onItemSelected(index),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Icon(
                    icon,
                    color: isSelected ? Colors.white : Colors.white60,
                    size: 24,
                  ),
                ),
              ),
            )
          : ListTile(
              leading: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.white60,
                size: 22,
              ),
              title: Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white70,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
              onTap: () => onItemSelected(index),
              dense: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              hoverColor: AppColors.sidebarItemHover,
            ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const AppDrawer({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.sidebarBackground,
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: AppColors.primaryDark),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.inventory_2,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Product Manager',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Admin Panel',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(context, Icons.dashboard, 'Dashboard', 0),
          _buildDrawerItem(context, Icons.inventory_2, 'Products', 1),
          _buildDrawerItem(context, Icons.category, 'Categories', 2),
          _buildDrawerItem(context, Icons.analytics, 'Analytics', 3),
          const Spacer(),
          const Divider(color: Colors.white24),
          _buildDrawerItem(context, Icons.settings, 'Settings', 4),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, IconData icon, String title, int index) {
    final isSelected = selectedIndex == index;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.sidebarItemActive : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white, size: 22),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        onTap: () {
          onItemSelected(index);
          Navigator.pop(context);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
