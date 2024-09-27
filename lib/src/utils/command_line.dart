import 'dart:io' show ProcessException, Process;

import 'package:flutter/foundation.dart' show kIsWeb;

Future<String> executeCommand({
  required String executable,
  required List<String> args,
  String? workingDirectory,
}) async {
  assert(!kIsWeb, 'executeCommand() is not supported on the web.');
  final command = await Process.run(
    executable,
    args,
    workingDirectory: workingDirectory,
  );
  if (command.exitCode != 0) {
    throw ProcessException(
      executable,
      args,
      command.stderr,
      command.exitCode,
    );
  }

  return command.stdout;
}
