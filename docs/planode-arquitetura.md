# Arquitetura Flutter — flutter-app



## 1. Visão Geral

`flutter-app` (pacote: `flutter-app`) é uma generalização replicável para outras aplicações

Stack principal:

| Responsabilidade | Biblioteca / Padrão |
|---|---|
| Framework UI | Flutter 3.13+ (Material Design) |
| Navegação | `go_router` + `AppNavigator` (fachada estática) |
| Estado de UI | `Command<T>` (ChangeNotifier customizado — ver §3.5) |
| Injeção de dependência | `get_it` + `InjectorBase` por feature |
| HTTP | `http` + `CustomClientHttp` / `HttpImpl` |
| Storage seguro | `flutter_secure_storage` |
| SQLite (offline) | `sqflite` (ver ADR-0002) |
| Design system | `packages/design_system` (path dependency local) |
| i18n | `flutter_localizations` + `intl` (pt-BR) |
| Ícones | `material_symbols_icons` |

---

## 2. Estrutura de Pastas

```
flutter-app/
├── packages/
│   └── design_system/              # Componentes visuais reutilizáveis (pacote local)
│       ├── lib/
│       │   ├── appBar/
│       │   └── tokens/
│       │       ├── colors/
│       │       └── gradients/
│       └── pubspec.yaml
└── lib/
    ├── main.dart
    ├── generated/                  # Assets gerados (flutter pub run build_runner)
    ├── app/                        # Infraestrutura do app (boot, navegação, DI, i18n)
    │   ├── injection/
    │   │   ├── injector.dart       # Agregador central dos InjectorBase
    │   │   └── injector_base.dart  # Interface: abstract class InjectorBase { void call(); }
    │   ├── localization/           # AppLocalizations geradas + .arb
    │   ├── navigation/
    │   │   ├── app_navigator.dart  # Fachada estática (push / pop / pushReplacement)
    │   │   ├── router_base.dart    # Interface por tela
    │   │   └── router_register.dart
    │   └── settings/
    │       └── app_settings.dart   # Ambientes dev / qa / prod
    ├── features/                   # Regra de negócio por feature (dados + domínio + DI)
    │   └── <feature>/
    │       ├── data/
    │       │   ├── datasource/
    │       │   │   ├── <feature>_datasource.dart      # Interface
    │       │   │   └── <feature>_datasource_impl.dart # Implementação
    │       │   └── repository/
    │       │       └── <feature>_repository_impl.dart
    │       ├── domain/
    │       │   ├── error/          # Classe de failure do domínio
    │       │   ├── repository/     # Interface abstrata
    │       │   └── usecases/       # Interface + implementação
    │       └── injection/
    │           └── <feature>_injector.dart  # InjectorBase da feature
    ├── presenter/                  # Camada de apresentação por tela (Flutter SDK)
    │   └── <tela>/
    │       ├── page/
    │       │   ├── <tela>_page.dart        # StatefulWidget + ListenableBuilder
    │       │   └── <tela>_controller.dart  # Controller com Command<T>
    │       ├── widget/             # Subcomponentes da tela
    │       └── routes/
    │           └── <tela>_routes.dart      # RouterBase
    └── share/                      # Código transversal sem regra de negócio
        ├── base/
        │   └── model.dart          # Model base (toMap / fromJson)
        ├── boundaries/
        │   ├── secure_storage_facade.dart
        │   └── speech_facade.dart
        ├── network/
        │   ├── custom_client_http.dart     # Interface HTTP
        │   ├── http_impl.dart              # Implementação (sem auth — ver §3.4)
        │   └── custom_http_response.dart   # VO de resposta + auto-log
        ├── share_injector.dart
        └── util/
            ├── result.dart         # sealed class Result<S,E>
            ├── command.dart        # Command<T> (ChangeNotifier)
            ├── log_util.dart       # successLog / errorLog / debugLog / infoLog
            └── base_64.dart
```

> **Separação `features/` vs. `presenter/`** — `features/` contém data + domain + injection
> sem nenhuma dependência do Flutter SDK. `presenter/` contém tudo que depende de widget.
> Isso permite testar usecases e repositórios sem a árvore de widgets.

