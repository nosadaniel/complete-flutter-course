@Timeout(Duration(milliseconds: 1000))
import 'package:ecommerce_app/src/features/authentication/presentation/account/account_screen_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../mocks.dart';

void main() {
  late MockFakeAuthRepository mockAuthRepository;
  late AccountScreenController controller;

  setUp(() {
    mockAuthRepository = MockFakeAuthRepository();
    controller = AccountScreenController(
      authRepository: mockAuthRepository,
    );
  });
  group('account screen controller ...', () {
    test('Initial state is AsyncValue.data', () {
      //verify that signOut method was never called
      verifyNever(mockAuthRepository.signOut);
      //expectation
      expect(controller.debugState, const AsyncData<void>(null));
    });
    test('SignOut is null', () async {
      //stub
      when(mockAuthRepository.signOut).thenAnswer((_) async {});
      //run
      await controller.signOut();

      //verify
      verify(mockAuthRepository.signOut).called(1);

      //expectation
      expect(controller.debugState, const AsyncData<void>(null));
    });

    test('SignOut success', () async {
      //stub
      when(mockAuthRepository.signOut).thenAnswer((_) async {});
      //run
      await controller.signOut();

      //verify
      verify(mockAuthRepository.signOut).called(1);

      //expectation
      expect(controller.debugState, const AsyncData<void>(null));
    });

    test('SignOut failure', () async {
      final exception = Exception('Connection Error');

      //stub
      when(mockAuthRepository.signOut).thenThrow(exception);

      //expect later
      //use predicate when testing for error
      expectLater(
          controller.stream,
          emitsInOrder([
            const AsyncLoading<void>(),
            predicate<AsyncValue<void>>((value) {
              expect(value.hasError, true);
              return true;
            }),
          ]));
      //run
      await controller.signOut();

      //verify
      verify(mockAuthRepository.signOut).called(1);
    });
  });
}
