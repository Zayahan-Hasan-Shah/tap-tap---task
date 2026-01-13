import 'package:flutter/material.dart' hide FilterChip;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:product_task/core/constants/app_theme.dart';
import 'package:product_task/core/theme/theme_cubit.dart';
import 'package:product_task/core/utils/responsive.dart';
import 'package:product_task/feature/product/domain/entities/product_entity.dart';
import 'package:product_task/feature/product/presentation/blocs/cubits/product_cubit_state/product_cubit.dart';
import 'package:product_task/feature/product/presentation/blocs/cubits/product_cubit_state/product_state.dart';
import 'package:product_task/feature/product/widgets/product_form.dart';
import 'package:product_task/feature/product/widgets/sidebar.dart';
import 'package:product_task/feature/product/widgets/product_card.dart';
import 'package:product_task/feature/global_widgets/global_widgets.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  String _searchQuery = '';
  String _selectedCategory = 'All';
  bool _showInStockOnly = false;
  int _selectedIndex = 1;

  // Pagination
  int _currentPage = 1;
  final int _itemsPerPage = 10;

  // Sorting
  String _sortColumn = 'title';
  bool _sortAscending = true;

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        title: Row(
          children: [
            if (!isMobile) ...[
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
            Text(
              isMobile ? 'Products' : 'Product Dashboard',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: isMobile ? 18 : 20),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () => context.read<ProductCubit>().fetchProducts(),
          ),
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              final isDark = themeMode == ThemeMode.dark;
              return IconButton(
                icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                tooltip: isDark ? 'Light Mode' : 'Dark Mode',
                onPressed: () => context.read<ThemeCubit>().toggleTheme(),
              );
            },
          ),
          if (!isMobile) const SizedBox(width: 8),
          if (!isMobile)
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: AppBarAvatar(initial: 'A'),
            ),
        ],
      ),
      drawer: isMobile
          ? AppDrawer(
              selectedIndex: _selectedIndex,
              onItemSelected: (index) => setState(() => _selectedIndex = index),
            )
          : null,
      body: Row(
        children: [
          if (!isMobile)
            Sidebar(
              selectedIndex: _selectedIndex,
              onItemSelected: (index) => setState(() => _selectedIndex = index),
              isCollapsed: isTablet,
            ),
          Expanded(
            child: Column(
              children: [
                _buildFilters(context),
                Expanded(child: _buildBody(context)),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFAB(isMobile),
    );
  }

  Widget _buildFilters(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);

    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : (isTablet ? 16 : 20)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: isMobile ? _buildMobileFilters() : _buildDesktopFilters(),
    );
  }

  Widget _buildMobileFilters() {
    return Column(
      children: [
        CustomSearchField(
          hintText: 'Search products...',
          onChanged: (value) => setState(() => _searchQuery = value),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildCategoryDropdown(isExpanded: true)),
            const SizedBox(width: 12),
            FilterChip(
              label: 'In Stock',
              isSelected: _showInStockOnly,
              onTap: () => setState(() => _showInStockOnly = !_showInStockOnly),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopFilters() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: CustomSearchField(
            hintText: 'Search products...',
            onChanged: (value) => setState(() => _searchQuery = value),
          ),
        ),
        const SizedBox(width: 16),
        _buildCategoryDropdown(),
        const SizedBox(width: 16),
        FilterChip(
          label: 'In Stock',
          isSelected: _showInStockOnly,
          onTap: () => setState(() => _showInStockOnly = !_showInStockOnly),
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown({bool isExpanded = false}) {
    final categories = ['All', 'smartphones', 'laptops', 'fragrances', 'beauty', 'furniture'];
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCategory,
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
          onChanged: (value) => setState(() => _selectedCategory = value!),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return const LoadingCard(message: 'Loading products...');
        } else if (state is ProductLoaded) {
          final filteredProducts = _filterProducts(state.products);
          return _buildProductContent(filteredProducts);
        } else if (state is ProductError) {
          return ErrorCard(
            message: state.message,
            onRetry: () => context.read<ProductCubit>().fetchProducts(),
          );
        }
        return const EmptyStateCard(
          icon: Icons.inventory_2_outlined,
          title: 'No products found',
          subtitle: 'Start by adding your first product',
        );
      },
    );
  }

  Widget _buildProductContent(List<ProductEntity> products) {
    if (products.isEmpty) {
      return const EmptyStateCard(
        icon: Icons.inventory_2_outlined,
        title: 'No products found',
        subtitle: 'Try adjusting your filters',
      );
    }

    final totalPages = _getTotalPages(products.length);
    final paginatedProducts = _paginateProducts(products);

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return Column(
            children: [
              Expanded(
                child: ProductListView(
                  products: paginatedProducts,
                  onProductTap: (product) => context.go('/product/${product.id}'),
                ),
              ),
              _buildPaginationControls(products.length, totalPages),
            ],
          );
        }
        return Column(
          children: [
            Expanded(child: _buildDataTable(paginatedProducts)),
            _buildPaginationControls(products.length, totalPages),
          ],
        );
      },
    );
  }

  Widget _buildPaginationControls(int totalItems, int totalPages) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 100, top: 12, bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Showing ${((_currentPage - 1) * _itemsPerPage) + 1}-${(_currentPage * _itemsPerPage).clamp(1, totalItems)} of $totalItems',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.first_page, color: _currentPage > 1 ? AppColors.textPrimary : AppColors.textMuted),
                onPressed: _currentPage > 1 ? () => setState(() => _currentPage = 1) : null,
                tooltip: 'First Page',
              ),
              IconButton(
                icon: Icon(Icons.chevron_left, color: _currentPage > 1 ? AppColors.textPrimary : AppColors.textMuted),
                onPressed: _currentPage > 1 ? () => setState(() => _currentPage--) : null,
                tooltip: 'Previous Page',
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$_currentPage / $totalPages',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ),
              IconButton(
                icon: Icon(Icons.chevron_right, color: _currentPage < totalPages ? AppColors.textPrimary : AppColors.textMuted),
                onPressed: _currentPage < totalPages ? () => setState(() => _currentPage++) : null,
                tooltip: 'Next Page',
              ),
              IconButton(
                icon: Icon(Icons.last_page, color: _currentPage < totalPages ? AppColors.textPrimary : AppColors.textMuted),
                onPressed: _currentPage < totalPages ? () => setState(() => _currentPage = totalPages) : null,
                tooltip: 'Last Page',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable(List<ProductEntity> products) {
    return DataTableCard(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(AppColors.tableHeader),
            dataRowMinHeight: 60,
            dataRowMaxHeight: 70,
            columnSpacing: 20,
            horizontalMargin: 20,
            sortColumnIndex: _getSortColumnIndex(),
            sortAscending: _sortAscending,
            columns: [
              DataColumn(
                label: const _TableHeader(text: 'PRODUCT'),
                onSort: (_, __) => _onSort('title'),
              ),
              DataColumn(
                label: const _TableHeader(text: 'CATEGORY'),
                onSort: (_, __) => _onSort('category'),
              ),
              DataColumn(
                label: const _TableHeader(text: 'PRICE'),
                numeric: true,
                onSort: (_, __) => _onSort('price'),
              ),
              DataColumn(
                label: const _TableHeader(text: 'STATUS'),
                onSort: (_, __) => _onSort('stock'),
              ),
              const DataColumn(label: _TableHeader(text: 'ACTIONS')),
            ],
            rows: products.map((product) => _buildDataRow(product)).toList(),
          ),
        ),
      ),
    );
  }

  int _getSortColumnIndex() {
    switch (_sortColumn) {
      case 'title':
        return 0;
      case 'category':
        return 1;
      case 'price':
        return 2;
      case 'stock':
        return 3;
      default:
        return 0;
    }
  }

  DataRow _buildDataRow(ProductEntity product) {
    return DataRow(
      cells: [
        DataCell(_buildProductCell(product)),
        DataCell(CategoryBadge(category: product.category)),
        DataCell(CustomText.price('\$${product.price.toStringAsFixed(2)}')),
        DataCell(StatusBadge.stock(product.isInStock)),
        DataCell(
          ActionButtonGroup(
            onView: () => context.go('/product/${product.id}'),
            onEdit: () => _showProductForm(context, product: product),
            onDelete: () => _showDeleteConfirmation(context, product),
          ),
        ),
      ],
    );
  }

  Widget _buildProductCell(ProductEntity product) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 200),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ProductAvatar(title: product.title, size: 40),
          const SizedBox(width: 12),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  product.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                CustomText.caption('ID: ${product.id}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAB(bool isMobile) {
    if (isMobile) {
      return FloatingActionButton(
        onPressed: () => _showProductForm(context),
        backgroundColor: AppColors.accent,
        child: const Icon(Icons.add),
        
      );    
    }
    return FloatingActionButton.extended(
      onPressed: () => _showProductForm(context),
      icon: const Icon(Icons.add),
      label: const Text('Add Product'),
      backgroundColor: AppColors.accent,
    );
  }

  List<ProductEntity> _filterProducts(List<ProductEntity> products) {
    var filtered = products.where((p) {
      final matchesSearch = p.title.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'All' || p.category == _selectedCategory;
      final matchesStock = !_showInStockOnly || p.isInStock;
      return matchesSearch && matchesCategory && matchesStock;
    }).toList();

    // Apply sorting
    filtered.sort((a, b) {
      int compare;
      switch (_sortColumn) {
        case 'title':
          compare = a.title.compareTo(b.title);
          break;
        case 'category':
          compare = a.category.compareTo(b.category);
          break;
        case 'price':
          compare = a.price.compareTo(b.price);
          break;
        case 'stock':
          compare = (a.isInStock ? 1 : 0).compareTo(b.isInStock ? 1 : 0);
          break;
        default:
          compare = a.title.compareTo(b.title);
      }
      return _sortAscending ? compare : -compare;
    });

    return filtered;
  }

  List<ProductEntity> _paginateProducts(List<ProductEntity> products) {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    if (startIndex >= products.length) return [];
    return products.sublist(startIndex, endIndex.clamp(0, products.length));
  }

  int _getTotalPages(int totalItems) {
    return (totalItems / _itemsPerPage).ceil();
  }

  void _onSort(String column) {
    setState(() {
      if (_sortColumn == column) {
        _sortAscending = !_sortAscending;
      } else {
        _sortColumn = column;
        _sortAscending = true;
      }
    });
  }

  void _showDeleteConfirmation(BuildContext context, ProductEntity product) {
    showDialog(
      context: context,
      builder: (ctx) => ConfirmDialog.delete(
        itemName: product.title,
        onConfirm: () => context.read<ProductCubit>().deleteProduct(product.id),
      ),
    );
  }

  void _showProductForm(BuildContext context, {ProductEntity? product}) {
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: BlocProvider.of<ProductCubit>(context),
        child: ProductForm(product: product),
      ),
    );
  }

  String _capitalize(String s) => s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1)}' : s;
}

class _TableHeader extends StatelessWidget {
  final String text;

  const _TableHeader({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
        fontSize: 12,
        letterSpacing: 0.5,
      ),
    );
  }
}
