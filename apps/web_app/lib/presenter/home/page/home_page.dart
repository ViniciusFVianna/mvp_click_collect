import 'package:material_ui/material_ui.dart';

import '../../../design_system/theme/colors/app_colors.dart';
import '../../../design_system/tile/product_tile.dart';
import '../../../design_system/input/app_input.dart';
import '../../../app/navigation/app_navigator.dart';
import '../../product_detail/page/product_detail_page.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.shopping_bag_outlined, color: Colors.white),
            SizedBox(width: 10),
            Text(
              'Click & Collect',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.fetchProducts(),
            tooltip: 'Atualizar Catálogo',
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: Listenable.merge([
          controller.products,
          controller.selectedCategory,
          controller.searchQuery,
        ]),
        builder: (context, _) {
          if (controller.products.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.products.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text(
                    'Erro ao carregar produtos: ${controller.products.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => controller.fetchProducts(),
                    child: const Text('Tentar Novamente'),
                  ),
                ],
              ),
            );
          }

          final list = controller.filteredProducts;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primaryBase, AppColors.primaryLight],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Retire na Loja mais Próxima!',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  'Compre online com segurança e retire o seu produto no mesmo dia sem taxa de frete.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          const CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.white24,
                            child: Icon(Icons.storefront_rounded, size: 32, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    AppInput(
                      label: 'Buscar Produtos',
                      hint: 'Digite o nome do produto...',
                      prefixIcon: Icons.search,
                      onChanged: (val) => controller.setSearchQuery(val),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: .center,
                      spacing: 16,
                      children: controller.categories.map((cat) {
                        final isSelected = controller.selectedCategory.data == cat;
                        return InkWell(
                          onTap: () => controller.selectCategory(cat),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          
                            child: Column(
                                mainAxisAlignment: .start,
                                crossAxisAlignment: .center,
                                children: [
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundColor:AppColors.primaryBase,
                                    child: _getCategoryIcon(cat, isSelected),
                                  ),
                                  Text(
                                    cat,
                                    style: TextStyle(
                                      color: AppColors.textPrimary,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                          )
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Catálogo de Produtos (${list.length})',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    if (list.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Center(
                          child: Text(
                            'Nenhum produto encontrado.',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        ),
                      )
                    else
                      LayoutBuilder(
                        builder: (context, constraints) {
                          int crossAxisCount = 2;
                          if (constraints.maxWidth > 900) {
                            crossAxisCount = 4;
                          } else if (constraints.maxWidth > 600) {
                            crossAxisCount = 3;
                          }

                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.65,
                            ),
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              final product = list[index];
                              return ProductTile(
                                product: product,
                                onTap: () {
                                  AppNavigator.push(
                                    ProductDetailPage,
                                    extra: product,
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _getCategoryIcon(String category, bool isSelected) {
    switch (category.toLowerCase()) {
      case 'eletrônicos':
        return  Icon(Icons.devices_outlined, size: 30, color: isSelected ? Colors.white : AppColors.textPrimary);
      case 'televisores':
        return Icon(Icons.tv_outlined, size: 30, color: isSelected ? Colors.white : AppColors.textPrimary);
      case 'eletroportáteis':
        return Icon(Icons.laptop_outlined, size: 30, color: isSelected ? Colors.white : AppColors.textPrimary);
      case 'informática':
        return Icon(Icons.devices_outlined, size: 30, color: isSelected ? Colors.white : AppColors.textPrimary);
      default:
        return Icon(Icons.category_outlined, size: 30, color: isSelected ? Colors.white : AppColors.textPrimary);
    }
  }
}
