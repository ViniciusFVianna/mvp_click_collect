import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front_adm/design_system/input/app_input.dart';

void main() {
  group('AppInput Widget Test', () {
    testWidgets('deve renderizar label e hint text', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppInput(
              label: 'Nome',
              hint: 'Digite seu nome',
            ),
          ),
        ),
      );

      expect(find.text('Nome'), findsOneWidget);
      expect(find.text('Digite seu nome'), findsOneWidget);
    });

    testWidgets('deve disparar callback onChanged ao digitar texto', (WidgetTester tester) async {
      String typedValue = '';
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppInput(
              label: 'Busca',
              onChanged: (val) => typedValue = val,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'Teste');
      expect(typedValue, equals('Teste'));
    });
  });
}
