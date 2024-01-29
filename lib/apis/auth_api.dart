import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitterclone/core/providers.dart';
import '../core/core.dart';

final authAPIProvider = Provider((ref) {
  return AuthAPI(account: ref.watch(appwriteAccountProvider));
});

abstract class IAuthAPI {
  Future<model.User?> currentUserAccount();

  FutureEither<model.User> signUp({
    required String email,
    required String password,
  });

  FutureEither<model.Session> login({
    required String email,
    required String password,
  });
}

class AuthAPI implements IAuthAPI {
  final Account _account;

  AuthAPI({required Account account}) : _account = account;

  @override
  Future<model.User?> currentUserAccount() async {
    try {
      return await _account.get();
    } catch (e) {
      return null;
    }
  }

  @override
  FutureEither<model.User> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _account.create(
          userId: ID.unique(), email: email, password: password);
      return Either.right(user);
    } on AppwriteException catch (e, stackTrace) {
      return Either.left(Failure(e.message ?? 'Unexpected Error', stackTrace));
    } catch (e, stackTrace) {
      return Either.left(Failure(e.toString(), stackTrace));
    }
  }

  @override
  FutureEither<model.Session> login(
      {required String email, required String password}) async {
    try {
      final session =
          await _account.createEmailSession(email: email, password: password);
      return Either.right(session);
    } on AppwriteException catch (e, stackTrace) {
      return Either.left(Failure(e.message ?? 'Unexpected Error', stackTrace));
    } catch (e, stackTrace) {
      return Either.left(Failure(e.toString(), stackTrace));
    }
  }
}
