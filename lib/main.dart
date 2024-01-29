import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitterclone/common/error_page.dart';
import 'package:twitterclone/features/auth/controller/auth_controller.dart';
import 'package:twitterclone/features/auth/view/signup_view.dart';
import 'package:twitterclone/features/home/view/home_view.dart';
import 'package:twitterclone/theme/theme.dart';

import 'common/loading_page.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: AppTheme.theme,
        home: ref.watch(currentUserAccountProvider).when(
            data: (user) {
              if (user != null) {
                return const HomeView();
              }
                return const SignupView();

            },
            error: (error, stackTrace) {
              return ErrorPage(errorText: error.toString());
            },
            loading: () => const LoadingPage()));
  }
}
