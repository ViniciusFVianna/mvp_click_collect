import 'package:flutter_test/flutter_test.dart';
import 'package:front_adm/app/utils/command.dart';

void main() {
  group('Command Test', () {
    test('deve inicializar com valor padrão correto', () {
      final command = Command<int>(data: 10);
      expect(command.data, equals(10));
      expect(command.isLoading, isFalse);
      expect(command.error, isNull);
    });

    test('deve atualizar dados e limpar erro com setData', () {
      final command = Command<String>(data: 'inicial', error: 'erro antigo');
      bool listenerNotified = false;
      command.addListener(() {
        listenerNotified = true;
      });

      command.setData('novo valor');

      expect(command.data, equals('novo valor'));
      expect(command.error, isNull);
      expect(listenerNotified, isTrue);
    });

    test('deve atualizar estado de carregamento com setLoading', () {
      final command = Command<bool>(data: false);
      bool listenerNotified = false;
      command.addListener(() {
        listenerNotified = true;
      });

      command.setLoading(true);

      expect(command.isLoading, isTrue);
      expect(listenerNotified, isTrue);
    });

    test('deve alternar estado de carregamento com toggleLoading', () {
      final command = Command<bool>(data: false);
      expect(command.isLoading, isFalse);

      command.toggleLoading();
      expect(command.isLoading, isTrue);

      command.toggleLoading();
      expect(command.isLoading, isFalse);
    });

    test('deve registrar erro e desligar carregamento com setError', () {
      final command = Command<String>(data: 'teste', isLoading: true);
      bool listenerNotified = false;
      command.addListener(() {
        listenerNotified = true;
      });

      command.setError('Falha na requisição');

      expect(command.error, equals('Falha na requisição'));
      expect(command.isLoading, isFalse);
      expect(listenerNotified, isTrue);
    });
  });
}
