import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import '../app/injection/injector_base.dart';
import 'boundaries/secure_storage_facade.dart';
import 'boundaries/speech_facade.dart';
import 'network/custom_client_http.dart';
import 'network/http_impl.dart';

class ShareInjector implements InjectorBase {
  @override
  void call() {
    GetIt.I.registerLazySingleton<SecureStorageFacade>(() => SecureStorageFacade());
    GetIt.I.registerLazySingleton<SpeechFacade>(() => SpeechFacade());
    GetIt.I.registerLazySingleton<CustomClientHttp>(
      () => HttpImpl(
        httpClient: http.Client(),
        secureStorage: GetIt.I<SecureStorageFacade>(),
      ),
    );
  }
}
