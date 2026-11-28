import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../../../features/orders/domain/model/order_model.dart';
import '../../../features/stores/domain/model/store_model.dart';
import 'home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController controller = HomeController();

  @override
  void initState() {
    super.initState();
    controller.onInit();
    controller.stores.addListener(_onStateChanged);
    controller.searchQuery.addListener(_onStateChanged);
    controller.cep.addListener(_onStateChanged);
    controller.produtoId.addListener(_onStateChanged);
    controller.orders.addListener(_onStateChanged);
    controller.orderSearchQuery.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    controller.stores.removeListener(_onStateChanged);
    controller.searchQuery.removeListener(_onStateChanged);
    controller.cep.removeListener(_onStateChanged);
    controller.produtoId.removeListener(_onStateChanged);
    controller.orders.removeListener(_onStateChanged);
    controller.orderSearchQuery.removeListener(_onStateChanged);
    super.dispose();
  }

  void _onStateChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final filteredStores = controller.filteredStores;
    final filteredOrders = controller.filteredOrders;

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
            onPressed: () {
              controller.fetchStores();
              controller.fetchOrders();
            },
            tooltip: 'Atualizar dados',
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
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildStoresSection(),
                const SizedBox(height: 16),
                _buildOrdersSection(filteredOrders),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoresSection() {
    if (controller.stores.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (controller.stores.error != null) {
      return _buildError(
        message: 'Erro ao carregar lojas: ${controller.stores.error}',
        onRetry: controller.fetchStores,
      );
    }
    if (controller.filteredStores.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Nenhuma loja encontrada.',
            style: TextStyle(color: AppColors.textMuted, fontSize: 16),
          ),
        ),
      );
    }

    return Card(
      child: ExpansionTile(
        backgroundColor: Colors.white,
        title: Text('Lojas (${controller.filteredStores.length})'),
        children: controller.filteredStores.map(_buildStoreCard).toList(),
      ),
    );
  }

  Widget _buildOrdersSection(List<OrderResponseModel> filteredOrders) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppInput(
          label: 'Buscar pedido',
          hint: 'ID, cliente, loja, produto ou status...',
          prefixIcon: Icons.search,
          onChanged: controller.setOrderSearchQuery,
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: controller.fetchOrders,
          icon: const Icon(Icons.search),
          label: const Text('Buscar pedidos'),
        ),
        const SizedBox(height: 12),
        if (controller.orders.isLoading)
          const Center(child: CircularProgressIndicator())
        else if (controller.orders.error != null)
          _buildError(
            message: 'Erro ao carregar pedidos: ${controller.orders.error}',
            onRetry: controller.fetchOrders,
          )
        else if (filteredOrders.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Nenhum pedido encontrado.',
                style: TextStyle(color: AppColors.textMuted, fontSize: 16),
              ),
            ),
          )
        else
          Card(
            child: ExpansionTile(
              backgroundColor: Colors.white,
              title: Text('Pedidos (${filteredOrders.length})'),
              children: filteredOrders.map(_buildOrderCard).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildError({required String message, required VoidCallback onRetry}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.error_outline, size: 40, color: AppColors.error),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(OrderResponseModel order) {
    return ListTile(
      leading: const Icon(Icons.receipt_long, color: AppColors.primaryBase),
      title: Text(order.clienteNome.isEmpty ? order.id : order.clienteNome),
      subtitle: Text(
        'Pedido: ${order.id}\n'
        'Loja: ${order.lojaId} • Produto: ${order.produtoId}\n'
        'Status: ${order.status}',
      ),
      isThreeLine: true,
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
