import 'package:design_system/design_system.dart' as design_system;
import 'package:material_ui/material_ui.dart';

import '../../features/stores/domain/model/store_model.dart';

class StoreTile extends StatelessWidget {
  final StoreModel store;
  final bool isSelected;
  final VoidCallback onSelect;

  const StoreTile({
    super.key,
    required this.store,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) => design_system.StoreTile(
        name: store.name,
        address: store.address,
        stock: store.status == 'INDISPONIVEL' ? 0 : store.stock,
        distance: store.distance,
        isSelected: isSelected,
        onTap: onSelect,
      );
}
