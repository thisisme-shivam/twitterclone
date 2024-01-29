import 'dart:ui';

import 'package:appwrite/models.dart' as model;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitterclone/apis/auth_api.dart';
import 'package:twitterclone/apis/user_api.dart';
import 'package:twitterclone/core/utils.dart';
import 'package:twitterclone/features/home/view/home_view.dart';
import 'package:twitterclone/models/user_model.dart';
import '../view/login_view.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
    authAPI: ref.watch(authAPIProvider),
    userAPI: ref.watch(userAPIProvider),
  );
});

final currentUserDetailsProvider = FutureProvider((ref) async {
  final currentUserId = ref.watch(currentUserAccountProvider).value!.$id;
  final userDetails = ref.watch(userDetailsProvider(currentUserId)).value;
  return userDetails;
});

final userDetailsProvider = FutureProvider.family((ref,String uid) async {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});
final currentUserAccountProvider = FutureProvider((ref) async {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.currentUser();
});

class AuthController extends StateNotifier<bool> {
  AuthController({required AuthAPI authAPI, required UserAPI userAPI})
      : _authAPI = authAPI,
        _userAPI = userAPI,
        super(false);

  //  state =  isLoading
  final AuthAPI _authAPI;
  final UserAPI _userAPI;

  Future<model.User?> currentUser() => _authAPI.currentUserAccount();

  void signUp({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.signUp(email: email, password: password);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) async {
      UserModel userModel = UserModel(
          email: email,
          name: getNameFromEmail(email),
          followers: [],
          following: [],
          profilePic: '',
          bannerPic: '',
          bio: '',
          uid: r.$id,
          isTwitterBlue: false);
      final res2 = await _userAPI.saveUserData(userModel);
      res2.fold((l) => showSnackBar(context, l.message), (r) {
        showSnackBar(context, 'Account created');
        Navigator.push(context, LoginView.route());
      });
    });
  }

  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.login(email: email, password: password);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Login Successful');
      Navigator.push(context, HomeView.route());
    });
  }

  Future<UserModel> getUserData(String uid) async {
    final document = await _userAPI.getUserData(uid);
    print(document.data);

    final updatedUser = UserModel.fromMap(document.data);
    print(updatedUser.toString());
    return updatedUser;
  }
}
