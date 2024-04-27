import 'dart:io' show Directory, File, Platform, ProcessException;

import 'package:flutter/foundation.dart' show Uint8List, immutable;
import 'package:flutter/services.dart' show PlatformException;
import 'package:gal/gal.dart';
import 'package:path/path.dart' as path show basename;

import '../src/utils/uri_extension.dart';
import 'utils/command_line.dart';

enum _FileType {
  image,
  video,
}

/// Impl for Linux platform
///
/// The support for Linux is limitied
///
/// it's not 100% spesefic to Linux, it could work for Unix based OS
@immutable
final class GalLinuxImpl {
  const GalLinuxImpl._();

  static Future<void> putVideo(String path, {String? album}) async {
    await _downloadFileToAlbum(
      path,
      fileType: _FileType.video,
      album: album,
    );
  }

  static Future<void> putImage(String path, {String? album}) async {
    await _downloadFileToAlbum(
      path,
      fileType: _FileType.image,
      album: album,
    );
  }

  static Future<void> _downloadFileToAlbum(
    String filePath, {
    required _FileType fileType,
    String? album,
  }) async {
    try {
      final file = File(filePath);
      var downloadedFromNetwork = false;

      // Download from network
      if (!(await file.exists())) {
        final uri = Uri.parse(filePath);

        // If it doesn't exists and it also doesn't starts with https
        if (!uri.isHttpBasedUrl()) {
          throw GalException(
              type: GalExceptionType.unexpected,
              platformException: PlatformException(
                code: GalExceptionType.unexpected.code,
                message:
                    'You are trying to put file with path `$filePath` that does not exists '
                    'locally, Also it does not start with `http` nor `https`',
                stacktrace: StackTrace.current.toString(),
              ),
              stackTrace: StackTrace.current);
        }

        // Save it to a temp directory for now
        final templLocation =
            _getNewTempFileLocation(fileName: path.basename(filePath));
        await executeCommand(
          executalbe: 'wget',
          args: ['-O', templLocation, filePath],
        );
        filePath = templLocation;
        downloadedFromNetwork = true;
      }

      // Save it to the album
      if (album != null) {
        final newFileLocation = _getNewFileLocationWithAlbum(
          fileType: fileType,
          album: album,
          fileName: path.basename(filePath),
        );
        await _makeSureParentFolderExists(path: newFileLocation);
        await executeCommand(
          executalbe: 'mv',
          args: [filePath, newFileLocation],
        );
      } else {
        // Save it in temp directory
        final newFileLocation =
            _getNewTempFileLocation(fileName: path.basename(filePath));
        await _makeSureParentFolderExists(path: newFileLocation);
        executeCommand(
          executalbe: 'mv',
          args: [filePath, newFileLocation],
        );
      }
      // Remove the downloaded temp file from the network if it exists
      if (downloadedFromNetwork) {
        await executeCommand(
          executalbe: 'rm',
          args: [filePath],
        );
      }
    } on ProcessException catch (e) {
      throw GalException(
        type: GalExceptionType.unexpected,
        platformException: PlatformException(
          code: e.errorCode.toString(),
          message: e.toString(),
          details: e.message.toString(),
          stacktrace: StackTrace.current.toString(),
        ),
        stackTrace: StackTrace.current,
      );
    } catch (e) {
      throw GalException(
        type: GalExceptionType.unexpected,
        platformException: PlatformException(
          code: e.toString(),
          message: e.toString(),
          details: e.toString(),
          stacktrace: StackTrace.current.toString(),
        ),
        stackTrace: StackTrace.current,
      );
    }
  }

  static String _getHomeDirectory() =>
      Platform.environment['HOME'] ??
      (throw GalException(
        type: GalExceptionType.unexpected,
        platformException: PlatformException(
          code: GalExceptionType.unexpected.code,
          message: 'The HOME environment variable is null and it is required',
        ),
        stackTrace: StackTrace.current,
      ));

  static String _getNewFileLocationWithAlbum({
    required _FileType fileType,
    required String album,
    required String fileName,
  }) {
    final currentDate = DateTime.now().toIso8601String();
    final newFileLocation = switch (fileType) {
      _FileType.image =>
        '${_getHomeDirectory()}/Pictures/$album/$currentDate-$fileName',
      _FileType.video =>
        '${_getHomeDirectory()}/Videos/$album/$currentDate-$fileName',
    };
    return newFileLocation;
  }

  static String _getNewTempFileLocation({
    required String fileName,
  }) {
    final currentDate = DateTime.now().toIso8601String();
    return '${Directory.systemTemp.path}/gal/$currentDate-$fileName';
  }

  static Future<void> _makeSureParentFolderExists(
      {required String path}) async {
    await executeCommand(
      executalbe: 'mkdir',
      args: ['-p', File(path).parent.path],
    );
  }

  static Future<void> putImageBytes(Uint8List bytes,
      {required String name, String? album}) async {
    try {
      final fileName = '$name.png';
      final newFileLocation = album == null
          ? _getNewTempFileLocation(fileName: fileName)
          : _getNewFileLocationWithAlbum(
              fileType: _FileType.image,
              album: album,
              fileName: fileName,
            );
      final file = File(newFileLocation);
      await file.writeAsBytes(bytes);
    } catch (e) {
      throw GalException(
        type: GalExceptionType.unexpected,
        platformException: PlatformException(
          code: e.toString(),
          details: e.toString(),
          message: e.toString(),
          stacktrace: StackTrace.current.toString(),
        ),
        stackTrace: StackTrace.current,
      );
    }
  }

  static Future<void> open() async => executeCommand(
        executalbe: 'xdg-open',
        args: ['${_getHomeDirectory()}/Pictures'],
      );

  /// Requesting an access usually automated if there is a sandbox
  /// but we don't have much info and usually we have an access
  static Future<bool> hasAccess({bool toAlbum = false}) async => true;

  /// Requesting an access usually automated once we try
  /// to save an image if there was a sandbox
  /// but we don't have much info and usually we have an access
  static Future<bool> requestAccess({bool toAlbum = false}) async => true;
}
