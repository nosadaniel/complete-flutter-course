// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fake_products_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$productsRepositoryHash() =>
    r'b42cece3ae7aa853439e593dbe7fb98b1c62c86b';

/// See also [productsRepository].
@ProviderFor(productsRepository)
final productsRepositoryProvider = Provider<FakeProductsRepository>.internal(
  productsRepository,
  name: r'productsRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$productsRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ProductsRepositoryRef = ProviderRef<FakeProductsRepository>;
String _$productsListFutureHash() =>
    r'69e2bfe967ef6c3728367fede3aa1bd3e25fef50';

/// See also [productsListFuture].
@ProviderFor(productsListFuture)
final productsListFutureProvider =
    AutoDisposeFutureProvider<List<Product>>.internal(
  productsListFuture,
  name: r'productsListFutureProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$productsListFutureHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ProductsListFutureRef = AutoDisposeFutureProviderRef<List<Product>>;
String _$productsListStreamHash() =>
    r'a81e80c2f40889c305c20c577ce78773525b3e91';

/// See also [productsListStream].
@ProviderFor(productsListStream)
final productsListStreamProvider =
    AutoDisposeStreamProvider<List<Product>>.internal(
  productsListStream,
  name: r'productsListStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$productsListStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ProductsListStreamRef = AutoDisposeStreamProviderRef<List<Product>>;
String _$productFutureHash() => r'e3ec12bda4413f6e033c6ba6140950c686a58a07';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [productFuture].
@ProviderFor(productFuture)
const productFutureProvider = ProductFutureFamily();

/// See also [productFuture].
class ProductFutureFamily extends Family<AsyncValue<Product?>> {
  /// See also [productFuture].
  const ProductFutureFamily();

  /// See also [productFuture].
  ProductFutureProvider call(
    String productId,
  ) {
    return ProductFutureProvider(
      productId,
    );
  }

  @override
  ProductFutureProvider getProviderOverride(
    covariant ProductFutureProvider provider,
  ) {
    return call(
      provider.productId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'productFutureProvider';
}

/// See also [productFuture].
class ProductFutureProvider extends AutoDisposeFutureProvider<Product?> {
  /// See also [productFuture].
  ProductFutureProvider(
    String productId,
  ) : this._internal(
          (ref) => productFuture(
            ref as ProductFutureRef,
            productId,
          ),
          from: productFutureProvider,
          name: r'productFutureProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$productFutureHash,
          dependencies: ProductFutureFamily._dependencies,
          allTransitiveDependencies:
              ProductFutureFamily._allTransitiveDependencies,
          productId: productId,
        );

  ProductFutureProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.productId,
  }) : super.internal();

  final String productId;

  @override
  Override overrideWith(
    FutureOr<Product?> Function(ProductFutureRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProductFutureProvider._internal(
        (ref) => create(ref as ProductFutureRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        productId: productId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Product?> createElement() {
    return _ProductFutureProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductFutureProvider && other.productId == productId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, productId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ProductFutureRef on AutoDisposeFutureProviderRef<Product?> {
  /// The parameter `productId` of this provider.
  String get productId;
}

class _ProductFutureProviderElement
    extends AutoDisposeFutureProviderElement<Product?> with ProductFutureRef {
  _ProductFutureProviderElement(super.provider);

  @override
  String get productId => (origin as ProductFutureProvider).productId;
}

String _$productStreamHash() => r'c59baba5fe210d8cd4cec8cabc81d63f44fb9cd2';

/// See also [productStream].
@ProviderFor(productStream)
const productStreamProvider = ProductStreamFamily();

/// See also [productStream].
class ProductStreamFamily extends Family<AsyncValue<Product?>> {
  /// See also [productStream].
  const ProductStreamFamily();

  /// See also [productStream].
  ProductStreamProvider call(
    String productId,
  ) {
    return ProductStreamProvider(
      productId,
    );
  }

  @override
  ProductStreamProvider getProviderOverride(
    covariant ProductStreamProvider provider,
  ) {
    return call(
      provider.productId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'productStreamProvider';
}

/// See also [productStream].
class ProductStreamProvider extends AutoDisposeStreamProvider<Product?> {
  /// See also [productStream].
  ProductStreamProvider(
    String productId,
  ) : this._internal(
          (ref) => productStream(
            ref as ProductStreamRef,
            productId,
          ),
          from: productStreamProvider,
          name: r'productStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$productStreamHash,
          dependencies: ProductStreamFamily._dependencies,
          allTransitiveDependencies:
              ProductStreamFamily._allTransitiveDependencies,
          productId: productId,
        );

  ProductStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.productId,
  }) : super.internal();

  final String productId;

  @override
  Override overrideWith(
    Stream<Product?> Function(ProductStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProductStreamProvider._internal(
        (ref) => create(ref as ProductStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        productId: productId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<Product?> createElement() {
    return _ProductStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductStreamProvider && other.productId == productId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, productId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ProductStreamRef on AutoDisposeStreamProviderRef<Product?> {
  /// The parameter `productId` of this provider.
  String get productId;
}

class _ProductStreamProviderElement
    extends AutoDisposeStreamProviderElement<Product?> with ProductStreamRef {
  _ProductStreamProviderElement(super.provider);

  @override
  String get productId => (origin as ProductStreamProvider).productId;
}

String _$productsListSearchFutureHash() =>
    r'276f217a1b42182c806146f86dd9b23209fb937b';

/// See also [productsListSearchFuture].
@ProviderFor(productsListSearchFuture)
const productsListSearchFutureProvider = ProductsListSearchFutureFamily();

/// See also [productsListSearchFuture].
class ProductsListSearchFutureFamily extends Family<AsyncValue<List<Product>>> {
  /// See also [productsListSearchFuture].
  const ProductsListSearchFutureFamily();

  /// See also [productsListSearchFuture].
  ProductsListSearchFutureProvider call(
    String query,
  ) {
    return ProductsListSearchFutureProvider(
      query,
    );
  }

  @override
  ProductsListSearchFutureProvider getProviderOverride(
    covariant ProductsListSearchFutureProvider provider,
  ) {
    return call(
      provider.query,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'productsListSearchFutureProvider';
}

/// See also [productsListSearchFuture].
class ProductsListSearchFutureProvider
    extends AutoDisposeFutureProvider<List<Product>> {
  /// See also [productsListSearchFuture].
  ProductsListSearchFutureProvider(
    String query,
  ) : this._internal(
          (ref) => productsListSearchFuture(
            ref as ProductsListSearchFutureRef,
            query,
          ),
          from: productsListSearchFutureProvider,
          name: r'productsListSearchFutureProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$productsListSearchFutureHash,
          dependencies: ProductsListSearchFutureFamily._dependencies,
          allTransitiveDependencies:
              ProductsListSearchFutureFamily._allTransitiveDependencies,
          query: query,
        );

  ProductsListSearchFutureProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
  }) : super.internal();

  final String query;

  @override
  Override overrideWith(
    FutureOr<List<Product>> Function(ProductsListSearchFutureRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProductsListSearchFutureProvider._internal(
        (ref) => create(ref as ProductsListSearchFutureRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Product>> createElement() {
    return _ProductsListSearchFutureProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductsListSearchFutureProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ProductsListSearchFutureRef
    on AutoDisposeFutureProviderRef<List<Product>> {
  /// The parameter `query` of this provider.
  String get query;
}

class _ProductsListSearchFutureProviderElement
    extends AutoDisposeFutureProviderElement<List<Product>>
    with ProductsListSearchFutureRef {
  _ProductsListSearchFutureProviderElement(super.provider);

  @override
  String get query => (origin as ProductsListSearchFutureProvider).query;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
