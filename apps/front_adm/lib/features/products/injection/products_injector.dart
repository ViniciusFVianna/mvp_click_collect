import 'package:get_it/get_it.dart';

import '../../../../app/injection/injector_base.dart';
import '../../../../share/network/custom_client_http.dart';
import '../data/datasource/products_datasource.dart';
import '../data/datasource/products_datasource_impl.dart';
import '../data/repository/products_repository_impl.dart';
import '../domain/repository/products_repository.dart';
import '../domain/usecases/get_product_by_id_usecase.dart';
import '../domain/usecases/get_products_usecase.dart';

class ProductsInjector implements InjectorBase {
  @override
  void call() {
    GetIt.I.registerFactory<ProductsDatasource>(
      () => ProductsDatasourceImpl(http: GetIt.I<CustomClientHttp>()),
    );
    GetIt.I.registerFactory<ProductsRepository>(
      () => ProductsRepositoryImpl(datasource: GetIt.I<ProductsDatasource>()),
    );
    GetIt.I.registerFactory<GetProductsUseCase>(
      () => GetProductsUseCaseImpl(repository: GetIt.I<ProductsRepository>()),
    );
    GetIt.I.registerFactory<GetProductByIdUseCase>(
      () =>
          GetProductByIdUseCaseImpl(repository: GetIt.I<ProductsRepository>()),
    );
  }
}
