import 'package:flutter/material.dart';

class StatusIcon extends StatelessWidget {
  const StatusIcon({super.key, required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: (isActive ? Colors.green : Colors.grey).withValues(alpha: 0.15),
      ),
      child: Icon(
        isActive ? Icons.screenshot_monitor : Icons.screenshot_outlined,
        size: 56,
        color: isActive ? Colors.greenAccent : Colors.grey,
      ),
    );
  }
}