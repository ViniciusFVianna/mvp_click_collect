import 'package:flutter_test/flutter_test.dart';
import 'package:front_adm/app/app.dart';
import 'package:front_adm/app/setup.dart';

void main() {
  testWidgets('App initialization test', (WidgetTester tester) async {
    await Setup.I();
    await tester.pumpWidget(const App());
    expect(find.byType(App), findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 3));
  });
}
