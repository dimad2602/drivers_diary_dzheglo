// Перегенерирует API-клиент из swaggers/driver_diary.json.
//
// Запуск из client/:  dart run tool/generate_api.dart
//
// Схему читает сам swagger_dart_code_generator, а не build_runner, поэтому после её
// изменения build_runner считает вход неизменным и ничего не пересоздаёт. Удаляем
// выходную папку, чтобы генерация гарантированно прошла заново.
import 'dart:io';

Future<void> main() async {
  final output = Directory('lib/swagger_generated_code');
  if (output.existsSync()) output.deleteSync(recursive: true);

  final process = await Process.start(Platform.resolvedExecutable, [
    'run',
    'build_runner',
    'build',
    '--delete-conflicting-outputs',
  ], mode: ProcessStartMode.inheritStdio);
  exit(await process.exitCode);
}
