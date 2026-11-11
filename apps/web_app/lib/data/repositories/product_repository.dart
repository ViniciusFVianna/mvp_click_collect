import 'dart:developer';

import '../models/product_model.dart';
import '../../app/utils/http_client.dart';

class ProductRepository {
  final ApiClient _apiClient;

  ProductRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.instance;

  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await _apiClient.get('/api/products');

      if (response['data'] is List) {
        return response.map((item) => ProductModel.fromJson(item)).toList();
      } else if (response is Map && response['products'] is List) {
        return (response['products'] as List)
            .map((item) => ProductModel.fromJson(item))
            .toList();
      }
      return [];
    } catch (_) {
      return _mockProducts;
    }
  }

  Future<ProductModel> getProductById(String id) async {
    try {
      final response = await _apiClient.get('/api/products/$id');
      if (response is Map<String, dynamic>) {
        return ProductModel.fromJson(response);
      }
    } catch (_) {}
    return _mockProducts.firstWhere(
      (p) => p.id == id,
      orElse: () => _mockProducts.first,
    );
  }

  static final List<ProductModel> _mockProducts = [
    ProductModel(
      id: 'prod-001',
      name: 'Smartphone Galaxy S24 Ultra 512GB',
      description:
          'Smartphone top de linha com IA integrada, câmera de 200MP, tela Dynamic AMOLED 2X de 6.8 polegadas e caneta S Pen inclusa.',
      price: 6499.00,
      category: 'Eletrônicos',
      imageUrl:
          'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?q=80&w=800&auto=format&fit=crop',
    ),
    ProductModel(
      id: 'prod-002',
      name: 'Notebook Dell XPS 13 Intel Core i7 16GB',
      description:
          'Design ultrafino de alumínio, tela Full HD+, SSD de 512GB e bateria de alta duração para máxima produtividade.',
      price: 8999.00,
      category: 'Informática',
      imageUrl:
          'https://images.unsplash.com/photo-1593642632823-8f785ba67e45?q=80&w=800&auto=format&fit=crop',
    ),
    ProductModel(
      id: 'prod-003',
      name: 'Fone de Ouvido Bluetooth Sony WH-1000XM5',
      description:
          'Fone Over-Ear com cancelamento de ruído ativíssimo líder da indústria, som de altíssima fidelidade e até 30 horas de bateria.',
      price: 2199.00,
      category: 'Áudio',
      imageUrl:
          'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=800&auto=format&fit=crop',
    ),
    ProductModel(
      id: 'prod-004',
      name: 'Smartwatch Apple Watch Series 9 GPS 45mm',
      description:
          'Display Retina Sempre Ativo mais brilhante, novos gestos de toque duplo e sensores avançados para monitoramento de saúde.',
      price: 3899.00,
      category: 'Wearables',
      imageUrl:
          'https://images.unsplash.com/photo-1523275335684-37898b6baf30?q=80&w=800&auto=format&fit=crop',
    ),
  ];
}
