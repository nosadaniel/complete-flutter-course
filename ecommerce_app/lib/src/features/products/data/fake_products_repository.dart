import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/product.dart';

class FakeProductsRepository {
  final _productsData = kTestProducts;

  Future<List<Product>> fetchProducts() async {
    await Future.delayed(const Duration(seconds: 2));
    return Future.value(_productsData);
  }

  Future<Product?> product({required String productId}) async {
    await Future.delayed(const Duration(seconds: 2));
    try {
      return _productsData.firstWhere((product) => product.id == productId);
    } catch (e) {
      rethrow;
    }
  }
}

final productsRepositoryProvider =
    Provider<FakeProductsRepository>((ref) => FakeProductsRepository());

final productsListProvider = FutureProvider<List<Product>>((ref) {
  final repos = ref.watch(productsRepositoryProvider);
  return repos.fetchProducts();
});

final productProvider =
    FutureProvider.autoDispose.family<Product?, String>((ref, productId) {
  final repos = ref.watch(productsRepositoryProvider);
  return repos.product(productId: productId);
});
