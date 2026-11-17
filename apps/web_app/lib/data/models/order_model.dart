class CreateOrderParams {
  final String clienteNome;
  final String clienteCpf;
  final String produtoId;
  final String lojaId;
  final String modalidadeEntrega;
  final String? terceiroAutorizadoNome;
  final String? terceiroAutorizadoCpf;

  CreateOrderParams({
    required this.clienteNome,
    required this.clienteCpf,
    required this.produtoId,
    required this.lojaId,
    this.modalidadeEntrega = 'CLICK_COLLECT',
    this.terceiroAutorizadoNome,
    this.terceiroAutorizadoCpf,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'cliente_nome': clienteNome,
      'cliente_cpf': clienteCpf,
      'produto_id': produtoId,
      'loja_id': lojaId,
      'modalidade_entrega': modalidadeEntrega,
    };
    if (terceiroAutorizadoNome != null && terceiroAutorizadoNome!.isNotEmpty) {
      map['terceiro_autorizado_nome'] = terceiroAutorizadoNome;
    }
    if (terceiroAutorizadoCpf != null && terceiroAutorizadoCpf!.isNotEmpty) {
      map['terceiro_autorizado_cpf'] = terceiroAutorizadoCpf;
    }
    return map;
  }
}

class OrderResponseModel {
  final String id;
  final String clienteNome;
  final String clienteCpf;
  final String produtoId;
  final String lojaId;
  final String modalidadeEntrega;
  final String status;
  final String? createdAt;

  OrderResponseModel({
    required this.id,
    required this.clienteNome,
    required this.clienteCpf,
    required this.produtoId,
    required this.lojaId,
    required this.modalidadeEntrega,
    required this.status,
    this.createdAt,
  });

  factory OrderResponseModel.fromJson(Map<String, dynamic> json) {
    return OrderResponseModel(
      id: json['id']?.toString() ?? json['order_id']?.toString() ?? '',
      clienteNome: json['cliente_nome']?.toString() ?? '',
      clienteCpf: json['cliente_cpf']?.toString() ?? '',
      produtoId: json['produto_id']?.toString() ?? '',
      lojaId: json['loja_id']?.toString() ?? '',
      modalidadeEntrega: json['modalidade_entrega']?.toString() ?? 'CLICK_COLLECT',
      status: json['status']?.toString() ?? 'CONFIRMADO',
      createdAt: json['created_at']?.toString() ?? json['createdAt']?.toString(),
    );
  }
}
