import 'package:flutter/material.dart';
import '../../../design_system/theme/colors/app_colors.dart';
import '../../../design_system/input/app_input.dart';
import '../../../design_system/buttons/base_button.dart';
import 'checkout_controller.dart';

class CheckoutPage extends StatefulWidget {
  final Map<String, dynamic>? data;

  const CheckoutPage({super.key, this.data});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final CheckoutController controller = CheckoutController();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nomeController = TextEditingController(text: 'Vinicius Vianna');
  final TextEditingController cpfController = TextEditingController(text: '12345678901');
  final TextEditingController terceiroNomeController = TextEditingController();
  final TextEditingController terceiroCpfController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.onInit(widget.data);
  }

  @override
  void dispose() {
    nomeController.dispose();
    cpfController.dispose();
    terceiroNomeController.dispose();
    terceiroCpfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = controller.product;
    final store = controller.store;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout Click & Collect'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Form(
              key: _formKey,
              child: ListenableBuilder(
                listenable: Listenable.merge([
                  controller.orderResult,
                  controller.isAuthorizedThirdParty,
                ]),
                builder: (context, _) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Resumo da Retirada em Loja',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          children: [
                            if (product != null)
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      product.imageUrl,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, _, _) => const Icon(Icons.image),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      product.name,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Text(
                                    'R\$ ${product.price.toStringAsFixed(2).replaceAll('.', ',')}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.accentOrange,
                                    ),
                                  ),
                                ],
                              ),
                            const Divider(height: 24),
                            if (store != null)
                              Row(
                                children: [
                                  const Icon(Icons.storefront, color: AppColors.primaryBase),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          store.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                        Text(
                                          store.address,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.success.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text(
                                      'Frete Grátis',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.success,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      const Text(
                        'Dados do Titular da Compra',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),

                      AppInput(
                        label: 'Nome Completo',
                        hint: 'Digite seu nome completo',
                        controller: nomeController,
                        prefixIcon: Icons.person,
                        validator: (value) {
                          if (value == null || value.trim().length < 3) {
                            return 'Informe o nome do cliente (mín. 3 caracteres).';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      AppInput(
                        label: 'CPF do Titular (11 dígitos)',
                        hint: 'Apenas números (Ex: 12345678901)',
                        controller: cpfController,
                        keyboardType: TextInputType.number,
                        prefixIcon: Icons.badge,
                        validator: (value) {
                          final clean = value?.replaceAll(RegExp(r'\D'), '');
                          if (clean == null || clean.length != 11) {
                            return 'O CPF deve conter exatamente 11 dígitos.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      SwitchListTile(
                        value: controller.isAuthorizedThirdParty.data,
                        onChanged: (val) => controller.toggleThirdParty(val),
                        title: const Text(
                          'Autorizar outra pessoa a retirar o pedido',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: const Text(
                          'O terceiro precisará apresentar documento com foto e este CPF informado.',
                          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                        activeColor: AppColors.primaryBase,
                        contentPadding: EdgeInsets.zero,
                      ),

                      if (controller.isAuthorizedThirdParty.data) ...[
                        const SizedBox(height: 12),
                        AppInput(
                          label: 'Nome do Terceiro Autorizado',
                          hint: 'Nome de quem irá retirar',
                          controller: terceiroNomeController,
                          prefixIcon: Icons.person_add,
                          validator: (value) {
                            if (controller.isAuthorizedThirdParty.data &&
                                (value == null || value.trim().isEmpty)) {
                              return 'Informe o nome da pessoa autorizada.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        AppInput(
                          label: 'CPF do Terceiro Autorizado',
                          hint: '11 dígitos de quem irá retirar',
                          controller: terceiroCpfController,
                          keyboardType: TextInputType.number,
                          prefixIcon: Icons.badge_outlined,
                          validator: (value) {
                            if (controller.isAuthorizedThirdParty.data) {
                              final clean = value?.replaceAll(RegExp(r'\D'), '');
                              if (clean == null || clean.length != 11) {
                                return 'Informe um CPF de 11 dígitos válido.';
                              }
                            }
                            return null;
                          },
                        ),
                      ],

                      const SizedBox(height: 32),

                      if (controller.orderResult.error != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(
                            'Erro ao finalizar pedido: ${controller.orderResult.error}',
                            style: const TextStyle(color: AppColors.error),
                          ),
                        ),

                      SizedBox(
                        width: double.infinity,
                        child: BaseButton(
                          label: 'Confirmar Pedido Click & Collect',
                          icon: Icons.check_circle_outline,
                          isLoading: controller.orderResult.isLoading,
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              controller.submitOrder(
                                clienteNome: nomeController.text.trim(),
                                clienteCpf: cpfController.text.trim(),
                                terceiroNome: terceiroNomeController.text.trim(),
                                terceiroCpf: terceiroCpfController.text.trim(),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
