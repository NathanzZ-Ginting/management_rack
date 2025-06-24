import 'package:flutter/material.dart';

class Breadcrumb extends StatelessWidget {
  final List<String> items;

  const Breadcrumb({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: items.map((item) {
        final isLast = item == items.last;
        return Row(
          children: [
            Text(
              item,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isLast ? FontWeight.w600 : FontWeight.normal,
                color: isLast ? Colors.white : Colors.white70,
              ),
            ),
            if (!isLast)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: Icon(Icons.chevron_right, size: 16, color: Colors.white70),
              ),
          ],
        );
      }).toList(),
    );
  }
}