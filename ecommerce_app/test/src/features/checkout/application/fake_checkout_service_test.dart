import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:ecommerce_app/src/features/cart/data/remote/remote_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/domain/cart.dart';
import 'package:ecommerce_app/src/features/checkout/application/fake_checkout_service.dart';
import 'package:ecommerce_app/src/features/checkout/presentation/checkout_screen/checkout_screen.dart';
import 'package:ecommerce_app/src/features/orders/data/fake_orders_repository.dart';
import 'package:ecommerce_app/src/features/orders/domain/order.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  const testUser = AppUser(uid: 'abc');

  late MockFakeAuthRepository authRepository;
  late MockRemoteCartRepository remoteCartRepository;
  late MockOrdersRespository ordersRespository;

  setUpAll(() {
    //needed for MockOrdersRepository
    registerFallbackValue(Order(
        id: '1',
        userId: testUser.uid,
        items: {'1': 1},
        orderStatus: OrderStatus.confirmed,
        orderDate: DateTime(2024, 8, 5),
        total: 15));
    // needed for MockRemoteCartRepository
    registerFallbackValue(const Cart());
  });

  setUp(() {
    authRepository = MockFakeAuthRepository();
    remoteCartRepository = MockRemoteCartRepository();
    ordersRespository = MockOrdersRespository();
  });

  FakeCheckoutService makeCheckService() {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(authRepository),
        remoteCartRepositoryProvider.overrideWithValue(remoteCartRepository),
        ordersRepostoryProvider.overrideWithValue(ordersRespository),
      ],
    );
    addTearDown(container.dispose);
    return container.read(checkoutServiceProvider);
  }

  group('placeOrder', () {
    test('null user, throws', () async {
      //setUp
      when(() => authRepository.currentUser).thenReturn(null);
      final checkoutService = makeCheckService();
      //run
      expect(checkoutService.placeOrder(), throwsA(isA<TypeError>()));
    });

    test('empty cart, throws', () async {
      //setup
      when(() => authRepository.currentUser).thenReturn(testUser);
      when(() => remoteCartRepository.fetchCart(testUser.uid))
          .thenAnswer((_) => Future.value(const Cart()));

      final checkoutService = makeCheckService();
      //run
      expect(checkoutService.placeOrder(), throwsA(isA<TypeError>()));
    });

    test('non-empty cart, creates order', () async {
      //setup
      when(() => authRepository.currentUser).thenReturn(testUser);
      when(() => remoteCartRepository.fetchCart(testUser.uid))
          .thenAnswer((_) => Future.value(const Cart({'1': 1})));
      when(() => ordersRespository.addOrder(testUser.uid, any()))
          .thenAnswer((_) => Future.value());
      when(() => remoteCartRepository.clearCart(testUser.uid))
          .thenAnswer((_) => Future.value());
      final checkoutService = makeCheckService();
      //run
      await checkoutService.placeOrder();
      //verify
      verify(() => ordersRespository.addOrder(testUser.uid, any())).called(1);
      verify(() => remoteCartRepository.clearCart(testUser.uid)).called(1);
    });
  });
}
