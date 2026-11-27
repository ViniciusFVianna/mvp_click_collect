import 'package:flutter_test/flutter_test.dart';
import 'package:front_adm/app/app.dart';
import 'package:front_adm/app/injection/injector.dart';
import 'package:front_adm/app/navigation/router_register.dart';

void main() {
  testWidgets('App initialization test', (WidgetTester tester) async {
    Injector.I();
    RouterRegister.I();
    await tester.pumpWidget(const App());
    expect(find.byType(App), findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 2));
  });
}
