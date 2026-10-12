import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:driver_diary/shared/storage/api_key_store.dart';

/// Добавляет в каждый запрос заголовок `X-API-Key`. Ключ читается при каждом вызове,
/// поэтому смена ключа в настройках действует сразу, без пересоздания клиента.
class ApiKeyInterceptor implements Interceptor {
  const ApiKeyInterceptor(this._apiKeyStore);

  static const String headerName = 'X-API-Key';

  final ApiKeyStore _apiKeyStore;

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
    Chain<BodyType> chain,
  ) async {
    final key = await _apiKeyStore.read();
    return chain.proceed(applyHeader(chain.request, headerName, key));
  }
}
