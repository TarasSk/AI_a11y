import 'package:go_router/go_router.dart';
import 'routes/overlay_route_widget.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => OverlayRouteWidget(state: state),
    ),
  ],
);
