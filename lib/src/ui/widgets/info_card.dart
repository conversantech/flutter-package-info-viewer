import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final Color? backgroundColor;
  final Color? titleColor;

  const InfoCard({
    super.key,
    required this.title,
    required this.children,
    this.backgroundColor,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      color: backgroundColor ?? Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: titleColor ?? Theme.of(context).primaryColor,
              ),
            ),
            const Divider(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? labelColor;
  final Color? valueColor;
  final VoidCallback? onTap;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.labelColor,
    this.valueColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: labelColor ?? Colors.grey[600],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                value,
                style: TextStyle(
                  color: valueColor ?? Colors.black87,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