---

## 3. Camadas da Arquitetura

### 3.1 Data Layer

Responsável pela comunicação com fontes externas (API HTTP, banco local SQLite).

#### Datasource — Interface

```dart
abstract class FeatureDatasource {
  Future<Result<Map<String, dynamic>, Exception>> getData();
}
```

#### Datasource — Implementação

Dependências são injetadas via construtor, não acessadas diretamente do GetIt:

```dart
class FeatureDatasourceImpl implements FeatureDatasource {
  final CustomClientHttp _http;
  FeatureDatasourceImpl({required CustomClientHttp http}) : _http = http;

  @override
  Future<Result<Map<String, dynamic>, Exception>> getData() async {
    try {
      final response = await _http.get(Uri.parse("https://api.exemplo.com/recurso"));
      return Success(response.body);
    } catch (e) {
      errorLog(e.toString(), tag: "FeatureDatasourceImpl");
      return Failure(Exception(e));
    }
  }
}
```

#### Repository — Interface

```dart
abstract class FeatureRepository {
  Future<Result<FeatureModel, FeatureFailure>> call();
}
```

#### Repository — Implementação

O repository mapeia para um modelo de domínio e usa failure tipada, não `Exception` genérica:

```dart
class FeatureRepositoryImpl implements FeatureRepository {
  final FeatureDatasource _datasource;
  FeatureRepositoryImpl({required FeatureDatasource dataSource})
      : _datasource = dataSource;

  @override
  Future<Result<FeatureModel, FeatureFailure>> call() async {
    try {
      final response = await _datasource.getData();
      if (response.isFailure) return Failure(FeatureFailure.unknown());
      return Success(FeatureModel.fromMap(response.result));
    } catch (e) {
      errorLog(e.toString(), tag: "FeatureRepositoryImpl");
      return Failure(FeatureFailure.unknown());
    }
  }
}
```

---

### 3.2 Domain Layer

Regras de negócio puras, sem dependência de frameworks.

#### Result — Tipo de retorno (`lib/share/util/result.dart`)

```dart
sealed class Result<S, E> {
  const Result();

  bool get isSuccess => this is Success;
  bool get isFailure => this is Failure;

  S get result => (this as Success).value;

  T when<T>({
    required T Function(S value) success,
    required T Function(Exception exception) exception,
  }) {
    if (this is Success) return success((this as Success).value);
    return exception((this as Failure).exception);
  }
}

final class Success<S, E> extends Result<S, E> {
  const Success(this.value);
  final S value;
}

final class Failure<S, E> extends Result<S, E> {
  const Failure(this.exception);
  final E exception;
}
```

#### UseCase

O padrão usa interface + implementação. O tipo de retorno é um typedef para legibilidade.
Usecases sem parâmetros de entrada expõem `call()` diretamente (sem genérico de input):

```dart
typedef FeatureResult = Result<FeatureModel, FeatureFailure>;

abstract class FeatureUsecase {
  Future<FeatureResult> call();
}

class FeatureUsecaseImpl implements FeatureUsecase {
  final FeatureRepository repository;
  FeatureUsecaseImpl({required this.repository});

  @override
  Future<FeatureResult> call() => repository();
}
```

---

### 3.3 HTTP Layer

O cliente HTTP tem dois artefatos: uma interface e sua implementação.

#### Interface (`lib/share/network/custom_client_http.dart`)

```dart
abstract class CustomClientHttp {
  Future<CustomHttpResponse> get(Uri url, {Map<String, String>? headers});
  Future<CustomHttpResponse> post(Uri url, {Map<String, String>? headers, Object? body});
  Future<CustomHttpResponse> put(Uri url, {Map<String, String>? headers, Object? body});
  Future<CustomHttpResponse> delete(Uri url, {Map<String, String>? headers});
}
```

#### Implementação atual (`lib/share/network/http_impl.dart`)

`HttpImpl` implementa `CustomClientHttp` sobre `package:http`. Hoje injeta apenas
`Content-Type: application/json` — **sem token de autenticação**. Isso é intencional:
a decisão de auth/sessão exige ADR próprio (ver ADR-0002).

