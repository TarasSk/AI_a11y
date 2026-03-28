import 'package:ai_a11y/presentation/features/overlay/page/overlay_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OverlayRouteWidget extends StatelessWidget {
  const OverlayRouteWidget({super.key, required this.state});

  final GoRouterState state;

  @override
  Widget build(BuildContext context) {
    return const OverlayPage();
  }
}
