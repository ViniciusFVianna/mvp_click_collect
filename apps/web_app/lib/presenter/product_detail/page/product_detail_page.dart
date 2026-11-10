import 'package:flutter/material.dart';
import '../../../data/models/product_model.dart';
import '../../../design_system/theme/colors/app_colors.dart';
import '../../../design_system/buttons/base_button.dart';
import '../../../app/navigation/app_navigator.dart';
import '../../store_selector/page/store_selector_page.dart';
import 'product_detail_controller.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductModel? product;

  const ProductDetailPage({super.key, this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final ProductDetailController controller = ProductDetailController();

  @override
  void initState() {
    super.initState();
    controller.onInit(widget.product);
  }

  @override
  Widget build(BuildContext context) {
    final item = controller.product.data ?? widget.product;

    if (item == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detalhes do Produto')),
        body: const Center(child: Text('Produto não encontrado.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      height: 350,
                      width: double.infinity,
                      color: Colors.white,
                      child: Image.network(
                        item.imageUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Center(
                          child: Icon(Icons.image_not_supported, size: 64, color: AppColors.textMuted),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBase.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      item.category,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryBase,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'R\$ ${item.price.toStringAsFixed(2).replaceAll('.', ',')}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: AppColors.accentOrange,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Descrição do Produto',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.description,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.success.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.storefront_rounded, size: 28, color: AppColors.success),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Disponível para Click & Collect! Escolha a loja mais conveniente para retirar seu pedido sem pagar frete.',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.success,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: BaseButton(
                      label: 'Ver Lojas para Retirada (Click & Collect)',
                      icon: Icons.location_on_outlined,
                      onPressed: () {
                        AppNavigator.push(
                          StoreSelectorPage,
                          extra: item,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
