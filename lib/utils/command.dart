import 'package:flutter/material.dart';

import 'result.dart';

typedef CommandAction0<T> = Future<Result<T>> Function();
typedef CommandAction1<T, A> = Future<Result<T>> Function(A);

abstract class Command<T> extends ChangeNotifier {
  Command();

  bool _running = false;

  bool get isRunning => _running;

  Result<T>? _result;

  bool get error => _result is Error;

  bool get completed => _result is Ok;

  Result<T>? get result => _result;

  T? get value => _result is Ok<T> ? (_result as Ok<T>).value : null;

  void cleanResult() {
    _result = null;
    notifyListeners();
  }

  Future<void> _execute(CommandAction0<T> action) async {
    if (_running) {
      return;
    }

    _running = true;
    _result = null;
    notifyListeners();

    try {
      _result = await action();
    } finally {
      _running = false;
      notifyListeners();
    }
  }

  Future<void> execute();
}

final class Command0<T> extends Command<T> {
  Command0(this._action);

  final CommandAction0<T> _action;

  @override
  Future<void> execute() async {
    await _execute(_action);
  }
}
