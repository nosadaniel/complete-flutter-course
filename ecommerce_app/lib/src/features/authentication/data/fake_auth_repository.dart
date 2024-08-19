import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:ecommerce_app/src/features/authentication/domain/fake_app_user.dart';
import 'package:ecommerce_app/src/features/authentication/exception/auth_exception.dart';
import 'package:ecommerce_app/src/utils/delay_call.dart';
import 'package:ecommerce_app/src/utils/in_memory_store.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fake_auth_repository.g.dart';

class FakeAuthRepository {
  FakeAuthRepository({bool addDelay = true}) : _delay = addDelay;

  final bool _delay;
  final _authState = InMemoryStore<AppUser?>(null);

  Stream<AppUser?> authStateChanges() => _authState.stream;

  AppUser? get currentUser => _authState.value;

//fake existing users
  final List<FakeAppUser> _users = [];

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    //check th given credentials agains each registered user
    await delay(_delay);
    for (final u in _users) {
      //matching email and password
      if (u.email == email && u.password == password) {
        _authState.value = u;
        return;
      }
      //same email, wrong password
      if (u.email == email && u.password != password) {
        throw WrongPasswordException();
      }
    }
    throw UserNotFoundException();
  }

  Future<void> createUserWithEmailAndPassword(
      //throw Exception("connection failed");
      String email,
      String password) async {
    await delay(_delay);
    //check if the email is already in use
    for (final u in _users) {
      if (u.email == email) {
        throw EmailAlreadyInUseException();
      }
    }
    //minimum password length requirement
    if (password.length < 8) {
      throw WeakPasswordException();
    }

    _createNewUser(email, password);
  }

  Future<void> signOut() async {
    //throw Exception("connection failed");
    await delay(_delay);
    _authState.value = null;
  }

  void _createNewUser(String email, String password) {
    //create new user
    final user = FakeAppUser(
        uid: email.split('').reversed.join(), email: email, password: password);
    //register it
    _users.add(user);
    //update the auth state
    _authState.value = user;
  }

  void dispose() => _authState.close();
}

@Riverpod(keepAlive: true)
FakeAuthRepository authRepository(AuthRepositoryRef ref) {
  final auth = FakeAuthRepository(addDelay: true);
  ref.onDispose(() => auth.dispose());
  return auth;
}

@Riverpod(keepAlive: true)
Stream<AppUser?> authStateChanges(AuthStateChangesRef ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
}
