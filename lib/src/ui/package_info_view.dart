import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../services/package_info_service.dart';
import '../models/build_info.dart';
import 'widgets/info_card.dart';

/// A comprehensive widget that displays application, device, build, and configuration information.
///
/// It provides sections for:
/// - **App Info**: Version, build number, package name.
/// - **Device Info**: Model, OS version, battery level, IP address.
/// - **Build Metadata**: Git commit, branch, author, and date.
/// - **Config**: Dynamic environment variables with masking for sensitive keys.
/// - **Dependencies**: List of packages from pubspec.
class PackageInfoViewer extends StatefulWidget {
  /// Optional map of dependencies, usually parsed from `pubspec.yaml`.
  final Map<String, dynamic>? pubspec;

  /// Build information containing Git metadata and dependency versions.
  /// Typically loaded from a generated `assets/build-info.json` file.
  final BuildInfo? buildInfo;

  /// A map of configuration or environment values to display.
  final Map<String, String>? configValues;

  /// The name of the current environment (e.g., 'PRODUCTION', 'STAGING').
  final String environmentName;

  /// The primary color used for headers and buttons. Defaults to theme's primary color.
  final Color? primaryColor;

  /// The background color of the screen. Defaults to scaffold background color.
  final Color? backgroundColor;

  /// The background color for info cards. Defaults to theme's card color.
  final Color? cardBackgroundColor;

  /// The main text color.
  final Color? textColor;

  /// The secondary or label text color.
  final Color? secondaryTextColor;

  const PackageInfoViewer({
    super.key,
    this.pubspec,
    this.buildInfo,
    this.configValues,
    this.environmentName = 'UNKNOWN',
    this.primaryColor,
    this.backgroundColor,
    this.cardBackgroundColor,
    this.textColor,
    this.secondaryTextColor,
  });

  @override
  State<PackageInfoViewer> createState() => _PackageInfoViewerState();
}

