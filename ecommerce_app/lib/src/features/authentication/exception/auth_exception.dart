import 'package:ecommerce_app/src/exceptions/app_exception.dart';
import 'package:ecommerce_app/src/localization/string_hardcoded.dart';

sealed class AuthException extends AppException {
  AuthException(super.code, super.message);
}

class EmailAlreadyInUseException extends AuthException {
  EmailAlreadyInUseException()
      : super('email-already-in-user', 'Email already in user'.hardcoded);
}

class WeakPasswordException extends AppException {
  WeakPasswordException()
      : super('weak-password', 'Password is too weak'.hardcoded);
}

class WrongPasswordException extends AppException {
  WrongPasswordException()
      : super('wrong-password', 'Wrong password'.hardcoded);
}

class UserNotFoundException extends AppException {
  UserNotFoundException() : super('user-not-found', 'User not found'.hardcoded);
}
