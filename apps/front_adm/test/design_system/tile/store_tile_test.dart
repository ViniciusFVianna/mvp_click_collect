import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front_adm/data/models/store_model.dart';
import 'package:front_adm/design_system/tile/store_tile.dart';

void main() {
  group('StoreTile Widget Test', () {
    final store = StoreModel(
      id: 'store-01',
      name: 'Loja Centro',
      address: 'Rua Principal, 100',
      zipCode: '90000-000',
      stock: 8,
      status: 'DISPONIVEL',
    );

    testWidgets('deve renderizar informações da loja e estoque', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StoreTile(store: store),
          ),
        ),
      );

      expect(find.text('Loja Centro'), findsOneWidget);
      expect(find.text('Rua Principal, 100'), findsOneWidget);
      expect(find.text('Estoque: 8 un.'), findsOneWidget);
    });
  });
}
