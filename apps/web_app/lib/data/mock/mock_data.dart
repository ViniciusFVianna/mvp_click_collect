import '../models/product_model.dart';
import '../models/store_model.dart';

class MockData {
  MockData._();

  static final List<ProductModel> products = [
    ProductModel(
      id: 'prod_01',
      name: 'Smartphone Galaxy A55 5G 128GB',
      description:
          'Smartphone Samsung com 8GB RAM, tela Super AMOLED de 6.6 polegadas e câmera tripla.',
      price: 1999.90,
      category: 'Eletrônicos',
      imageUrl:
          'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?q=80&w=800&auto=format&fit=crop',
      active: true,
    ),
    ProductModel(
      id: 'prod_02',
      name: 'Smart TV LED 50" 4K UHD LG',
      description:
          'Smart TV com Inteligência Artificial, HDR10 e Wi-Fi integrado.',
      price: 2499.00,
      category: 'Televisores',
      imageUrl:
          'https://images.unsplash.com/photo-1593784991095-a205069470b6?q=80&w=800&auto=format&fit=crop',
      active: true,
    ),
    ProductModel(
      id: 'prod_03',
      name: 'Fritadeira Sem Óleo Air Fryer 4L Mondial',
      description:
          'Air Fryer com controle de temperatura até 200°C e timer de 60 minutos.',
      price: 389.90,
      category: 'Eletroportáteis',
      imageUrl:
          'https://images.unsplash.com/photo-1585515320310-259814833e62?q=80&w=800&auto=format&fit=crop',
      active: true,
    ),
    ProductModel(
      id: 'prod_04',
      name: 'Notebook Gamer Acer Nitro 5',
      description:
          'Intel Core i5, 8GB RAM, SSD 512GB NVMe, Placa de Vídeo NVIDIA GTX 1650.',
      price: 4299.00,
      category: 'Informática',
      imageUrl:
          'https://images.unsplash.com/photo-1603302576837-37561b2e2302?q=80&w=800&auto=format&fit=crop',
      active: true,
    ),
  ];

  static final List<StoreModel> stores = [
    StoreModel(
      id: 'store_sapucaia_01',
      name: 'MegaLoja - Sapucaia Centro',
      address: 'Av. Sapucaia, 1020 - Centro, Sapucaia do Sul - RS',
      zipCode: '93260000',
      distance: '1.5 km',
      stock: 5,
      status: 'DISPONIVEL',
    ),
    StoreModel(
      id: 'store_canoas_01',
      name: 'MegaLoja - Canoas Centro',
      address: 'Rua Tiradentes, 450 - Centro, Canoas - RS',
      zipCode: '92010260',
      distance: '8.2 km',
      stock: 12,
      status: 'DISPONIVEL',
    ),
    StoreModel(
      id: 'store_esteio_01',
      name: 'MegaLoja - Esteio Centro',
      address: 'Av. Presidente Vargas, 2100 - Centro, Esteio - RS',
      zipCode: '93265001',
      distance: '4.1 km',
      stock: 2,
      status: 'DISPONIVEL',
    ),
    StoreModel(
      id: 'store_poa_01',
      name: 'MegaLoja - Porto Alegre Shopping',
      address: 'Av. Assis Brasil, 5000 - Sarandi, Porto Alegre - RS',
      zipCode: '91110000',
      distance: '18.0 km',
      stock: 20,
      status: 'DISPONIVEL',
    ),
  ];

  static const Map<String, Map<String, int>> stockByStore = {
    'prod_01': {
      'store_sapucaia_01': 5,
      'store_canoas_01': 12,
      'store_esteio_01': 2,
      'store_poa_01': 20,
    },
    'prod_02': {
      'store_sapucaia_01': 2,
      'store_canoas_01': 4,
      'store_esteio_01': 1,
      'store_poa_01': 8,
    },
    'prod_03': {
      'store_sapucaia_01': 10,
      'store_canoas_01': 15,
      'store_esteio_01': 7,
      'store_poa_01': 25,
    },
    'prod_04': {
      'store_sapucaia_01': 3,
      'store_canoas_01': 6,
      'store_esteio_01': 0,
      'store_poa_01': 10,
    },
  };

  static final Map<String, dynamic> clientUser = {
    'id': 'user_client_01',
    'name': 'Vinícius Vianna',
    'email': 'vinicius.vianna@email.com',
    'cpf': '12345678901',
    'role': 'client',
    'shipping_address': {
      'street': 'Av. Sapucaia',
      'number': '500',
      'neighborhood': 'Centro',
      'city': 'Sapucaia do Sul',
      'state': 'RS',
      'zip_code': '93260-010',
    },
  };
}
