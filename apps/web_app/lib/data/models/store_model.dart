class StoreModel {
  final String id;
  final String name;
  final String address;
  final String zipCode;
  final String? distance;
  final int stock;
  final String status;

  StoreModel({
    required this.id,
    required this.name,
    required this.address,
    required this.zipCode,
    this.distance,
    required this.stock,
    required this.status,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json['id']?.toString() ?? json['loja_id']?.toString() ?? '',
      name: json['name']?.toString() ?? json['nome']?.toString() ?? '',
      address: json['address']?.toString() ?? json['endereco']?.toString() ?? '',
      zipCode: json['zip_code']?.toString() ?? json['cep']?.toString() ?? '',
      distance: json['distance']?.toString() ?? json['distancia']?.toString(),
      stock: (json['stock'] as num?)?.toInt() ?? (json['estoque'] as num?)?.toInt() ?? 0,
      status: json['status']?.toString() ?? 'DISPONIVEL',
    );
  }
}
