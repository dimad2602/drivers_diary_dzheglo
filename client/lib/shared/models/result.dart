/// Результат операции: либо данные, либо типизированная ошибка (без исключений).
sealed class Result<T, E extends Object> {
  const Result();
}

final class Success<T, E extends Object> extends Result<T, E> {
  const Success(this.data);

  final T data;
}

final class Failure<T, E extends Object> extends Result<T, E> {
  const Failure(this.error);

  final E error;
}
