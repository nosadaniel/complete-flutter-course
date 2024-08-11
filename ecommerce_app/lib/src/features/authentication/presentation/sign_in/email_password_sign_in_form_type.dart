import 'package:ecommerce_app/src/localization/string_hardcoded.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Form type for email & password authentication
enum EmailPasswordSignInFormType { signIn, register }

extension EmailPasswordSignInFormTypeX on EmailPasswordSignInFormType {
  String get passwordLabelText {
    if (this == EmailPasswordSignInFormType.register) {
      return 'Password (8+ characters)'.hardcoded;
    } else {
      return 'Password'.hardcoded;
    }
  }

  String get textTitle {
    if (this == EmailPasswordSignInFormType.register) {
      return 'Register'.hardcoded;
    } else {
      return 'Sign in'.hardcoded;
    }
  }

  String get primaryButtonText {
    if (this == EmailPasswordSignInFormType.register) {
      return 'Create an account'.hardcoded;
    } else {
      return 'Sign in'.hardcoded;
    }
  }

  String get secondaryButtonText {
    if (this == EmailPasswordSignInFormType.register) {
      return 'Have an account? Sign in'.hardcoded;
    } else {
      return 'Need an account? Register'.hardcoded;
    }
  }

  EmailPasswordSignInFormType get secondaryActionFormType {
    if (this == EmailPasswordSignInFormType.register) {
      return EmailPasswordSignInFormType.signIn;
    } else {
      return EmailPasswordSignInFormType.register;
    }
  }

  String get errorAlertTitle {
    if (this == EmailPasswordSignInFormType.register) {
      return 'Registration failed'.hardcoded;
    } else {
      return 'Sign in failed'.hardcoded;
    }
  }

  String get title {
    if (this == EmailPasswordSignInFormType.register) {
      return 'Register'.hardcoded;
    } else {
      return 'Sign in'.hardcoded;
    }
  }
}

//todo
// final emailPasswordSignInFormTypeProvider =
//     StateProvider<EmailPasswordSignInFormType>((ref) {
//   return EmailPasswordSignInFormType.signIn;
// });

// final updateFormTypeProvider =
//     StateProvider.family<void, EmailPasswordSignInFormType>((ref, formType) {
//   ref.watch(emailPasswordSignInFormTypeProvider.notifier).state = formType;
// });
