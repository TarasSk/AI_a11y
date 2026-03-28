import 'package:ai_a11y/app/route/routes/overlay_route_widget.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => OverlayRouteWidget(state: state),
    ),
  ],
);

