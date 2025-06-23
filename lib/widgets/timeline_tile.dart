import 'package:flutter/material.dart';

class TimelineTile extends StatelessWidget {
  final String title;
  final String description;
  final String time;
  final VoidCallback? onTap;

  const TimelineTile({
    super.key,
    required this.title,
    required this.description,
    required this.time,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.grey[300] : Colors.grey[900];
    final descColor = isDark ? Colors.grey[400] : Colors.grey[700];
    final borderColor = isDark ? Colors.grey[700] : Colors.grey[300];
    final dotColor = isDark ? Colors.grey[600] : Colors.grey[200];

    return Stack(
      children: [
        // Timeline line
        Positioned(
          left: 14,
          top: 0,
          bottom: 0,
          child: Container(
            width: 2,
            color: borderColor,
          ),
        ),
        // Dot
        Positioned(
          left: 9,
          top: 12,
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark ? Colors.grey[900]! : Colors.white,
                width: 2,
              ),
            ),
          ),
        ),
        // Content
        Container(
          margin: const EdgeInsets.only(left: 40, bottom: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                time,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
              const SizedBox(height: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: descColor,
                ),
              ),
              if (onTap != null) ...[
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[800] : Colors.white,
                      border: Border.all(color: borderColor!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'Learn more',
                          style: TextStyle(fontSize: 13),
                        ),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_forward_ios, size: 12),
                      ],
                    ),
                  ),
                )
              ]
            ],
          ),
        ),
      ],
    );
  }
}