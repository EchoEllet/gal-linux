import 'dart:io' show ProcessException, Process;

import 'package:flutter/foundation.dart' show debugPrint, kDebugMode, kIsWeb;

Future<String> executeCommand({
  required String executable,
  required List<String> args,
  bool printResult = true,
  String? workingDirectory,
}) async {
  if (kDebugMode) {
    if (printResult) {
      debugPrint(
        'Running the command: $executable ${args.join(' ')}\n'
        'This message will only appear in development mode and tree-shaken in release build.',
      );
    }
  }
  assert(!kIsWeb, 'executeCommand() is not supported on the web.');
  final command = await Process.run(
    executable,
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
      executable,
      args,
      command.stderr,
      command.exitCode,
    );
  }

  return command.stdout;
}
