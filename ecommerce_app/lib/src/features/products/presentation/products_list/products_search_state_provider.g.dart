// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'products_search_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$productsSearchResultsFutureHash() =>
    r'814680c5574c250e5dd0ad7a21ee86c0a7f2ccc2';

/// See also [productsSearchResultsFuture].
@ProviderFor(productsSearchResultsFuture)
final productsSearchResultsFutureProvider =
    AutoDisposeFutureProvider<List<Product>>.internal(
  productsSearchResultsFuture,
  name: r'productsSearchResultsFutureProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$productsSearchResultsFutureHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ProductsSearchResultsFutureRef
    = AutoDisposeFutureProviderRef<List<Product>>;
String _$productsSearchQueryStateHash() =>
    r'5b362069988c70240f809c1f492247dc01080d63';

/// See also [ProductsSearchQueryState].
@ProviderFor(ProductsSearchQueryState)
final productsSearchQueryStateProvider =
    AutoDisposeNotifierProvider<ProductsSearchQueryState, String>.internal(
  ProductsSearchQueryState.new,
  name: r'productsSearchQueryStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$productsSearchQueryStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ProductsSearchQueryState = AutoDisposeNotifier<String>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
