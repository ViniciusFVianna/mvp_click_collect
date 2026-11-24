import '../../../../share/base/model.dart';

class StoreModel implements Model {
  final String id;
  final String name;
  final String address;
  final String zipCode;
  final String? distance;
  final int stock;
  final String status;

  const StoreModel({
    required this.id,
    required this.name,
    required this.address,
    required this.zipCode,
    this.distance,
    required this.stock,
    required this.status,
  });

  factory StoreModel.fromMap(Map<String, dynamic> map) {
    final address = map['address'];
    final Map<String, dynamic> addressFields = address is Map
        ? Map<String, dynamic>.from(address)
        : const <String, dynamic>{};
    final stock =
        (map['quantity'] as num?)?.toInt() ??
        (map['stock'] as num?)?.toInt() ??
        (map['estoque'] as num?)?.toInt() ??
        0;

    return StoreModel(
      id: map['id']?.toString() ?? map['loja_id']?.toString() ?? '',
      name: map['name']?.toString() ?? map['nome']?.toString() ?? '',
      address: _formatAddress(address ?? map['endereco'], addressFields),
      zipCode:
          addressFields['zip_code']?.toString() ??
          map['zip_code']?.toString() ??
          map['cep']?.toString() ??
          '',
      distance: map['distance']?.toString() ?? map['distancia']?.toString(),
      stock: stock,
      status:
          map['status']?.toString() ??
          (map['active'] == false || stock < 1 ? 'INDISPONIVEL' : 'DISPONIVEL'),
    );
  }

  factory StoreModel.fromJson(Map<String, dynamic> json) =>
      StoreModel.fromMap(json);

  static String _formatAddress(dynamic value, Map<String, dynamic> fields) {
    if (value is String) return value;
    final street = [
      fields['street']?.toString(),
      fields['number']?.toString(),
    ].where((part) => part != null && part.isNotEmpty).join(', ');
    final city = [
      fields['neighborhood']?.toString(),
      fields['city']?.toString(),
      fields['state']?.toString(),
    ].where((part) => part != null && part.isNotEmpty).join(' - ');
    return [street, city].where((part) => part.isNotEmpty).join(', ');
  }

  @override
  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'address': address,
    'zip_code': zipCode,
    'distance': distance,
    'stock': stock,
    'status': status,
  };

  Map<String, dynamic> toJson() => toMap();
}
