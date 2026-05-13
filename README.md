# Flutter Package Info Viewer 🚀

A robust Flutter package to display application version, dependencies, build information (Git commit, branch, author), dynamic configuration values, **and Device Information**. Perfect for debug menus, QA testing, and "About App" screens.

## Features 🚀
- ✅ **App Info (Automatic)**: Displays Version, Build Number, Package ID, and Name.
- ✅ **Device Info (Automatic)**: Shows Model, OS Version, Battery Level, and IP Address.
- 🏗 **Build Metadata (Requires Setup)**: Shows Git Commit Hash, Branch, Author, and Build Date.
- 🔧 **Config Viewer**: Safely displays environment variables or config keys (masks sensitive keys automatically).
- 🧩 **Dependency List (Requires Setup)**: Automatically lists `dependencies` and `dev_dependencies` from your `pubspec.yaml`.
- 🎨 **Fully Customizable**: Change colors to match your app's theme.
- 📤 **Share/Copy**: Share all debug info as a formatted JSON or copy individual values.
- 🐞 **Debug Button**: A handy floating/inline button to trigger the info screen.

---

## Installation 💿

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_package_info_viewer: ^1.0.0
```

Then run:
```bash
flutter pub get
```

---

## Setup (Optional: For Build Metadata) ⚡

By default, the package will automatically display App and Device information. However, to see **Git Commit**, **Build Date**, and **Dependency versions**, you must follow these steps:

1. Create an `assets` folder in your project root if it doesn't exist.
2. Run the generation script from your project root:
```bash
dart run flutter_package_info_viewer:generate_build_info
```
3. Add the generated file to your `pubspec.yaml`:
```yaml
flutter:
  assets:
    - assets/build-info.json
```

---

## Usage 🛠

### 1. The Info Screen (`PackageInfoViewer`)
Since loading assets is asynchronous, it is recommended to use a `FutureBuilder` to load the `build-info.json`.

```dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_package_info_viewer/flutter_package_info_viewer.dart';

// ... inside your widget ...

@override
Widget build(BuildContext context) {
  return FutureBuilder<String>(
    future: rootBundle.loadString('assets/build-info.json'),
    builder: (context, snapshot) {
      BuildInfo? buildInfo;
      if (snapshot.hasData) {
        try {
          buildInfo = BuildInfo.fromJson(json.decode(snapshot.data!));
        } catch (e) {
          debugPrint("Build info error: $e");
        }
      }

      return PackageInfoViewer(
        buildInfo: buildInfo,
        environmentName: 'STAGING',
        configValues: {
          'API_URL': 'https://api.dev.com',
          'STRIPE_KEY': 'sk_test_51Mz...',
        },
        // Theme Customization
        primaryColor: Colors.deepPurple,
        backgroundColor: Colors.white,
      );
    },
  );
}
```

### 2. The Debug Button (`DebugButton`)
A pre-styled button to easily navigate to your Info Screen.

```dart
DebugButton(
  visible: kDebugMode, // Only show in debug mode
  onPress: () => Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const PackageInfoViewer()),
  ),
)
```

---

## Props 📚

### `PackageInfoViewer`

| Prop Name | Type | Default | Description |
|-----------|------|---------|-------------|
| `buildInfo` | `BuildInfo?` | `null` | Contains commit info and dependency list. |
| `pubspec` | `Map?` | `null` | Fallback map for dependencies if buildInfo is not used. |
| `configValues` | `Map<String, String>?` | `{}` | Key-value pairs (Env vars) to display. |
| `environmentName` | `String` | `'UNKNOWN'` | Shows at the top of the Config section. |
| `primaryColor` | `Color?` | `Theme primary` | Color for buttons and headers. |
| `backgroundColor` | `Color?` | `Theme scaffold`| Main screen background color. |
| `cardBackgroundColor`| `Color?` | `Theme card` | Background color for info cards. |
| `textColor` | `Color?` | `Theme body` | Main text color. |
| `secondaryTextColor`| `Color?` | `Grey` | Secondary/Label text color. |

---

License: MIT