```dart
class HttpImpl implements CustomClientHttp {
  final http.Client httpClient;
  HttpImpl({required this.httpClient});

  @override
  Future<CustomHttpResponse> get(Uri uri, {Map<String, String>? headers}) async {
    final response = await httpClient.get(uri, headers: headers ?? await _header(headers));
    return CustomHttpResponse(
      statusCode: response.statusCode,
      headers: response.headers,
      body: _toMap(response.bodyBytes),
      uri: uri,
    );
  }

  // post / put / delete — mesma estrutura

  Future<Map<String, String>> _header(Map<String, String>? headers) async {
    return headers ?? {'Content-Type': 'application/json'};
  }

  Map<String, dynamic> _toMap(Uint8List bodyBytes) {
    try {
      return jsonDecode(utf8.decode(bodyBytes)) as Map<String, dynamic>;
    } catch (_) {
      return {'result': utf8.decode(bodyBytes)};
    }
  }
}
```

#### CustomHttpResponse — auto-log no construtor

```dart
class CustomHttpResponse {
  final Uri uri;
  final int statusCode;
  final Map<String, dynamic> body;
  final Map<String, String> headers;
  final Map<String, dynamic>? request;

  CustomHttpResponse({...}) {
    switch (statusCode) {
      case 200: successLog(request?['type'] ?? uri.path, tag: "API"); break;
      default:  errorLog("${uri.path} - $statusCode", data: {...}, tag: "API");
    }
  }
}
```

#### Evolução planejada — autenticação (pendente ADR)

Quando a autenticação for decidida, `_header()` passará a injetar o token via
`SecureStorageFacade` e serão adicionados dois fluxos de resposta 401:

| Cenário | Ação |
|---|---|
| Senha inválida no login | logout completo → redirect para `/login` |
| Sessão expirada | manter dados locais → redirect para `/re-login` |

Não implementar esses fluxos sem o ADR aprovado.

---

### 3.4 Injeção de Dependências (GetIt)

O padrão não é um `setupDependencies()` único. Cada feature implementa `InjectorBase`
e se registra no `Injector` central.

#### InjectorBase por feature

```dart
class FeatureInjector implements InjectorBase {
  @override
  void call() {
    GetIt.I.registerFactory<FeatureDatasource>(
      () => FeatureDatasourceImpl(http: GetIt.I<CustomClientHttp>()),
    );
    GetIt.I.registerFactory<FeatureRepository>(
      () => FeatureRepositoryImpl(dataSource: GetIt.I<FeatureDatasource>()),
    );
    GetIt.I.registerFactory<FeatureUsecase>(
      () => FeatureUsecaseImpl(repository: GetIt.I<FeatureRepository>()),
    );
    GetIt.I.registerFactory<FeatureController>(
      () => FeatureController(GetIt.I<FeatureUsecase>()),
    );
  }
}
```

#### Injector central (`lib/app/injection/injector.dart`)

```dart
class Injector {
  Injector._();
  static Injector get I => _instance ??= Injector._();
  static Injector? _instance;

  final List<InjectorBase> injectors = [];

  void inject() {
    injectors.add(ShareInjector());    // SecureStorage, Base64, SpeechFacade
    injectors.add(SplashInjector());   // feature splash
    // adicionar aqui cada nova feature
  }

  void call() {
    inject();
    for (var injector in injectors) injector();
    injectors.clear();
  }
}
```

> `ShareInjector` registra as dependências transversais. `CustomClientHttp` ainda não está
> no GetIt — é instanciado no datasource enquanto não há auth. Entrará como singleton no
> `ShareInjector` quando auth for implementada.

---

### 3.5 Camada de Apresentação

#### Command\<T\> — estado de UI (`lib/share/util/command.dart`)

`Command<T>` é a unidade de estado reativa do app. Cada peça de estado da tela vira
um `Command<T>` no controller:

```dart
class Command<T> extends ChangeNotifier {
  T data;
  bool isLoading;

  Command({required this.data, this.isLoading = false});

  void toggleLoading() { isLoading = !isLoading; notifyListeners(); }
  void setData(T newData) { data = newData; notifyListeners(); }
  void execute() => notifyListeners();
}
```

