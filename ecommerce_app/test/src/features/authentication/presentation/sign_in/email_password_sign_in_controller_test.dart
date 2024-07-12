@Timeout(Duration(milliseconds: 5000))
import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_controller.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../mocks.dart';

void main() {
  const testEmail = "test@test.com";
  const testPassword = "1234";

  late MockFakeAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockFakeAuthRepository();
  });
  group('submit', () {
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
        final controller = EmailPasswordSignInController(
            authRepository: mockAuthRepository,
            formType: EmailPasswordSignInFormType.signIn);
        //expect later
        expectLater(
          controller.stream,
          emitsInOrder([
            EmailPasswordSignInState(
              formType: EmailPasswordSignInFormType.signIn,
              value: const AsyncLoading<void>(),
            ),
            EmailPasswordSignInState(
              formType: EmailPasswordSignInFormType.signIn,
              value: const AsyncData<void>(null),
            )
          ]),
        );

        final result =
            await controller.submit(email: testEmail, password: testPassword);

        //expect
        expect(result, true);

        //verify
        verify(() => mockAuthRepository.signInWithEmailAndPassword(
            testEmail, testPassword)).called(1);
      },
    );

    test('''
      Given formType is signIn
      when signInWithEmailAndPassword fails
      Then return false
      And state is AsyncError
      ''', () async {
      //stud
      final Exception exception = Exception("connection error");
      when(() => mockAuthRepository.signInWithEmailAndPassword(
          testEmail, testPassword)).thenThrow((_) => exception);
      final controller = EmailPasswordSignInController(
          authRepository: mockAuthRepository,
          formType: EmailPasswordSignInFormType.signIn);
      //expect later
      expectLater(
        controller.stream,
        emitsInOrder([
          EmailPasswordSignInState(
            formType: EmailPasswordSignInFormType.signIn,
            value: const AsyncLoading<void>(),
          ),
          // using predicate since we can't match the stack trace
          predicate<EmailPasswordSignInState>((state) {
            expect(state.formType, EmailPasswordSignInFormType.signIn);
            expect(state.value.hasError, true);
            return true;
          }),
        ]),
      );

      final result =
          await controller.submit(email: testEmail, password: testPassword);

      //expect
      expect(result, false);
      //verify
      verify(() => mockAuthRepository.signInWithEmailAndPassword(
          testEmail, testPassword)).called(1);
    });

    test(
      '''
      Given formType is register
      when createUserWithEmailAndPassword succeeds
      Then return true
      And state is AsyncData
      ''',
      () async {
        //stud
        when(() => mockAuthRepository.createUserWithEmailAndPassword(
            testEmail, testPassword)).thenAnswer(
          (_) => Future.value(),
        );
        final controller = EmailPasswordSignInController(
            authRepository: mockAuthRepository,
            formType: EmailPasswordSignInFormType.register);

        //expect later
        expectLater(
          controller.stream,
          emitsInOrder([
            EmailPasswordSignInState(
              formType: EmailPasswordSignInFormType.register,
              value: const AsyncLoading<void>(),
            ),
            EmailPasswordSignInState(
              formType: EmailPasswordSignInFormType.register,
              value: const AsyncData<void>(null),
            )
          ]),
        );

        final result =
            await controller.submit(email: testEmail, password: testPassword);

        //expect
        expect(result, true);

        //verify
        verify(() => mockAuthRepository.createUserWithEmailAndPassword(
            testEmail, testPassword)).called(1);
      },
    );

    test('''
      Given formType is register
      when createUserWithEmailAndPassword fails
      Then return false
      And state is AsyncError
      ''', () async {
      //stud
      final Exception exception = Exception("connection error");
      when(() => mockAuthRepository.createUserWithEmailAndPassword(
          testEmail, testPassword)).thenThrow((_) => exception);
      final controller = EmailPasswordSignInController(
          authRepository: mockAuthRepository,
          formType: EmailPasswordSignInFormType.register);
      //expect later
      expectLater(
        controller.stream,
        emitsInOrder([
          EmailPasswordSignInState(
            formType: EmailPasswordSignInFormType.register,
            value: const AsyncLoading<void>(),
          ),
          // using predicate since we can't match the stack trace
          predicate<EmailPasswordSignInState>((state) {
            expect(state.formType, EmailPasswordSignInFormType.register);
            expect(state.value.hasError, true);
            return true;
          }),
        ]),
      );

      final result =
          await controller.submit(email: testEmail, password: testPassword);

      //expect
      expect(result, false);
      //verify
      verify(() => mockAuthRepository.createUserWithEmailAndPassword(
          testEmail, testPassword)).called(1);
    });
  });

  group('updateFormType', () {
    test('''Given formType is register
    When called with signIn
    Then state.formType is signIn''', () {
      //setup
      final controller = EmailPasswordSignInController(
          authRepository: mockAuthRepository,
          formType: EmailPasswordSignInFormType.register);
   
      //run
      controller.updateFormType(EmailPasswordSignInFormType.signIn);

      expect(
        controller.debugState,
        EmailPasswordSignInState(
            formType: EmailPasswordSignInFormType.signIn,
            value: const AsyncData(null)),
      );
    });
  });
}
