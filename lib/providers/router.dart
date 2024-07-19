import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:restox/screens/cart.dart';
import 'package:restox/screens/error.dart';
import 'package:restox/screens/home.dart';
import 'package:restox/screens/order_confirmation.dart';
import 'package:restox/screens/orders.dart';
import 'package:restox/screens/profile.dart';
import 'package:restox/screens/restaurant.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final router = AsyncRouterNotifier(ref);

  return GoRouter(
    initialLocation: '/home',
    debugLogDiagnostics: true,
    refreshListenable: router,
    routes: router._routes,
    errorBuilder: (context, _) => const Error(),
  );
});

class AsyncRouterNotifier extends ChangeNotifier {
  final Ref _ref;

  AsyncRouterNotifier(this._ref);

  List<ShellRoute> get _routes => [
    ShellRoute(
      builder: (context, state, child) {
        return child;
      },
      routes: [
        GoRoute(
          name: 'home',
          path: '/home',
          builder: (context, _) => const Home(),
        ),
        GoRoute(
          name: 'profile',
          path: '/profile',
          builder: (context, _) => const Profile(),
        ),
        GoRoute(
          name: 'restaurant',
          path: '/restaurant/:restaurant_id',
          builder: (context, state) => RestaurantPage(restaurantId: state.pathParameters['restaurant_id']!)
        ),
        GoRoute(
          name: 'cart',
          path: '/restaurant/:restaurant_id/cart',
          builder: (context, state) => CartPage(restaurantId: state.pathParameters['restaurant_id']!)
        ),
        GoRoute(
          name: 'order_conf',
          path: '/restaurant/:restaurant_id/order_conf',
          builder: (context, state) => OrderConfirmation(restaurantId: state.pathParameters['restaurant_id']!)
        ),
        GoRoute(
          name: 'orders',
          path: '/orders',
          builder: (context, state) => const Orders(),
        )
      ],
    ),
  ];
}