#### Controller

Classe Dart pura, sem herança de framework:

```dart
class FeatureController {
  Command<FeatureState> state = Command(data: FeatureState.initial);
  Command<FeatureModel?> data = Command(data: null);

  final FeatureUsecase _usecase;
  FeatureController(this._usecase);

  Future<void> onInit() async {
    state.toggleLoading();
    final result = await _usecase();
    result.when(
      success: (model) {
        data.setData(model);
        state.setData(FeatureState.loaded);
      },
      exception: (_) => state.setData(FeatureState.error),
    );
    state.toggleLoading();
  }
}
```

#### Page — padrão de escuta

```dart
class FeaturePage extends StatefulWidget {
  const FeaturePage({super.key});
  @override
  State<FeaturePage> createState() => _FeaturePageState();
}

class _FeaturePageState extends State<FeaturePage> {
  late final FeatureController controller;

  @override
  void initState() {
    super.initState();
    controller = GetIt.I<FeatureController>();
    controller.onInit();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: Listenable.merge([controller.state, controller.data]),
        builder: (context, _) {
          if (controller.state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          // widget tree
        },
      );
}
```

---

## 4. Fluxo de Dados

```
Page (StatefulWidget)
  └── ListenableBuilder(listenable: Listenable.merge([...]))
        └── Controller (Dart puro — Command<T>)
              └── UseCase (interface → impl)
                    └── Repository (interface → impl)
                          └── Datasource (interface → impl)
                                └── HttpImpl (CustomClientHttp)
                                      └── API REST do CRM
```
---

## 5. Proposta vs. Implementação Atual

A proposta original foi ajustada durante a implementação. Diferenças registradas:

| # | Item | Proposta original | Implementação atual |
|---|---|---|---|
| 1 | Estrutura de pastas | `modules/` co-localizado com presenter | `features/` (data+domain) separado de `presenter/` |
| 2 | Estado de UI | Controller com Cubit / MobX | `Command<T>` (ChangeNotifier) — ver ADR-0003 |
| 3 | DI | `setupDependencies()` único | `InjectorBase` por feature, agregado pelo `Injector` |
| 4 | Infraestrutura transversal | `core/` | `share/` + `app/` |
| 5 | Design system | `design_system/` como diretório interno | `packages/design_system/` como path dependency |
| 6 | Autenticação HTTP | `CustomHttp` com token + 401 | `HttpImpl` sem auth (intencional — pendente ADR de auth) |
| 7 | UseCase genérico | `UseCase<Output, Input>` com `NoParams` | Interface simples com `call()` sem generic de input |
| 8 | Failure | `Exception` genérica em todo o fluxo | Failure tipada por domínio (ex.: `ReadLogedFailure`) |

---

## 6. Boas Práticas Aplicadas

- **Single Responsibility** — datasource fala com a fonte; repository mapeia; usecase aplica
  regra de negócio; controller coordena estado de UI.
- **Dependency Inversion** — dependências sempre via interface (`FeatureDatasource`,
  `FeatureRepository`, `CustomClientHttp`), nunca na implementação concreta.
- **Result Pattern** — `Success`/`Failure` tornam o contrato explícito e eliminam
  `try/catch` em cascata entre camadas.
- **Failure tipada** — `Result<Model, DomainFailure>` torna o `when()` exaustivo e
  legível sem cast.
- **GetIt como service locator** — instâncias como `registerFactory` (stateful, recriado
  a cada acesso) ou `registerLazySingleton` (compartilhado, criado na primeira chamada).
- **Logging somente em debug** — `log_util.dart` usa `kDebugMode`; nada vai para produção.
- **design_system isolado** — tokens de cor, tipografia e componentes vivem em
  `packages/design_system`, nunca duplicados em `lib/`.
- **Auth centralizada (planejado)** — token será gerenciado em `HttpImpl` via
  `SecureStorageFacade`, sem duplicação nos datasources. Dois fluxos de 401 distintos
  (senha inválida vs. sessão expirada). Não implementar sem ADR.

