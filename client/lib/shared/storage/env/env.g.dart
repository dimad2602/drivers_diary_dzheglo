// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'env.dart';

// **************************************************************************
// EnviedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// generated_from: .env
final class _Env {
  static const String baseUrl = 'http://127.0.0.1:8000';

  static const List<int> _enviedkeyapiKey = <int>[
    1636341361,
    1147672434,
    3648945742,
    3868611826,
    3889734153,
    2543731320,
    3706838895,
    1746492223,
    2332162006,
    3373166601,
    2497249489,
  ];

  static const List<int> _envieddataapiKey = <int>[
    1636341269,
    1147672343,
    3648945720,
    3868611807,
    3889734248,
    2543731208,
    3706838790,
    1746492178,
    2332161981,
    3373166700,
    2497249448,
  ];

  static final String apiKey = String.fromCharCodes(
    List<int>.generate(
      _envieddataapiKey.length,
      (int i) => i,
      growable: false,
    ).map((int i) => _envieddataapiKey[i] ^ _enviedkeyapiKey[i]),
  );
}
