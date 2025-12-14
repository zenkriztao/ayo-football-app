import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ayo_football_app/features/splash/presentation/pages/splash_page.dart';
import 'package:ayo_football_app/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:ayo_football_app/features/auth/presentation/pages/LoginPage.dart';
import 'package:ayo_football_app/features/auth/presentation/pages/RegisterPage.dart';
import 'package:ayo_football_app/features/home/presentation/pages/home_page.dart';
import 'package:ayo_football_app/features/team/presentation/pages/TeamListPage.dart';
import 'package:ayo_football_app/features/team/presentation/pages/TeamDetailPage.dart';
import 'package:ayo_football_app/features/team/presentation/pages/TeamFormPage.dart';
import 'package:ayo_football_app/features/player/presentation/pages/PlayerListPage.dart';
import 'package:ayo_football_app/features/player/presentation/pages/PlayerDetailPage.dart';
import 'package:ayo_football_app/features/player/presentation/pages/PlayerFormPage.dart';
import 'package:ayo_football_app/features/match/presentation/pages/MatchListPage.dart';
import 'package:ayo_football_app/features/match/presentation/pages/MatchDetailPage.dart';
import 'package:ayo_football_app/features/match/presentation/pages/MatchFormPage.dart';
import 'package:ayo_football_app/features/report/presentation/pages/ReportPage.dart';
import 'package:ayo_football_app/core/widgets/MainScaffold.dart';

/// Provider for GoRouter
/// Using Riverpod for dependency injection
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: GlobalKey<NavigatorState>(),
    initialLocation: '/', // Start from splash
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashPage(),
      ),

      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),

      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),

      ShellRoute(
        navigatorKey: GlobalKey<NavigatorState>(),
        builder: (context, state, child) => MainScaffold(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomePage(),
          ),

          GoRoute(
            path: '/teams',
            builder: (context, state) => const TeamListPage(),
            routes: [
              GoRoute(
                path: 'create',
                builder: (context, state) => const TeamFormPage(),
              ),
              GoRoute(
                path: ':id',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return TeamDetailPage(teamId: id);
                },
                routes: [
                  GoRoute(
                    path: 'edit',
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return TeamFormPage(teamId: id);
                    },
                  ),
                ],
              ),
            ],
          ),

          GoRoute(
            path: '/players',
            builder: (context, state) => const PlayerListPage(),
            routes: [
              GoRoute(
                path: 'create',
                builder: (context, state) {
                  final teamId = state.uri.queryParameters['team_id'];
                  return PlayerFormPage(teamId: teamId);
                },
              ),
              GoRoute(
                path: ':id',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return PlayerDetailPage(playerId: id);
                },
                routes: [
                  GoRoute(
                    path: 'edit',
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return PlayerFormPage(playerId: id);
                    },
                  ),
                ],
              ),
            ],
          ),

          GoRoute(
            path: '/matches',
            builder: (context, state) => const MatchListPage(),
            routes: [
              GoRoute(
                path: 'create',
                builder: (context, state) => const MatchFormPage(),
              ),
              GoRoute(
                path: ':id',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return MatchDetailPage(matchId: id);
                },
                routes: [
                  GoRoute(
                    path: 'edit',
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return MatchFormPage(matchId: id);
                    },
                  ),
                ],
              ),
            ],
          ),

          GoRoute(
            path: '/reports',
            builder: (context, state) => const ReportPage(),
          ),
        ],
      ),
    ],
  );
});
