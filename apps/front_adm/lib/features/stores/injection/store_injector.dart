import 'package:get_it/get_it.dart';
import 'package:front_adm/app/injection/injector_base.dart';
import 'package:front_adm/app/settings/app_settings.dart';
import 'package:front_adm/share/network/custom_client_http.dart';

import '../data/datasource/store_datasource.dart';
import '../data/datasource/store_datasource_impl.dart';
import '../data/repository/store_repository_impl.dart';
import '../domain/repository/store_repository.dart';
import '../domain/usecases/get_stores_usecase.dart';

class StoreInjector implements InjectorBase {
  @override
  void call() {
    GetIt.I.registerFactory<StoreDatasource>(
      () => StoreDatasourceImpl(
        http: GetIt.I<CustomClientHttp>(),
        baseUri: AppSettings.apiBaseUri,
      ),
    );
    GetIt.I.registerFactory<StoreRepository>(
      () => StoreRepositoryImpl(dataSource: GetIt.I<StoreDatasource>()),
    );
    GetIt.I.registerFactory<GetStoresUsecase>(
      () => GetStoresUsecaseImpl(repository: GetIt.I<StoreRepository>()),
    );
  }
}
