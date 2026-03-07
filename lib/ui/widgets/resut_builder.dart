import 'package:flutter/material.dart';
import 'package:flutter_shopping_cart_mvvm/domain/exceptions/app_exception.dart';
import 'package:flutter_shopping_cart_mvvm/utils/command.dart';

import '../../utils/result.dart';

class ResultBuilder<T> extends StatelessWidget {
  final Command<T> command;

  final Widget Function(BuildContext context, T? value) onSuccess;
  final Widget Function(BuildContext context, AppException error)? onError;
  final Widget Function(BuildContext context)? onLoading;
  final Widget Function(BuildContext context)? onEmpty;

  const ResultBuilder({
    super.key,
    required this.command,
    required this.onSuccess,
    this.onError,
    this.onLoading,
    this.onEmpty,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: command,
      builder: (_, __) {
        if (command.isRunning) {
          return onLoading?.call(context) ?? const SizedBox.shrink();
        }

        switch (command.result) {
          case Ok<T>():
            return onSuccess(context, command.value);

          case Error(appException: final error):
            return onError?.call(context, error) ??
                Center(child: Text(error.toString()));

          case null:
            return onEmpty?.call(context) ?? const SizedBox.shrink();
        }
      },
    );
  }
}
