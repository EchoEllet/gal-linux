# 🖼️ Gal Linux

An unofficial Linux implementation of [`gal`](https://pub.dev/packages/gal).

## ⚙️ Usage

This package is non-endorsed federated plugin, which means to use it, you need to add it in `pubspec.yaml`
as a dependency in addition to `gal`:

```yaml
gal: ^latest-version-here
gal_linux: ^latest-version-here
```

## 📉 Note on breaking changes

Currently, the interface `GalPlatform` is not exposed as part of the public API of `gal`, which means
any internal changes such as adding a new property in `gal` will be a breaking change for `gal_linux` users.

## Features

The support for opening the image gallery, requesting permission, and checking
if the app has access to the gallery is limited on **Linux** as Linux
is not opinionated platform that's unified similar to the other platforms.

## Usage

The following command executables are required to use this plugin:

1. `mkdir`
2. `mv`
3. `rm`
4. `xdg-open`
5. `wget`

All of them are avaliable and pre-installed in most Linux distros, in some distors
you might need to install `wget` manually:

```shell
sudo apt install wget
```