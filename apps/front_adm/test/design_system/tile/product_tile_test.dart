import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front_adm/data/models/product_model.dart';
import 'package:front_adm/design_system/tile/product_tile.dart';

void main() {
  group('ProductTile Widget Test', () {
    final product = ProductModel(
      id: 'prod-01',
      name: 'Fone Bluetooth',
      description: 'Fone de ouvido sem fio',
      price: 299.90,
      category: 'Áudio',
      imageUrl: '',
    );

    testWidgets('deve exibir nome, preço e categoria do produto', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductTile(product: product),
          ),
        ),
      );

      expect(find.text('Fone Bluetooth'), findsOneWidget);
      expect(find.text('R\$ 299.90'), findsOneWidget);
      expect(find.text('Áudio'), findsOneWidget);
    });
  });
}
