@Timeout(Duration(milliseconds: 5000))
library;

import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_controller.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_form_type.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../mocks.dart';

void main() {
  const testEmail = "test@test.com";
  const testPassword = "1234";
  const testFormType = EmailPasswordSignInFormType.signIn;
  late MockFakeAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockFakeAuthRepository();
  });
  ProviderContainer makeProviderContainer(
      MockFakeAuthRepository authRepository) {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(authRepository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('EmailPasswordSignInController', () {
    test(
      '''
      Given formType is signIn
      when signInWithEmailAndPassword succeeds
      Then return true
      And state is AsyncData
      ''',
      () async {
        //stud
        when(() => mockAuthRepository.signInWithEmailAndPassword(
            testEmail, testPassword)).thenAnswer(
          (_) => Future.value(),
        );
        final container = makeProviderContainer(mockAuthRepository);
        final listener = MockListener<AsyncValue<void>>();
        container.listen(emailPasswordSignInControllerProvider, listener.call,
            fireImmediately: true);

        verify(() => listener(null, const AsyncData<void>(null)));
        final controller =
            container.read(emailPasswordSignInControllerProvider.notifier);

        final result = await controller.submit(
            email: testEmail, password: testPassword, formType: testFormType);

        //expect
        expect(result, true);

        //verify
        verify(() => mockAuthRepository.signInWithEmailAndPassword(
            testEmail, testPassword)).called(1);
      },
    );
  });
}
