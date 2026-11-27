import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../features/stores/domain/model/store_model.dart';
import 'home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeController controller;

  @override
  void initState() {
    super.initState();
    controller = GetIt.I<HomeController>();
    controller.onInit();
    controller.stores.addListener(_onStateChanged);
    controller.searchQuery.addListener(_onStateChanged);
    controller.cep.addListener(_onStateChanged);
    controller.produtoId.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    controller.stores.removeListener(_onStateChanged);
    controller.searchQuery.removeListener(_onStateChanged);
    controller.cep.removeListener(_onStateChanged);
    controller.produtoId.removeListener(_onStateChanged);
    super.dispose();
  }

  void _onStateChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final filteredStores = controller.filteredStores;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.admin_panel_settings, color: Colors.white),
            SizedBox(width: 8),
            Text('Painel Admin - Click & Collect'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.fetchStores,
            tooltip: 'Atualizar lojas',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                AppInput(
                  label: 'Buscar loja',
                  hint: 'Buscar por ID, nome, endereço ou CEP...',
                  prefixIcon: Icons.search,
                  onChanged: controller.setSearchQuery,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: AppInput(
                        label: 'CEP',
                        hint: '93260-000',
                        prefixIcon: Icons.pin_drop,
                        onChanged: controller.setCep,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppInput(
                        label: 'Produto',
                        hint: 'produto_id',
                        prefixIcon: Icons.shopping_bag,
                        onChanged: controller.setProdutoId,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: controller.fetchStores,
                    icon: const Icon(Icons.search),
                    label: const Text('Buscar lojas'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: controller.stores.isLoading
                ? const Center(child: CircularProgressIndicator())
                : controller.stores.error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: AppColors.error,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Erro ao carregar lojas: ${controller.stores.error}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: controller.fetchStores,
                          child: const Text('Tentar novamente'),
                        ),
                      ],
                    ),
                  )
                : filteredStores.isEmpty
                ? const Center(
                    child: Text(
                      'Nenhuma loja encontrada.',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredStores.length,
                    itemBuilder: (context, index) {
                      final store = filteredStores[index];
                      return _buildStoreCard(store);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreCard(StoreModel store) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  store.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.primaryBase,
                  ),
                ),
                Text(
                  '${store.stock} unidades',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            Row(
              children: [
                const Icon(
                  Icons.store,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  store.id,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    store.address.isNotEmpty
                        ? '${store.address} - CEP ${store.zipCode}'
                        : 'CEP ${store.zipCode}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
