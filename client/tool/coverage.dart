// Считает покрытие кода тестами без сгенерированных файлов.
//
//   flutter test --coverage
//   dart run tool/coverage.dart [--min=80] [--all]
//
//   --min=N  завершиться с ошибкой, если общее покрытие ниже N%
//   --all    показать все файлы, а не только покрытые не полностью
//
// Важно: flutter test включает в lcov.info только файлы, которые загружают тесты.
// Файлы, которых там нет (например, main.dart), скрипт перечисляет отдельно —
// иначе общий процент выглядел бы лучше, чем есть на самом деле.
import 'dart:io';

/// Сгенерированный код в покрытие не входит.
const _generated = [
  '.g.dart',
  '.freezed.dart',
  'lib/generated/',
  'lib/swagger_generated_code/',
];

class _FileCoverage {
  _FileCoverage(this.path);

  final String path;
  int found = 0;
  int hit = 0;

  double get percent => found == 0 ? 100 : hit * 100 / found;
}

bool _isGenerated(String path) => _generated.any(path.contains);

String _normalize(String path) => path.replaceAll('\\', '/');

List<_FileCoverage> _parseLcov(String content) {
  final files = <_FileCoverage>[];
  _FileCoverage? current;
  for (final line in content.split(RegExp(r'\r?\n'))) {
    if (line.startsWith('SF:')) {
      current = _FileCoverage(_normalize(line.substring(3)));
    } else if (line.startsWith('DA:') && current != null) {
      final parts = line.substring(3).split(',');
      current.found++;
      if (int.parse(parts[1]) > 0) current.hit++;
    } else if (line == 'end_of_record' && current != null) {
      files.add(current);
      current = null;
    }
  }
  return files;
}

void main(List<String> args) {
  final min = args
      .where((a) => a.startsWith('--min='))
      .map((a) => double.parse(a.substring('--min='.length)))
      .firstOrNull;
  final showAll = args.contains('--all');

  final lcov = File('coverage/lcov.info');
  if (!lcov.existsSync()) {
    stderr.writeln('Нет coverage/lcov.info. Сначала: flutter test --coverage');
    exit(2);
  }

  final covered =
      _parseLcov(lcov.readAsStringSync())
          .where((f) => !_isGenerated(f.path))
          .toList()
        ..sort((a, b) => a.percent.compareTo(b.percent));

  final found = covered.fold<int>(0, (sum, f) => sum + f.found);
  final hit = covered.fold<int>(0, (sum, f) => sum + f.hit);
  final total = found == 0 ? 100.0 : hit * 100 / found;

  final listed = showAll ? covered : covered.where((f) => f.percent < 100);
  for (final f in listed) {
    stdout.writeln(
      '${f.percent.toStringAsFixed(1).padLeft(6)}%  ${f.hit}/${f.found}  ${f.path}',
    );
  }

  final known = covered.map((f) => f.path).toSet();
  final untested =
      Directory('lib')
          .listSync(recursive: true)
          .whereType<File>()
          .map((f) => _normalize(f.path))
          .where(
            (p) =>
                p.endsWith('.dart') && !_isGenerated(p) && !known.contains(p),
          )
          .toList()
        ..sort();

  stdout.writeln(
    '\nИтого: ${total.toStringAsFixed(1)}% ($hit из $found строк, '
    '${covered.length} файлов, без сгенерированного кода)',
  );
  if (untested.isNotEmpty) {
    stdout.writeln('\nНе загружаются тестами (в процент не входят):');
    for (final path in untested) {
      stdout.writeln('  $path');
    }
  }

  if (min != null && total < min) {
    stderr.writeln('\nПокрытие ${total.toStringAsFixed(1)}% ниже порога $min%');
    exit(1);
  }
}
