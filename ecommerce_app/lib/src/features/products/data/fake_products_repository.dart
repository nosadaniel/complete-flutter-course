import 'dart:async';

import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/localization/string_hardcoded.dart';
import 'package:ecommerce_app/src/utils/delay_call.dart';
import 'package:ecommerce_app/src/utils/in_memory_store.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/product.dart';
part 'fake_products_repository.g.dart';

class FakeProductsRepository {
  FakeProductsRepository({this.addDelay = true});
  final bool addDelay;

  /// Preload with the default list of products when the app starts
  final _products = InMemoryStore<List<Product>>(List.from(kTestProducts));

  List<Product> getProductsList() {
    return _products.value;
  }

  Future<List<Product>> fetchProducts() async {
    //await delay(addDelay);
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

  ///update product rating
  Future<void> updateProductRating(
      {required ProductID productId,
      required double avgRating,
      required int numRatings}) async {
    await delay(addDelay);
    final products = _products.value;
    final index = products.indexWhere((item) => item.id == productId);
    if (index == -1) {
      throw StateError('Product not found with id: $productId.'.hardcoded);
    }
    products[index] = products[index].copyWith(
      avgRating: avgRating,
      numRatings: numRatings,
    );
    _products.value = products;
  }

// return all products that marches the query or all if query is empty
  Future<List<Product>> searchProduct(String query) async {
    final products = await fetchProducts();
    return products
        .where((product) => product.title.toLowerCase().contains(
              query.toLowerCase(),
            ))
        .toList();
  }

  static Product? _getProduct(List<Product> products, String id) {
    try {
      return products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }
}

@Riverpod(keepAlive: true)
FakeProductsRepository productsRepository(ProductsRepositoryRef ref) {
  return FakeProductsRepository(addDelay: false);
}

@riverpod
Future<List<Product>> productsListFuture(ProductsListFutureRef ref) {
  final repos = ref.watch(productsRepositoryProvider);
  return repos.fetchProducts();
}

@riverpod
Stream<List<Product>> productsListStream(ProductsListStreamRef ref) {
  final repos = ref.watch(productsRepositoryProvider);
  return repos.watchProductList();
}

@riverpod
FutureOr<Product?> productFuture(ProductFutureRef ref, String productId) {
  final repos = ref.watch(productsRepositoryProvider);
  return repos.getProduct(productId: productId);
}

@riverpod
Stream<Product?> productStream(ProductStreamRef ref, String productId) {
  final repos = ref.watch(productsRepositoryProvider);
  return repos.watchProduct(productId: productId);
}

@riverpod
FutureOr<List<Product>> productsListSearchFuture(
    ProductsListSearchFutureRef ref, String query) async {
  // Todo: User CancelToke to cancel old network requests
  ref.onDispose(() => debugPrint("disposed: $query"));
  //final link = ref.keepAlive();
  // * keep previous search results in memory for 30 seconds
  // Timer(const Duration(seconds: 30), link.close);
  //add a small delya before making a request
  await Future.delayed(const Duration(milliseconds: 500));
  return ref.watch(productsRepositoryProvider).searchProduct(query);
}
