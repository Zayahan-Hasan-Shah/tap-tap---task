import 'package:flutter/material.dart' hide FilterChip;
import 'package:product_task/core/constants/app_theme.dart';
import 'package:product_task/core/utils/responsive.dart';
import 'package:product_task/feature/global_widgets/custom_search_field.dart';

class ProductFilters extends StatelessWidget {
  final String searchQuery;
  final String selectedCategory;
  final bool showInStockOnly;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onCategoryChanged;
  final ValueChanged<bool> onStockFilterChanged;
  final List<String> categories;

  const ProductFilters({
    super.key,
    required this.searchQuery,
    required this.selectedCategory,
    required this.showInStockOnly,
    required this.onSearchChanged,
    required this.onCategoryChanged,
    required this.onStockFilterChanged,
    this.categories = const ['All', 'smartphones', 'laptops', 'fragrances', 'beauty', 'furniture'],
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);

    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : (isTablet ? 16 : 20)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        CustomSearchField(
          hintText: 'Search products...',
          onChanged: onSearchChanged,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildCategoryDropdown(isExpanded: true)),
            const SizedBox(width: 12),
            _buildStockFilter(),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: CustomSearchField(
            hintText: 'Search products...',
            onChanged: onSearchChanged,
          ),
        ),
        const SizedBox(width: 16),
        _buildCategoryDropdown(),
        const SizedBox(width: 16),
        _buildStockFilter(),
      ],
    );
  }

  Widget _buildCategoryDropdown({bool isExpanded = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedCategory,
          isExpanded: isExpanded,
          icon: const Icon(Icons.keyboard_arrow_down, size: 20),
          items: categories.map((cat) => DropdownMenuItem(
            value: cat,
            child: Text(
              cat == 'All' ? 'All Categories' : _capitalize(cat),
              style: TextStyle(color: AppColors.textPrimary, fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          )).toList(),
          onChanged: (value) => onCategoryChanged(value!),
        ),
      ),
    );
  }

  Widget _buildStockFilter() {
    return FilterChip(
      label: 'In Stock',
      isSelected: showInStockOnly,
      onTap: () => onStockFilterChanged(!showInStockOnly),
    );
  }

  String _capitalize(String s) => s.isNotEmpty 
      ? '${s[0].toUpperCase()}${s.substring(1)}' 
      : s;
}
