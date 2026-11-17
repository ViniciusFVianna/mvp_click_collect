import 'package:flutter/material.dart';
import '../../../data/models/product_model.dart';
import '../../../design_system/theme/colors/app_colors.dart';
import '../../../design_system/tile/store_tile.dart';
import '../../../design_system/input/app_input.dart';
import '../../../design_system/buttons/base_button.dart';
import '../../../app/navigation/app_navigator.dart';
import '../../checkout/page/checkout_page.dart';
import 'store_selector_controller.dart';

class StoreSelectorPage extends StatefulWidget {
  final ProductModel? product;

  const StoreSelectorPage({super.key, this.product});

  @override
  State<StoreSelectorPage> createState() => _StoreSelectorPageState();
}

class _StoreSelectorPageState extends State<StoreSelectorPage> {
  final StoreSelectorController controller = StoreSelectorController();
  final TextEditingController cepTextController = TextEditingController(text: '01310-100');

  @override
  void initState() {
    super.initState();
    controller.onInit(widget.product);
  }

  @override
  void dispose() {
    cepTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecionar Loja de Retirada'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: ListenableBuilder(
              listenable: Listenable.merge([
                controller.stores,
                controller.selectedStore,
                controller.cep,
              ]),
              builder: (context, _) {
                final selectedStore = controller.selectedStore.data;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (product != null) ...[
                      Card(
                        elevation: 0,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: AppColors.border),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  product.imageUrl,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 40),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'R\$ ${product.price.toStringAsFixed(2).replaceAll('.', ',')}',
                                      style: const TextStyle(
                                        color: AppColors.accentOrange,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    const Text(
                      'Buscar Lojas Próximas',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Informe seu CEP para verificar a disponibilidade de estoque para Click & Collect.',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: AppInput(
                            label: 'CEP para busca',
                            hint: 'Ex: 01310-100',
                            controller: cepTextController,
                            keyboardType: TextInputType.number,
                            prefixIcon: Icons.location_on,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Padding(
                          padding: const EdgeInsets.only(top: 22),
                          child: BaseButton(
                            label: 'Buscar CEP',
                            icon: Icons.search,
                            onPressed: () {
                              controller.setCep(cepTextController.text.trim());
                              controller.fetchStores();
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      'Lojas Encontradas com Click & Collect',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),

                    if (controller.stores.isLoading)
                      const Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (controller.stores.data.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Center(
                          child: Text(
                            'Nenhuma loja encontrada para este CEP.',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.stores.data.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final store = controller.stores.data[index];
                          final isSelected = selectedStore?.id == store.id;
                          return StoreTile(
                            store: store,
                            isSelected: isSelected,
                            onSelect: () => controller.selectStore(store),
                          );
                        },
                      ),

                    const SizedBox(height: 32),

                    SizedBox(
                      width: double.infinity,
                      child: BaseButton(
                        label: 'Continuar para Checkout',
                        icon: Icons.arrow_forward,
                        onPressed: selectedStore != null
                            ? () {
                                AppNavigator.push(
                                  CheckoutPage,
                                  extra: {
                                    'product': product,
                                    'store': selectedStore,
                                  },
                                );
                              }
                            : null,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
