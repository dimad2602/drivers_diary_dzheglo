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
    131500723,
    3861797945,
    889139965,
    3499986685,
    2303569011,
    263121593,
    3164816517,
    2572112573,
    4273608075,
    3404460487,
    187375971,
  ];

  static const List<int> _envieddataapiKey = <int>[
    131500759,
    3861797980,
    889139851,
    3499986640,
    2303568914,
    263121609,
    3164816620,
    2572112528,
    4273608160,
    3404460450,
    187375898,
  ];

  static final String apiKey = String.fromCharCodes(
    List<int>.generate(
      _envieddataapiKey.length,
      (int i) => i,
      growable: false,
    ).map((int i) => _envieddataapiKey[i] ^ _enviedkeyapiKey[i]),
  );
}
