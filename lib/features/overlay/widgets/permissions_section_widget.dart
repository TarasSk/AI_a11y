import 'package:flutter/material.dart';

import 'package:ai_a11y/features/overlay/widgets/permission_indicator_widget.dart';

class PermissionsSectionWidget extends StatelessWidget {
  const PermissionsSectionWidget({
    super.key,
    required this.permissions,
  });

  final List<({String label, bool granted})> permissions;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < permissions.length; i++) ...[
          if (i > 0) const SizedBox(height: 8),
          PermissionIndicator(
            label: permissions[i].label,
            granted: permissions[i].granted,
          ),
        ],
      ],
    );
  }
}

