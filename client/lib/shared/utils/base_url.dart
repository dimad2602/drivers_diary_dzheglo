/// Адрес эмулятора Android, по которому ему виден компьютер, где запущен backend.
const String androidEmulatorHost = '10.0.2.2';

const _loopbackHosts = {'127.0.0.1', 'localhost'};

/// Адрес backend с учётом платформы.
///
/// Эмулятор Android — отдельная сеть: `127.0.0.1` внутри него это сам эмулятор,
/// а компьютер доступен по `10.0.2.2`. Поэтому на Android loopback-адрес из `.env`
/// заменяется автоматически. Любой другой адрес (IP компьютера в сети, домен)
/// остаётся как есть, так что реальное устройство настраивается явной записью в `.env`.
String resolveBaseUrl(String configured, {required bool isAndroid}) {
  if (!isAndroid) return configured;
  final uri = Uri.tryParse(configured);
  if (uri == null || !_loopbackHosts.contains(uri.host)) return configured;
  return uri.replace(host: androidEmulatorHost).toString();
}
