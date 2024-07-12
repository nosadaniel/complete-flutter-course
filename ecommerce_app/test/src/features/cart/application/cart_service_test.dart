import 'dart:math';

import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:ecommerce_app/src/features/cart/application/cart_service.dart';
import 'package:ecommerce_app/src/features/cart/data/local/local_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/remote/remote_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/domain/cart.dart';
import 'package:ecommerce_app/src/features/cart/domain/item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  late MockFakeAuthRepository authRepository;
  late MockRemoteCartRepository remoteCartRepository;
  late MockLocalCartRepository localCartRepository;

  const testUser = AppUser(uid: 'test');

  setUp(() {
    authRepository = MockFakeAuthRepository();
    remoteCartRepository = MockRemoteCartRepository();
    localCartRepository = MockLocalCartRepository();
  });

  CartService makeCartService() {
    //create a container
    final ProviderContainer container = ProviderContainer(
      //override the providers with our mocks
      overrides: [
        authRepositoryProvider.overrideWithValue(authRepository),
        localCartRepositoryProvider.overrideWithValue(localCartRepository),
        remoteCartRepositoryProvider.overrideWithValue(remoteCartRepository)
      ],
    );
    addTearDown(container.dispose);
    //return CartService
    return container.read(cartServiceProvider);
  }

  setUpAll(() {
    registerFallbackValue(const Cart());
  });
  group('setItem', () {
    test('null user, writes item to local cart', () async {
      const expectedCart = Cart({'123': 2});
      //stud
      when(() => authRepository.currentUser).thenReturn(null);
      when(() => localCartRepository.fetchCart()).thenAnswer(
        (_) => Future.value(const Cart()),
      );
      when(() => localCartRepository.setCart(expectedCart)).thenAnswer(
        (_) => Future.value(),
      );
      final cartService = makeCartService();
      //run
      await cartService.setItem(const Item(productId: '123', quantity: 2));
      //verify
      verify(() => localCartRepository.setCart(expectedCart)).called(1);
      verifyNever(
        //note: this requires a fallback value
        () => remoteCartRepository.setCart(
          any(),
          any(),
        ),
      );
    });
    test('non-null user, writes  item to remote cart', () async {
      const expectedCart = Cart({'123': 2});
      //stud
      when(() => authRepository.currentUser).thenReturn(testUser);
      when(() => remoteCartRepository.fetchCart(testUser.uid)).thenAnswer(
        (_) => Future.value(const Cart()),
      );
      when(() => remoteCartRepository.setCart(testUser.uid, expectedCart))
          .thenAnswer(
        (_) => Future.value(),
      );
      final cartService = makeCartService();
      //run
      await cartService.setItem(const Item(productId: '123', quantity: 2));
      //verify
      verify(() => remoteCartRepository.setCart(testUser.uid, expectedCart))
          .called(1);
      verifyNever(
        //note: this requires a fallback value
        () => localCartRepository.setCart(
          any(),
        ),
      );
    });
  });
  group('addItem', () {
    test('null user, adds item to local cart', () async {
      // setup
      const initialCart = Cart({'123': 2});
      const expectedCart = Cart({'123': 3});
      when(() => authRepository.currentUser).thenReturn(null); // null user
      when(localCartRepository.fetchCart).thenAnswer(
        (_) => Future.value(initialCart), // empty cart
      );
      when(() => localCartRepository.setCart(expectedCart)).thenAnswer(
        (_) => Future.value(),
      );
      final cartService = makeCartService();
      // run
      await cartService.addItem(const Item(productId: '123', quantity: 1));
      // verify
      verify(
        () => localCartRepository.setCart(expectedCart),
      ).called(1);
      verifyNever(
        () => remoteCartRepository.setCart(any(), any()),
      );
    });

    test('non-null user, adds item to local cart', () async {
      // setup
      const initialCart = Cart({'123': 2});
      const expectedCart = Cart({'123': 3});
      when(() => authRepository.currentUser).thenReturn(testUser); // null user
      when(() => remoteCartRepository.fetchCart(testUser.uid)).thenAnswer(
        (_) => Future.value(initialCart),
      ); // empty cart

      when(() => remoteCartRepository.setCart(testUser.uid, expectedCart))
          .thenAnswer(
        (_) => Future.value(),
      );
      final cartService = makeCartService();
      // run
      await cartService.addItem(const Item(productId: '123', quantity: 1));
      // verify
      verify(
        () => remoteCartRepository.setCart(testUser.uid, expectedCart),
      ).called(1);
      verifyNever(
        () => localCartRepository.setCart(any()),
      );
    });
  });
  group('removeItem', () {
    test('null user, remove item to local cart', () async {
      // setup
      const initialCart = Cart({'123': 2, '122': 3});
      const expectedCart = Cart({'122': 3});
      when(() => authRepository.currentUser).thenReturn(null); // null user
      when(localCartRepository.fetchCart).thenAnswer(
        (_) => Future.value(initialCart), // empty cart
      );
      when(() => localCartRepository.setCart(expectedCart)).thenAnswer(
        (_) => Future.value(),
      );
      final cartService = makeCartService();
      // run
      await cartService.removeItemById('123');
      // verify
      verify(
        () => localCartRepository.setCart(expectedCart),
      ).called(1);
      verifyNever(
        () => remoteCartRepository.setCart(any(), any()),
      );
    });

    test('non-null user, remove item to local cart', () async {
      // setup
      const initialCart = Cart({'123': 2, '122': 2});
      const expectedCart = Cart({'122': 2});
      when(() => authRepository.currentUser).thenReturn(testUser); // null user
      when(() => remoteCartRepository.fetchCart(testUser.uid)).thenAnswer(
        (_) => Future.value(initialCart),
      ); // empty cart

      when(() => remoteCartRepository.setCart(testUser.uid, expectedCart))
          .thenAnswer(
        (_) => Future.value(),
      );
      final cartService = makeCartService();
      // run
      await cartService.removeItemById('123');
      // verify
      verify(
        () => remoteCartRepository.setCart(testUser.uid, expectedCart),
      ).called(1);
      verifyNever(
        () => localCartRepository.setCart(any()),
      );
    });
  });
}
