// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_orders_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userOrdersHash() => r'b45478acf5542bd6fc17fb1d8bcf9d60731ad694';

/// NOTE: only watch this provider if the user is signed in.
///
///
/// Copied from [userOrders].
@ProviderFor(userOrders)
final userOrdersProvider = AutoDisposeStreamProvider<List<Order>>.internal(
  userOrders,
  name: r'userOrdersProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userOrdersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UserOrdersRef = AutoDisposeStreamProviderRef<List<Order>>;
String _$matchingUserOrdersHash() =>
    r'226effd50fd464db4730e05e4120c7a4e53ec57c';

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

/// See also [matchingUserOrders].
@ProviderFor(matchingUserOrders)
const matchingUserOrdersProvider = MatchingUserOrdersFamily();

/// See also [matchingUserOrders].
class MatchingUserOrdersFamily extends Family<AsyncValue<List<Order>>> {
  /// See also [matchingUserOrders].
  const MatchingUserOrdersFamily();

  /// See also [matchingUserOrders].
  MatchingUserOrdersProvider call(
    String productId,
  ) {
    return MatchingUserOrdersProvider(
      productId,
    );
  }

  @override
  MatchingUserOrdersProvider getProviderOverride(
    covariant MatchingUserOrdersProvider provider,
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
  String? get name => r'matchingUserOrdersProvider';
}

/// See also [matchingUserOrders].
class MatchingUserOrdersProvider
    extends AutoDisposeStreamProvider<List<Order>> {
  /// See also [matchingUserOrders].
  MatchingUserOrdersProvider(
    String productId,
  ) : this._internal(
          (ref) => matchingUserOrders(
            ref as MatchingUserOrdersRef,
            productId,
          ),
          from: matchingUserOrdersProvider,
          name: r'matchingUserOrdersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$matchingUserOrdersHash,
          dependencies: MatchingUserOrdersFamily._dependencies,
          allTransitiveDependencies:
              MatchingUserOrdersFamily._allTransitiveDependencies,
          productId: productId,
        );

  MatchingUserOrdersProvider._internal(
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
    Stream<List<Order>> Function(MatchingUserOrdersRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MatchingUserOrdersProvider._internal(
        (ref) => create(ref as MatchingUserOrdersRef),
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
  AutoDisposeStreamProviderElement<List<Order>> createElement() {
    return _MatchingUserOrdersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MatchingUserOrdersProvider && other.productId == productId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, productId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MatchingUserOrdersRef on AutoDisposeStreamProviderRef<List<Order>> {
  /// The parameter `productId` of this provider.
  String get productId;
}

class _MatchingUserOrdersProviderElement
    extends AutoDisposeStreamProviderElement<List<Order>>
    with MatchingUserOrdersRef {
  _MatchingUserOrdersProviderElement(super.provider);

  @override
  String get productId => (origin as MatchingUserOrdersProvider).productId;
}

String _$totalOrderCountHash() => r'a5a72a441d55e29c52785fad216a74876185da41';

/// See also [totalOrderCount].
@ProviderFor(totalOrderCount)
final totalOrderCountProvider = AutoDisposeProvider<int>.internal(
  totalOrderCount,
  name: r'totalOrderCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$totalOrderCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TotalOrderCountRef = AutoDisposeProviderRef<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
