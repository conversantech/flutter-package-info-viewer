## 1.1.6

* Updated `README.md` with contribution guidelines and project metadata.

## 1.1.5

* Updated `LICENSE` file.

## 1.1.4

* Updated `README.md` with contribution guidelines and project metadata.
* Updated `LICENSE` with attribution requirements.

## 1.1.3

* Expanded Flutter support to `>=3.24.0`.
* Updated SDK constraints to `sdk: ">=3.5.0 <4.0.0"`.
* Updated dependency ranges for `package_info_plus`, `device_info_plus`, `share_plus` (now supports 7.2.2+), `battery_plus`, and `network_info_plus` (now supports 4.0.1+) to support a wider range of Flutter environments.
* Removed unused dependencies: `intl`, `cupertino_icons`, and `path_provider`.
* Improved compatibility for sharing functionality across different plugin versions.

## 1.1.2

* Updated dependencies to their latest versions:
    * `package_info_plus` to `^10.1.0`
    * `device_info_plus` to `^13.1.0`
    * `share_plus` to `^13.1.0`
    * `network_info_plus` to `^8.1.0`

## 1.1.1

* Updated repository and issue tracker URLs in `pubspec.yaml`.
* Minor metadata improvements for package publication.

## 1.1.0

* **Breaking Change**: Renamed `PackageInfo` widget/screen to `PackageInfoViewer` to avoid naming conflicts with the `package_info_plus` package.
* Updated documentation and example app to reflect the new class name.

## 1.0.1

* Updated license information.

## 1.0.0

* Initial release of Flutter Package Info Viewer.
* Features:
    * App Info (Name, Version, Build Number, Package ID).
    * Device Info (Model, OS, Battery, IP).
    * Build Metadata (Git Commit, Branch, Author, Date).
    * Config/Environment Viewer with sensitive data masking.
    * Dependency list viewer.
    * Fully customizable theme.
    * Share/Copy as JSON functionality.
    * Integrated Debug Button.
