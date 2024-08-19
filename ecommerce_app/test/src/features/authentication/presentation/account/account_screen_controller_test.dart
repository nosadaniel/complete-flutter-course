// ignore_for_file: library_annotations

@Timeout(Duration(milliseconds: 1000))
import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/account/account_screen_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../mocks.dart';

void main() {
  setUp(() {
    registerFallbackValue(const AsyncLoading<void>());
  });
  ProviderContainer makeContainer(FakeAuthRepository authRepository) {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(authRepository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('account screen controller ...', () {
    test('Initial state is AsyncData', () {
      final authRepository = MockFakeAuthRepository();
      final container = makeContainer(authRepository);

      final listener = MockListener<AsyncValue<void>>();
      container.listen(accountScreenControllerProvider, listener.call,
          fireImmediately: true);

      //verify
      verify(
        () => listener(null, const AsyncData<void>(null)),
      );
      //verify that the listener is no longer call
      verifyNoMoreInteractions(listener);
      //verify that [signInAnonnymouslty] was not called during initialization
      verifyNever(() => authRepository.signOut());
    });

    test('signOut, success', () async {
      //setup
      final authRepository = MockFakeAuthRepository();
      //stub method to return success
      when(() => authRepository.signOut()).thenAnswer((_) => Future.value());
      //create the ProviderContainer with [MockAuthRepository]
      final container = makeContainer(authRepository);
      //create a listener
      final listener = MockListener<AsyncValue<void>>();
      //listern to the provider and call [listener] where its value changes
      container.listen(accountScreenControllerProvider, listener.call,
          fireImmediately: true);
      const data = AsyncData<void>(null);
      //verify initial value from build method
      verify(
        () => listener(null, data),
      );
      // run
      final controller =
          container.read(accountScreenControllerProvider.notifier);
      await controller.signOut();
      //verify
      verifyInOrder([
        //set loading state
        () => listener(data, any(that: isA<AsyncLoading>())),
        () => listener(any(that: isA<AsyncLoading>()), data)
      ]);
      //verify that the listener is no longer call
      verifyNoMoreInteractions(listener);
      verify(() => authRepository.signOut()).called(1);
    });

    test('signOut, failure', () async {
      //setup
      final authRepository = MockFakeAuthRepository();
      //stub method to return success
      when(() => authRepository.signOut()).thenThrow((_) => Exception());
      //create the ProviderContainer with [MockAuthRepository]
      final container = makeContainer(authRepository);
      //create a listener
      final listener = MockListener<AsyncValue<void>>();
      //listern to the provider and call [listener] where its value changes
      container.listen(accountScreenControllerProvider, listener.call,
          fireImmediately: true);
      const data = AsyncData<void>(null);
      //verify initial value from build method
      verify(() => listener(null, data));
      //run
      final controller =
          container.read(accountScreenControllerProvider.notifier);
      await controller.signOut();
      //verify
      verifyInOrder([
        //set loading state
        // * use a matcher since AsyncLoading !=  AsyncLoading with data
        () => listener(data, any(that: isA<AsyncLoading>())),
        // error when complete
        () => listener(
            any(that: isA<AsyncLoading>()), any(that: isA<AsyncError>())),
      ]);
      //verify that the listener is no longer call
      verifyNoMoreInteractions(listener);
      verify(() => authRepository.signOut()).called(1);
    });
  });
}
