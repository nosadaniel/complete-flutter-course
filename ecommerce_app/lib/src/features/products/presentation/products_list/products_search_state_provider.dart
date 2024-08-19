import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'products_search_state_provider.g.dart';

@riverpod
class ProductsSearchQueryState extends _$ProductsSearchQueryState {
  @override
  String build() {
    return "";
  }

  updateState(String value) {
    state = value;
  }
}

@riverpod
FutureOr<List<Product>> productsSearchResultsFuture(
    ProductsSearchResultsFutureRef ref) {
  final String searchQuery = ref.watch(productsSearchQueryStateProvider);
  return ref.watch(productsListSearchFutureProvider(searchQuery).future);
}
