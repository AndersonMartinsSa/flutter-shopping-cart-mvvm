import 'package:flutter_shopping_cart_mvvm/domain/exceptions/app_exception.dart';

sealed class Result<T> {
  const Result();

  const factory Result.ok(T value) = Ok._;

  const factory Result.error(AppException value) = Error._;
}

final class Ok<T> extends Result<T> {
  final T value;

  const Ok._(this.value);
}

final class Error<T> extends Result<T> {
  final AppException appException;

  const Error._(this.appException);
}