class _PackageInfoViewerState extends State<PackageInfoViewer> {
  AppPackageInfo? _appInfo;
  DeviceInfoData? _deviceInfo;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final appInfo = await PackageInfoService.getAppInfo();
      final deviceInfo = await PackageInfoService.getDeviceInfo();
      setState(() {
        _appInfo = appInfo;
        _deviceInfo = deviceInfo;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading info: $e')),
        );
      }
    }
  }

  void _copyToClipboard(String label, String value) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label copied to clipboard')),
    );
  }

  void _shareAllInfo() {
    final jsonString = _generateJsonData();
    SharePlus.instance.share(
      ShareParams(
        text: jsonString,
        subject: 'App Debug Info',
      ),
    );
  }

  String _generateJsonData() {
    final Map<String, dynamic> data = {
      'app': {
        'name': _appInfo?.appName,
        'version': _appInfo?.version,
        'buildNumber': _appInfo?.buildNumber,
        'packageName': _appInfo?.packageName,
        'dependencies':
            widget.buildInfo?.dependencies ?? widget.pubspec?['dependencies'],
        'devDependencies': widget.buildInfo?.devDependencies ??
            widget.pubspec?['dev_dependencies'],
      },
      'build': {
        'commitHash': widget.buildInfo?.commitHash,
        'commitAuthor': widget.buildInfo?.author,
        'commitBranch': widget.buildInfo?.branch,
        'buildDate': widget.buildInfo?.buildDate,
      },
      'device': {
        'model': _deviceInfo?.model,
        'os': _deviceInfo?.osVersion,
        'battery': _deviceInfo?.batteryLevel,
        'ip': _deviceInfo?.ipAddress,
      },
      'config': widget.configValues ?? {},
      'env': widget.environmentName,
    };

    return const JsonEncoder.withIndent('  ').convert(data);
  }

  void _copyAllInfoToJson() {
    final jsonString = _generateJsonData();
    Clipboard.setData(ClipboardData(text: jsonString));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All info copied to clipboard as JSON')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = widget.primaryColor ?? theme.primaryColor;
    final bg = widget.backgroundColor ?? theme.scaffoldBackgroundColor;
    final cardBg = widget.cardBackgroundColor ?? theme.cardColor;
    final text =
        widget.textColor ?? theme.textTheme.bodyLarge?.color ?? Colors.black;
    final secText = widget.secondaryTextColor ?? Colors.grey[600]!;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text('Package Info'),
        backgroundColor: primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareAllInfo,
          ),
          IconButton(
            icon: const Icon(Icons.copy_all),
            onPressed: _copyAllInfoToJson,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                children: [
                  _buildAppInfoSection(primary, cardBg, text, secText),
                  _buildDeviceInfoSection(primary, cardBg, text, secText),
                  if (widget.buildInfo != null)
                    _buildBuildInfoSection(primary, cardBg, text, secText),
                  if (widget.configValues != null &&
                      widget.configValues!.isNotEmpty)
                    _buildConfigSection(primary, cardBg, text, secText),
                  if ((widget.pubspec != null &&
                          widget.pubspec!['dependencies'] != null) ||
                      (widget.buildInfo?.dependencies != null))
                    _buildDependenciesSection(primary, cardBg, text, secText),
                ],
              ),
            ),
    );
  }

  Widget _buildAppInfoSection(
      Color primary, Color cardBg, Color text, Color secText) {
    return InfoCard(
      title: '📦 App Info',
      titleColor: primary,
      backgroundColor: cardBg,
      children: [
        InfoRow(
          label: 'Name',
          value: _appInfo?.appName ?? 'N/A',
          valueColor: text,
          labelColor: secText,
          onTap: () => _copyToClipboard('App Name', _appInfo?.appName ?? ''),
        ),
        InfoRow(
          label: 'Version',
          value: _appInfo?.version ?? 'N/A',
          valueColor: text,
          labelColor: secText,
          onTap: () => _copyToClipboard('Version', _appInfo?.version ?? ''),
        ),
        InfoRow(
          label: 'Build Number',
          value: _appInfo?.buildNumber ?? 'N/A',
          valueColor: text,
          labelColor: secText,
          onTap: () =>
              _copyToClipboard('Build Number', _appInfo?.buildNumber ?? ''),
        ),
        InfoRow(
          label: 'Package ID',
          value: _appInfo?.packageName ?? 'N/A',
          valueColor: text,
          labelColor: secText,
          onTap: () =>
              _copyToClipboard('Package ID', _appInfo?.packageName ?? ''),
        ),
      ],
    );
  }

  Widget _buildDeviceInfoSection(
      Color primary, Color cardBg, Color text, Color secText) {
    return InfoCard(
      title: '📱 Device Info',
      titleColor: primary,
      backgroundColor: cardBg,
      children: [
        InfoRow(
            label: 'Model',
            value: _deviceInfo?.model ?? 'N/A',
            valueColor: text,
            labelColor: secText),
        InfoRow(
            label: 'OS Version',
            value: _deviceInfo?.osVersion ?? 'N/A',
            valueColor: text,
            labelColor: secText),
        InfoRow(
            label: 'Battery Level',
            value: _deviceInfo?.batteryLevel ?? 'N/A',
            valueColor: text,
            labelColor: secText),
        InfoRow(
            label: 'IP Address',
            value: _deviceInfo?.ipAddress ?? 'N/A',
            valueColor: text,
            labelColor: secText),
      ],
    );
  }

  Widget _buildBuildInfoSection(
      Color primary, Color cardBg, Color text, Color secText) {
    final bi = widget.buildInfo!;
    return InfoCard(
      title: '🏗 Build Metadata',
      titleColor: primary,
      backgroundColor: cardBg,
      children: [
        if (bi.commitHash != null)
          InfoRow(
            label: 'Commit',
            value: bi.commitHash!,
            valueColor: text,
            labelColor: secText,
            onTap: () => _copyToClipboard('Commit Hash', bi.commitHash!),
          ),
        if (bi.branch != null)
          InfoRow(
              label: 'Branch',
              value: bi.branch!,
              valueColor: text,
              labelColor: secText),
        if (bi.author != null)
          InfoRow(
              label: 'Author',
              value: bi.author!,
              valueColor: text,
              labelColor: secText),
        if (bi.buildDate != null)
          InfoRow(
              label: 'Date',
              value: bi.buildDate!,
              valueColor: text,
              labelColor: secText),
      ],
    );
  }

  Widget _buildConfigSection(
      Color primary, Color cardBg, Color text, Color secText) {
    return InfoCard(
      title: '🔧 Config (${widget.environmentName})',
      titleColor: primary,
      backgroundColor: cardBg,
      children: widget.configValues!.entries.map((e) {
        // Simple masking for sensitive keys
        bool isSensitive = e.key.toLowerCase().contains('key') ||
            e.key.toLowerCase().contains('secret') ||
            e.key.toLowerCase().contains('password') ||
            e.key.toLowerCase().contains('token');
        String displayValue = isSensitive ? '********' : e.value;

        return InfoRow(
          label: e.key,
          value: displayValue,
          valueColor: text,
          labelColor: secText,
          onTap: () {
            if (isSensitive) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Sensitive Data'),
                  content: Text('Are you sure you want to copy "${e.key}"?'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel')),
                    TextButton(
                        onPressed: () {
                          _copyToClipboard(e.key, e.value);
                          Navigator.pop(context);
                        },
                        child: const Text('Copy')),
                  ],
                ),
              );
            } else {
              _copyToClipboard(e.key, e.value);
            }
          },
        );
      }).toList(),
    );
  }

  Widget _buildDependenciesSection(
      Color primary, Color cardBg, Color text, Color secText) {
    final deps = widget.buildInfo?.dependencies ??
        widget.pubspec?['dependencies'] as Map?;
    final devDeps = widget.buildInfo?.devDependencies ??
        widget.pubspec?['dev_dependencies'] as Map?;

    if (deps == null && devDeps == null) return const SizedBox.shrink();

    return InfoCard(
      title: '🧩 Dependencies',
      titleColor: primary,
      backgroundColor: cardBg,
      children: [
        if (deps != null)
          ...deps.entries.map((e) => InfoRow(
              label: e.key.toString(),
              value: e.value.toString(),
              valueColor: text,
              labelColor: secText)),
        if (devDeps != null) ...[
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text('Dev Dependencies',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          ...devDeps.entries.map((e) => InfoRow(
              label: e.key.toString(),
              value: e.value.toString(),
              valueColor: text,
              labelColor: secText)),
        ],
      ],
    );
  }
}
