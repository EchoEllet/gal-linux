import 'package:flutter/foundation.dart';
// ignore: implementation_imports
import 'package:gal/src/gal_platform_interface.dart';

import 'gal_linux_impl.dart';

final class GalPluginLinux extends GalPlatform {
  static void registerWith() {
    assert(
      defaultTargetPlatform == TargetPlatform.linux && !kIsWeb,
      '$GalPluginLinux should be only used for Linux.',
    );
    GalPlatform.instance = GalPluginLinux();
  }

  @override
  Future<bool> hasAccess({bool toAlbum = false}) =>
      GalLinuxImpl.hasAccess(toAlbum: toAlbum);

  @override
  Future<void> open() => GalLinuxImpl.open();

  @override
  Future<void> putImage(String path, {String? album}) =>
      GalLinuxImpl.putImage(path, album: album);

  @override
  Future<void> putImageBytes(Uint8List bytes,
          {required String name, String? album}) =>
      GalLinuxImpl.putImageBytes(bytes, album: album, name: name);

  @override
  Future<void> putVideo(String path, {String? album}) =>
      GalLinuxImpl.putVideo(path, album: album);

  @override
  Future<bool> requestAccess({bool toAlbum = false}) =>
      GalLinuxImpl.requestAccess(toAlbum: toAlbum);
}
