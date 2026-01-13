import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_task/core/constants/app_theme.dart';
import 'package:product_task/core/utils/responsive.dart';
import 'package:product_task/feature/product/domain/entities/product_entity.dart';
import 'package:product_task/feature/product/presentation/blocs/cubits/product_cubit_state/product_cubit.dart';

class ProductForm extends StatefulWidget {
  final ProductEntity? product;

  const ProductForm({super.key, this.product});

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _categoryController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;

  bool _inStock = true;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.product?.title ?? '');
    _descriptionController = TextEditingController(
      text: widget.product?.description ?? '',
    );
    _categoryController = TextEditingController(
      text: widget.product?.category ?? '',
    );
    _priceController = TextEditingController(
      text: widget.product?.price.toStringAsFixed(2) ?? '',
    );

    final initialStock = widget.product?.stock ?? 100;
    _stockController = TextEditingController(text: initialStock.toString());
    _inStock = initialStock > 0;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.product != null;
    final isMobile = Responsive.isMobile(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final dialogWidth = isMobile ? screenWidth * 0.95 : 480.0;
    final padding = isMobile ? 16.0 : 24.0;
    
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 8 : 40,
        vertical: isMobile ? 24 : 40,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(isMobile ? 16 : 20)),
      child: Container(
        width: dialogWidth,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(padding),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isMobile ? 16 : 20),
                  topRight: Radius.circular(isMobile ? 16 : 20),
                ),
              ),
              child: Row(
                children: [
                  if (!isMobile)
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        isEditing ? Icons.edit : Icons.add_box,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  if (!isMobile) const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEditing ? 'Edit Product' : 'Add New Product',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isMobile ? 18 : 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (!isMobile)
                          Text(
                            isEditing ? 'Update product details' : 'Fill in the product information',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 13,
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),

            // Form Content
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(padding),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionLabel('Basic Information', isMobile),
                      SizedBox(height: isMobile ? 12 : 16),
                      
                      _buildTextField(
                        controller: _nameController,
                        label: 'Product Name',
                        hint: 'Enter product name',
                        icon: Icons.inventory_2_outlined,
                        isMobile: isMobile,
                        validator: (value) =>
                            value?.trim().isEmpty ?? true ? 'Product name is required' : null,
                      ),
                      SizedBox(height: isMobile ? 12 : 16),
                      
                      _buildTextField(
                        controller: _descriptionController,
                        label: 'Description',
                        hint: 'Enter product description',
                        icon: Icons.description_outlined,
                        maxLines: isMobile ? 2 : 3,
                        isMobile: isMobile,
                      ),
                      SizedBox(height: isMobile ? 12 : 16),
                      
                      _buildTextField(
                        controller: _categoryController,
                        label: 'Category',
                        hint: 'e.g., smartphones, laptops',
                        icon: Icons.category_outlined,
                        isMobile: isMobile,
                        validator: (value) =>
                            value?.trim().isEmpty ?? true ? 'Category is required' : null,
                      ),
                      
                      SizedBox(height: isMobile ? 16 : 24),
                      _buildSectionLabel('Pricing & Stock', isMobile),
                      SizedBox(height: isMobile ? 12 : 16),
                      
                      isMobile
                          ? Column(
                              children: [
                                _buildTextField(
                                  controller: _priceController,
                                  label: 'Price (\$)',
                                  hint: '0.00',
                                  icon: Icons.attach_money,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  isMobile: isMobile,
                                  validator: (value) {
                                    if (value?.trim().isEmpty ?? true) return 'Required';
                                    if (double.tryParse(value!) == null) return 'Invalid price';
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 12),
                                _buildTextField(
                                  controller: _stockController,
                                  label: 'Stock Quantity',
                                  hint: '0',
                                  icon: Icons.inventory_outlined,
                                  keyboardType: TextInputType.number,
                                  isMobile: isMobile,
                                  validator: (value) {
                                    if (value?.trim().isEmpty ?? true) return 'Required';
                                    final qty = int.tryParse(value!);
                                    if (qty == null || qty < 0) return 'Invalid quantity';
                                    return null;
                                  },
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    controller: _priceController,
                                    label: 'Price (\$)',
                                    hint: '0.00',
                                    icon: Icons.attach_money,
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                    isMobile: isMobile,
                                    validator: (value) {
                                      if (value?.trim().isEmpty ?? true) return 'Required';
                                      if (double.tryParse(value!) == null) return 'Invalid price';
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildTextField(
                                    controller: _stockController,
                                    label: 'Stock Quantity',
                                    hint: '0',
                                    icon: Icons.inventory_outlined,
                                    keyboardType: TextInputType.number,
                                    isMobile: isMobile,
                                    validator: (value) {
                                      if (value?.trim().isEmpty ?? true) return 'Required';
                                      final qty = int.tryParse(value!);
                                      if (qty == null || qty < 0) return 'Invalid quantity';
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                      
                      SizedBox(height: isMobile ? 12 : 16),
                      
                      // Stock Toggle
                      _buildStockToggle(isMobile),
                    ],
                  ),
                ),
              ),
            ),

            // Actions
            Container(
              padding: EdgeInsets.all(padding),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(isMobile ? 16 : 20),
                  bottomRight: Radius.circular(isMobile ? 16 : 20),
                ),
              ),
              child: isMobile
                  ? Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(isEditing ? Icons.save : Icons.add, size: 20),
                                const SizedBox(width: 8),
                                Text(isEditing ? 'Save Changes' : 'Add Product'),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: BorderSide(color: AppColors.border),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(isEditing ? Icons.save : Icons.add, size: 20),
                                const SizedBox(width: 8),
                                Text(isEditing ? 'Save Changes' : 'Add Product'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStockToggle(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      decoration: BoxDecoration(
        color: _inStock 
            ? AppColors.success.withOpacity(0.1) 
            : AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _inStock ? AppColors.success : AppColors.error,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            _inStock ? Icons.check_circle : Icons.cancel,
            color: _inStock ? AppColors.success : AppColors.error,
            size: isMobile ? 20 : 24,
          ),
          SizedBox(width: isMobile ? 10 : 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Availability',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    fontSize: isMobile ? 13 : 14,
                  ),
                ),
                if (!isMobile)
                  Text(
                    _inStock ? 'Product is available' : 'Out of stock',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          Switch(
            value: _inStock,
            onChanged: (value) => setState(() => _inStock = value),
            activeColor: AppColors.success,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label, bool isMobile) {
    return Row(
      children: [
        Container(
          width: 4,
          height: isMobile ? 16 : 20,
          decoration: BoxDecoration(
            color: AppColors.accent,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    bool isMobile = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isMobile ? 12 : 13,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: isMobile ? 6 : 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          style: TextStyle(fontSize: isMobile ? 14 : 16),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppColors.textMuted, size: isMobile ? 18 : 20),
            filled: true,
            fillColor: AppColors.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.error),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: isMobile ? 12 : 16,
              vertical: isMobile ? 12 : 14,
            ),
          ),
        ),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final stockQty = int.tryParse(_stockController.text.trim()) ?? 0;

      final product = ProductEntity(
        id: widget.product?.id ?? 0,
        title: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _categoryController.text.trim(),
        price: double.tryParse(_priceController.text.trim()) ?? 0.0,
        discountPercentage: widget.product?.discountPercentage ?? 0.0,
        rating: widget.product?.rating ?? 0.0,
        stock: stockQty,
        tags: widget.product?.tags ?? [],
        brand: widget.product?.brand ?? '',
        sku: widget.product?.sku ?? '',
        weight: widget.product?.weight ?? 0.0,
        dimensions: widget.product?.dimensions ?? {},
        warrantyInformation: widget.product?.warrantyInformation ?? '',
        shippingInformation: widget.product?.shippingInformation ?? '',
        reviews: widget.product?.reviews ?? [],
        returnPolicy: widget.product?.returnPolicy ?? '',
        minimumOrderQuantity: widget.product?.minimumOrderQuantity ?? 1,
        meta: widget.product?.meta ?? {},
        images: widget.product?.images ?? [],
        thumbnail: widget.product?.thumbnail ?? '',
        availableStocksStatus: _inStock ? 'In Stock' : 'Out of Stock',
      );

      if (widget.product == null) {
        BlocProvider.of<ProductCubit>(context).addProduct(product);
      } else {
        BlocProvider.of<ProductCubit>(context).updateProduct(widget.product!.id, product);
      }

      Navigator.pop(context);
    }
  }
}
