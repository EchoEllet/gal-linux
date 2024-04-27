import 'dart:io' show ProcessException, Process;

import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;

Future<String> executeCommand({
  required String executalbe,
  required List<String> args,
  bool printResult = true,
  String? workingDirectory,
}) async {
  if (kDebugMode) {
    if (printResult) {
      print('$executalbe ${args.join(' ')}');
    }
  }
  if (kIsWeb) {
    throw UnsupportedError(
      'The command line is not supported on web',
    );
  }
  final command = await Process.run(
    executalbe,
    args,
    workingDirectory: workingDirectory,
  );
  if (command.exitCode != 0) {
    if (kDebugMode) {
      if (printResult) {
        print(
          'Process exception, ${command.stderr}',
        );
      }
    }
    throw ProcessException(
      executalbe,
      args,
      command.stderr,
      command.exitCode,
    );
  }

  return command.stdout;
}
