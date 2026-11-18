import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front_adm/app/navigation/router_register.dart';

void main() {
  group('RouterRegister Test', () {
    test('deve ser um singleton', () {
      final instance1 = RouterRegister.I;
      final instance2 = RouterRegister.I;
      expect(identical(instance1, instance2), isTrue);
    });

    test('deve registrar rotas e construir GoRouter', () {
      final register = RouterRegister.I;
      register();

      final router = register.router;
      expect(router, isNotNull);
      expect(register.globalContext, isA<GlobalKey<NavigatorState>>());
    });
  });
}
