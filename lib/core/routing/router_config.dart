import 'package:chess/core/routing/routes_paths.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter routerConfig = GoRouter(
  debugLogDiagnostics: true,
  navigatorKey: rootNavigatorKey,
  initialLocation: RoutesPaths.splash,
  routes: [
    // GoRoute(path: RoutesPaths.splash,
    // builder:
    // ),
  ],
);
