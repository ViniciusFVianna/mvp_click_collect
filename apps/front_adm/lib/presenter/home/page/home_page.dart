import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../features/orders/domain/model/order_model.dart';
import '../../../design_system/theme/colors/app_colors.dart';
import '../../../design_system/input/app_input.dart';
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
    controller.orders.addListener(_onStateChanged);
    controller.selectedStatusFilter.addListener(_onStateChanged);
    controller.searchQuery.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    controller.orders.removeListener(_onStateChanged);
    controller.selectedStatusFilter.removeListener(_onStateChanged);
    controller.searchQuery.removeListener(_onStateChanged);
    super.dispose();
  }

  void _onStateChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
            onPressed: controller.fetchOrders,
            tooltip: 'Atualizar Pedidos',
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
                  label: 'Buscar Pedido',
                  hint: 'Buscar por ID, Nome do Cliente ou CPF...',
                  prefixIcon: Icons.search,
                  onChanged: controller.setSearchQuery,
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: controller.statusFilters.map((status) {
                      final isSelected = controller.selectedStatusFilter.data == status;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(_formatStatusLabel(status)),
                          selected: isSelected,
                          selectedColor: AppColors.primaryBase,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          onSelected: (_) => controller.filterByStatus(status),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: controller.orders.isLoading
                ? const Center(child: CircularProgressIndicator())
                : controller.orders.error != null
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
                              'Erro ao carregar pedidos: ${controller.orders.error}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: controller.fetchOrders,
                              child: const Text('Tentar novamente'),
                            ),
                          ],
                        ),
                      )
                : filteredOrders.isEmpty
                    ? const Center(
                        child: Text(
                          'Nenhum pedido encontrado.',
                          style: TextStyle(color: AppColors.textMuted, fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredOrders.length,
                        itemBuilder: (context, index) {
                          final order = filteredOrders[index];
                          return _buildOrderCard(order);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(OrderResponseModel order) {
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
                  order.id,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.primaryBase,
                  ),
                ),
                _buildStatusBadge(order.status),
              ],
            ),
            const Divider(height: 20),
            Row(
              children: [
                const Icon(Icons.person, size: 18, color: AppColors.textSecondary),
                const SizedBox(width: 8),
                Text(
                  order.clienteNome,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '(${order.clienteCpf})',
                  style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.store, size: 18, color: AppColors.textSecondary),
                const SizedBox(width: 8),
                Text(
                  'Loja: ${order.lojaId}',
                  style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.shopping_bag, size: 18, color: AppColors.textSecondary),
                const SizedBox(width: 8),
                Text(
                  'Produto: ${order.produtoId}',
                  style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status.toUpperCase()) {
      case 'PENDENTE':
        color = AppColors.warning;
        break;
      case 'EM_SEPARACAO':
        color = AppColors.primaryLight;
        break;
      case 'PRONTO_PARA_RETIRADA':
        color = AppColors.accentOrange;
        break;
      case 'ENTREGUE':
        color = AppColors.success;
        break;
      default:
        color = AppColors.textMuted;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        _formatStatusLabel(status),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  String _formatStatusLabel(String status) {
    switch (status.toUpperCase()) {
      case 'TODOS':
        return 'Todos';
      case 'PENDENTE':
        return 'Pendente';
      case 'EM_SEPARACAO':
        return 'Em Separação';
      case 'PRONTO_PARA_RETIRADA':
        return 'Pronto p/ Retirada';
      case 'ENTREGUE':
        return 'Entregue';
      default:
        return status;
    }
  }
}
