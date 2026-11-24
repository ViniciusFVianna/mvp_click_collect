import '../../../../share/base/model.dart';

class CreateOrderParams implements Model {
  final String clienteNome;
  final String clienteCpf;
  final String produtoId;
  final String lojaId;
  final String modalidadeEntrega;
  final String? terceiroAutorizadoNome;
  final String? terceiroAutorizadoCpf;

  const CreateOrderParams({
    required this.clienteNome,
    required this.clienteCpf,
    required this.produtoId,
    required this.lojaId,
    this.modalidadeEntrega = 'CLICK_COLLECT',
    this.terceiroAutorizadoNome,
    this.terceiroAutorizadoCpf,
  });

  @override
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'cliente_nome': clienteNome,
      'cliente_cpf': clienteCpf,
      'produto_id': produtoId,
      'loja_id': lojaId,
      'modalidade_entrega': modalidadeEntrega,
    };
    if (terceiroAutorizadoNome?.isNotEmpty == true) {
      map['terceiro_autorizado_nome'] = terceiroAutorizadoNome;
    }
    if (terceiroAutorizadoCpf?.isNotEmpty == true) {
      map['terceiro_autorizado_cpf'] = terceiroAutorizadoCpf;
    }
    return map;
  }

  Map<String, dynamic> toJson() => toMap();
}

class OrderResponseModel implements Model {
  final String id;
  final String clienteNome;
  final String clienteCpf;
  final String produtoId;
  final String lojaId;
  final String modalidadeEntrega;
  final String status;
  final String? createdAt;
  final String? pin;
  final String? qrToken;

  const OrderResponseModel({
    required this.id,
    required this.clienteNome,
    required this.clienteCpf,
    required this.produtoId,
    required this.lojaId,
    required this.modalidadeEntrega,
    required this.status,
    this.createdAt,
    this.pin,
    this.qrToken,
  });

  factory OrderResponseModel.fromMap(Map<String, dynamic> map) {
    return OrderResponseModel(
      id: map['id']?.toString() ?? map['order_id']?.toString() ?? '',
      clienteNome: map['cliente_nome']?.toString() ?? '',
      clienteCpf: map['cliente_cpf']?.toString() ?? '',
      produtoId: map['produto_id']?.toString() ?? '',
      lojaId: map['loja_id']?.toString() ?? '',
      modalidadeEntrega:
          map['modalidade_entrega']?.toString() ?? 'CLICK_COLLECT',
      status: map['status']?.toString() ?? 'PENDENTE',
      createdAt: map['created_at']?.toString() ?? map['createdAt']?.toString(),
      pin: map['pin']?.toString(),
      qrToken: map['qrToken']?.toString() ?? map['qr_token']?.toString(),
    );
  }

  factory OrderResponseModel.fromJson(Map<String, dynamic> json) =>
      OrderResponseModel.fromMap(json);

  @override
  Map<String, dynamic> toMap() => {
    'id': id,
    'cliente_nome': clienteNome,
    'cliente_cpf': clienteCpf,
    'produto_id': produtoId,
    'loja_id': lojaId,
    'modalidade_entrega': modalidadeEntrega,
    'status': status,
    if (createdAt != null) 'created_at': createdAt,
    if (pin != null) 'pin': pin,
    if (qrToken != null) 'qrToken': qrToken,
  };

  Map<String, dynamic> toJson() => toMap();
}
