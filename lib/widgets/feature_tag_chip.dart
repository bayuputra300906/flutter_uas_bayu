import 'package:flutter/material.dart';

import '../utils/constants.dart';

class FeatureTagChip extends StatelessWidget {
  const FeatureTagChip({
    super.key,
    required this.tag,
    this.icon,
  });

  final String tag;
  final IconData? icon;

  IconData _getIconForTag(String t) {
    if (icon != null) return icon!;
    final lower = t.toLowerCase();
    if (lower.contains('24/7') || lower.contains('jam') || lower.contains('access')) {
      return Icons.access_time_rounded;
    } else if (lower.contains('view') || lower.contains('scenic') || lower.contains('sunset') || lower.contains('sunrise')) {
      return Icons.visibility_rounded;
    } else if (lower.contains('island') || lower.contains('friendly') || lower.contains('spot')) {
      return Icons.verified_rounded;
    } else if (lower.contains('eco') || lower.contains('alam') || lower.contains('hutan')) {
      return Icons.eco_rounded;
    } else if (lower.contains('trekking') || lower.contains('gunung')) {
      return Icons.hiking_rounded;
    } else if (lower.contains('budaya') || lower.contains('seni')) {
      return Icons.temple_buddhist_rounded;
    }
    return Icons.check_circle_outline_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: kPrimaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: kPrimaryColor.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getIconForTag(tag),
            size: 14,
            color: kPrimaryColor,
          ),
          const SizedBox(width: 5),
          Text(
            tag,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: kDarkColor,
            ),
          ),
        ],
      ),
    );
  }
}
