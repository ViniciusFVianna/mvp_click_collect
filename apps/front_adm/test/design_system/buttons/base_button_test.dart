import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front_adm/design_system/buttons/base_button.dart';

void main() {
  group('BaseButton Widget Test', () {
    testWidgets('deve exibir o rótulo do botão', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BaseButton(label: 'Salvar'),
          ),
        ),
      );

      expect(find.text('Salvar'), findsOneWidget);
    });

    testWidgets('deve disparar onPressed ao ser clicado', (WidgetTester tester) async {
      bool clicked = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BaseButton(
              label: 'Confirmar',
              onPressed: () => clicked = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Confirmar'));
      expect(clicked, isTrue);
    });

    testWidgets('deve exibir CircularProgressIndicator quando isLoading for true', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BaseButton(
              label: 'Carregando',
              isLoading: true,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
