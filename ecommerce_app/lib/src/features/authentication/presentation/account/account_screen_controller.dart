import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/fake_auth_repository.dart';

class AccountScreenController extends StateNotifier<AsyncValue> {
  AccountScreenController({required this.authRepository})
      : super(const AsyncValue.data(null));
  final FakeAuthRepository authRepository;

  /// return `true' when no error occurs
  Future<bool> signOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () async => await authRepository.signOut(),
    );
    return state.hasError == false;
  }
}

final accountScreenControllerProvider =
    StateNotifierProvider.autoDispose<AccountScreenController, AsyncValue>(
        (ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return AccountScreenController(authRepository: authRepo);
});
