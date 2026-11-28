import 'package:flutter_test/flutter_test.dart';
import 'package:front_adm/features/auth/data/datasource/auth_datasource_impl.dart';
import 'package:front_adm/features/auth/data/repository/auth_repository_impl.dart';
import 'package:front_adm/features/orders/data/datasource/orders_datasource_impl.dart';
import 'package:front_adm/features/orders/data/repository/orders_repository_impl.dart';
import 'package:front_adm/features/products/data/datasource/products_datasource_impl.dart';
import 'package:front_adm/features/products/data/repository/products_repository_impl.dart';
import 'package:front_adm/share/boundaries/secure_storage_facade.dart';
import 'package:front_adm/share/network/custom_client_http.dart';
import 'package:front_adm/share/network/custom_http_response.dart';

void main() {
  const baseUri = 'http://localhost:3000';

  test('loads orders from the backend data envelope', () async {
    final client = _FakeHttpClient(
      _response(200, {
        'data': [
          {
            'id': 'order-001',
            'cliente_nome': 'Maria da Silva',
            'cliente_cpf': '12345678901',
            'produto_id': 'prod-001',
            'loja_id': 'store-001',
            'modalidade_entrega': 'CLICK_COLLECT',
            'status': 'PENDENTE',
          },
        ],
      }),
    );
    final repository = OrdersRepositoryImpl(
      datasource: OrdersDatasourceImpl(
        http: client,
        baseUri: Uri.parse(baseUri),
      ),
    );

    final result = await repository.getOrders();

    expect(result.isSuccess, isTrue);
    expect(result.result.single.id, 'order-001');
    expect(client.lastUri?.path, '/api/orders');
  });

  test('maps the backend data envelope into products', () async {
    final client = _FakeHttpClient(
      _response(200, {
        'data': [
          {
            'id': 'prod-api',
            'name': 'Produto da API',
            'description': 'Descrição',
            'price': 10,
            'category': 'Teste',
            'image_url': 'https://example.test/product.png',
            'active': true,
          },
        ],
      }),
    );
    final repository = ProductsRepositoryImpl(
      datasource: ProductsDatasourceImpl(
        http: client,
        baseUri: Uri.parse(baseUri),
      ),
    );

    final result = await repository.getProducts();

    expect(result.isSuccess, isTrue);
    expect(result.result.single.id, 'prod-api');
    expect(client.lastUri?.path, '/api/products');
  });

  test('returns an HTTP failure instead of mock products', () async {
    final client = _FakeHttpClient(
      _response(503, {'message': 'Serviço indisponível.'}),
    );
    final repository = ProductsRepositoryImpl(
      datasource: ProductsDatasourceImpl(
        http: client,
        baseUri: Uri.parse(baseUri),
      ),
    );

    final result = await repository.getProducts();

    expect(result.isFailure, isTrue);
    expect(result.exception.message, contains('Serviço indisponível.'));
  });

  test('stores the Firebase id token returned by the backend', () async {
    final client = _FakeHttpClient(
      _response(200, {
        'data': {
          'idToken': 'firebase-id-token',
          'refreshToken': 'firebase-refresh-token',
          'expiresIn': '3600',
        },
      }),
    );
    final storage = _MemorySecureStorage();
    final repository = AuthRepositoryImpl(
      datasource: AuthDatasourceImpl(http: client, baseUri: Uri.parse(baseUri)),
      secureStorage: storage,
    );

    final result = await repository.login('admin@example.com', 'password');

    expect(result.isSuccess, isTrue);
    expect(result.result, 'firebase-id-token');
    expect(storage.values['auth_token'], 'firebase-id-token');
    expect(storage.values['refresh_token'], 'firebase-refresh-token');
    expect(client.lastUri?.path, '/api/auth/login');
  });
}

CustomHttpResponse _response(int statusCode, Map<String, dynamic> body) {
  return CustomHttpResponse(
    uri: Uri.parse('http://localhost:3000'),
    statusCode: statusCode,
    body: body,
    headers: const {},
  );
}

class _FakeHttpClient implements CustomClientHttp {
  final CustomHttpResponse response;
  Uri? lastUri;

  _FakeHttpClient(this.response);

  @override
  Future<CustomHttpResponse> get(
    Uri uri, {
    Map<String, String>? headers,
  }) async {
    lastUri = uri;
    return response;
  }

  @override
  Future<CustomHttpResponse> post(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    lastUri = uri;
    return response;
  }

  @override
  Future<CustomHttpResponse> put(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    lastUri = uri;
    return response;
  }

  @override
  Future<CustomHttpResponse> delete(
    Uri uri, {
    Map<String, String>? headers,
  }) async {
    lastUri = uri;
    return response;
  }
}

class _MemorySecureStorage extends SecureStorageFacade {
  final Map<String, String> values = {};

  @override
  Future<void> write(String key, String value) async {
    values[key] = value;
  }

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> delete(String key) async {
    values.remove(key);
  }
}
