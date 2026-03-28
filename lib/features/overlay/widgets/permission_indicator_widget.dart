import 'package:flutter/material.dart';

class PermissionIndicator extends StatelessWidget {
  const PermissionIndicator({super.key,
    required this.label,
    required this.granted,
  });

  final String label;
  final bool granted;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          granted ? Icons.check_circle : Icons.radio_button_unchecked,
          size: 18,
          color: granted ? Colors.greenAccent : Colors.white38,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: granted ? Colors.white70 : Colors.white38,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

