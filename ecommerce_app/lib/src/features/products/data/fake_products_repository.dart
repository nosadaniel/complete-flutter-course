import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/utils/delay_call.dart';
import 'package:ecommerce_app/src/utils/in_memory_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/product.dart';

class FakeProductsRepository {
  FakeProductsRepository({this.addDelay = true});
  final bool addDelay;

  /// Preload with the default list of products when the app starts
  final _products = InMemoryStore<List<Product>>(List.from(kTestProducts));

  List<Product> getProductsList() {
    return _products.value;
  }

  Future<List<Product>> fetchProducts() async {
    await delay(addDelay);
    return Future.value(_products.value);
  }

    Stream<List<Product>> watchProductList() {
    return _products.stream;
  }

  Product? getProduct({required String productId}) {
    return _getProduct(_products.value, productId);
  }

  Stream<Product?> watchProduct({required String productId}) {
    return watchProductList()
        .map((products) => _getProduct(products, productId));
  }

  ///update product or add a new one
  Future<void> setProduct(Product product) async {
    await delay(addDelay);
    final products = _products.value;
    final index = products.indexWhere((p) => p.id.contains(product.id));
    if (index == -1) {
      // if not found add as a new product
      products.add(product);
    } else {
      //else, overwrite previous product
      products[index] = product;
    }
  }

  static Product? _getProduct(List<Product> products, String id) {
    try {
      return products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }
}

final productsRepositoryProvider = Provider<FakeProductsRepository>(
    (ref) => FakeProductsRepository(addDelay: false));

final productsListProvider = FutureProvider<List<Product>>((ref) {
  final repos = ref.watch(productsRepositoryProvider);
  return repos.fetchProducts();
});
final productListStreamProvider = StreamProvider<List<Product>>((ref) {
  final repos = ref.watch(productsRepositoryProvider);
  return repos.watchProductList();
});
final productProvider =
    FutureProvider.autoDispose.family<Product?, String>((ref, productId) {
  final repos = ref.watch(productsRepositoryProvider);
  return repos.getProduct(productId: productId);
});
