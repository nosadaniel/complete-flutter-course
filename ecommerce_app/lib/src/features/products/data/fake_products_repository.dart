import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/utils/delay_call.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/product.dart';

class FakeProductsRepository {
  FakeProductsRepository({this.addDelay = true});
  final bool addDelay;
  List<Product> get _kProductsTestData {
    return kTestProducts;
  }

  Future<List<Product>> fetchProducts() async {
    await delay(addDelay);
    return Future.value(_kProductsTestData);
  }

  Future<Product?> getProduct({required String productId}) async {
    await delay(addDelay);
    return _getProduct(kTestProducts, productId);
  }

  Stream<List<Product>> watchProductList() async* {
    await delay(addDelay);
    yield _kProductsTestData;
  }

  Stream<Product?> watchProduct({required String productId}) {
    return watchProductList()
        .map((products) => _getProduct(products, productId));
  }

  Product? _getProduct(List<Product> products, String id) {
    try {
      return products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
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
  return repos.getProduct(productId: productId);
});
