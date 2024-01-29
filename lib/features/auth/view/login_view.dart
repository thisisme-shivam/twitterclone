import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitterclone/common/rounded_small_button.dart';
import 'package:twitterclone/constants/ui_constants.dart';
import 'package:twitterclone/features/auth/controller/auth_controller.dart';
import 'package:twitterclone/features/auth/view/signup_view.dart';
import 'package:twitterclone/features/auth/widgets/auth_field.dart';
import 'package:twitterclone/theme/pallete.dart';

import '../../../common/loading_page.dart';

class LoginView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const LoginView());
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final appBar = UIConstants.appBar();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void login() {
    ref.read(authControllerProvider.notifier).login(
        email: emailController.text,
        password: passwordController.text,
        context: context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: appBar,
      body: isLoading
          ? const Loader()
          : Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      AuthField(
                          controller: emailController,
                          hintText: 'Email Address'),
                      const SizedBox(height: 25),
                      AuthField(
                        controller: passwordController,
                        hintText: 'Password',
                      ),
                      const SizedBox(height: 40),
                      Align(
                        alignment: Alignment.topRight,
                        child: RoundedSmallButton(
                          onTap: login,
                          label: 'Done',
                        ),
                      ),
                      const SizedBox(height: 40),
                      RichText(
                        text: TextSpan(
                            text: "Don't have an account?",
                            style: const TextStyle(fontSize: 16),
                            children: [
                              TextSpan(
                                text: " Sign Up",
                                style: const TextStyle(
                                    color: Pallete.blueColor, fontSize: 16),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(context, SignupView.route());
                                  },
                              ),
                            ]),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
