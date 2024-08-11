import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productsSearchQueryStateProvider = StateProvider<String>((ref) {
  return "";
});

final productsSearchResultsFutureProvider =
    FutureProvider.autoDispose<List<Product>>((ref) async {
  final String searchQuery = ref.watch(productsSearchQueryStateProvider);
  return ref.watch(productsListSearchFutureProvider(searchQuery).future);
});
