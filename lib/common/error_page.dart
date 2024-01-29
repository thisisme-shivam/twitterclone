
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorText extends StatelessWidget {
  final String errorText;
  const ErrorText({super.key,required this.errorText});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(errorText),);
  }
}


class ErrorPage extends StatelessWidget {
  final String errorText;

  const ErrorPage({super.key,required this.errorText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ErrorText(errorText:errorText),);
  }
}
