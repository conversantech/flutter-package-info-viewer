import 'package:flutter/material.dart';

/// A handy button widget to trigger the display of [PackageInfoViewer].
///
/// It can be rendered as either a [FloatingActionButton] or a standard [ElevatedButton].
class DebugButton extends StatelessWidget {
  /// Whether the button is visible. Useful for showing only in debug mode.
  final bool visible;

  /// Callback function when the button is pressed.
  final VoidCallback onPress;

  /// Custom color for the button background.
  final Color? color;

  /// Custom icon for the button. Defaults to [Icons.bug_report].
  final Widget? icon;

  /// Custom label text (only used if [floating] is false).
  final String? label;

  /// Whether to render as a [FloatingActionButton] or an [ElevatedButton].
  final bool floating;

  const DebugButton({
    super.key,
    this.visible = true,
    required this.onPress,
    this.color,
    this.icon,
    this.label,
    this.floating = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();

    if (floating) {
      return FloatingActionButton(
        onPressed: onPress,
        backgroundColor: color ?? Theme.of(context).primaryColor,
        child: icon ?? const Icon(Icons.bug_report, color: Colors.white),
      );
    }

    return ElevatedButton.icon(
      onPressed: onPress,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      icon: icon ?? const Icon(Icons.bug_report),
      label: Text(label ?? 'Debug Info'),
    );
  }
}
