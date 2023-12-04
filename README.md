# Gal Linux

## Table of Contents
- [Gal Linux](#gal-linux)
  - [Table of Contents](#table-of-contents)
  - [About](#about)
  - [Features](#features)
  - [Usage](#usage)

## About

This is just an implementation package of the plugin [gal](https://pub.dev/packages/gal) for Linux

## Features

The support for opening the gallery, requesting permission and check if we have access to the gallery
is limited on Linux

## Usage

The following command executables are required to use this plugin:
1. `mkdir`
2. `mv`
3. `rm`
4. `xdg-open`
5. `wget`

All of them should be already there in most Linux distros, wget might not in some cases so you need
to manually install it using your package manager, example in Debian based distros:

```
sudo apt install wget
```

In most cases it should be already done

Import `defaultTargetPlatform` and `kIsWeb` from library `flutter/foundation`

```dart
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
```

You needs to execute:

```dart
  if (defaultTargetPlatform == TargetPlatform.linux && !kIsWeb) {
    GalPluginLinux.registerWith();
  }
```

Before using any `gal` function