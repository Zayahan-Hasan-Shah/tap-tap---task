import 'package:flutter/material.dart';
import 'package:product_task/core/constants/app_theme.dart';
import 'package:product_task/feature/product/domain/entities/product_entity.dart';
import 'package:product_task/feature/product/widgets/product_card.dart';
import 'package:product_task/feature/global_widgets/status_badge.dart';
import 'package:product_task/feature/global_widgets/custom_button.dart';
import 'package:product_task/feature/global_widgets/custom_card.dart';

class ProductDataTable extends StatelessWidget {
  final List<ProductEntity> products;
  final Function(ProductEntity) onView;
  final Function(ProductEntity) onEdit;
  final Function(ProductEntity) onDelete;

  const ProductDataTable({
    super.key,
    required this.products,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return DataTableCard(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width - 300,
          ),
          child: SingleChildScrollView(
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(AppColors.tableHeader),
              dataRowMinHeight: 60,
              dataRowMaxHeight: 70,
              columnSpacing: 20,
              horizontalMargin: 20,
              columns: const [
                DataColumn(label: _TableHeader(text: 'PRODUCT')),
                DataColumn(label: _TableHeader(text: 'CATEGORY')),
                DataColumn(label: _TableHeader(text: 'PRICE')),
                DataColumn(label: _TableHeader(text: 'STATUS')),
                DataColumn(label: _TableHeader(text: 'ACTIONS')),
              ],
              rows: products.map((product) => _buildRow(product)).toList(),
            ),
          ),
        ),
      ),
    );
  }

  DataRow _buildRow(ProductEntity product) {
    return DataRow(
      cells: [
        DataCell(_ProductCell(product: product)),
        DataCell(CategoryBadge(category: product.category)),
        DataCell(_PriceCell(price: product.price)),
        DataCell(StatusBadge.stock(product.isInStock)),
        DataCell(
          ActionButtonGroup(
            onView: () => onView(product),
            onEdit: () => onEdit(product),
            onDelete: () => onDelete(product),
          ),
        ),
      ],
    );
  }
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

class _ProductCell extends StatelessWidget {
  final ProductEntity product;

  const _ProductCell({required this.product});

  @override
  Widget build(BuildContext context) {
    return Row(
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
              Text(
                'ID: ${product.id}',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PriceCell extends StatelessWidget {
  final double price;

  const _PriceCell({required this.price});

  @override
  Widget build(BuildContext context) {
    return Text(
      '\$${price.toStringAsFixed(2)}',
      style: TextStyle(
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }
}
