import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/constants/AppConstants.dart';
import 'core/router/AppRouter.dart';
import 'core/theme/AppTheme.dart';
import 'features/auth/presentation/providers/AuthProvider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppTheme.primaryColor,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );

  runApp(
    const ProviderScope(
      child: AyoFootballApp(),
    ),
  );
}

class AyoFootballApp extends ConsumerStatefulWidget {
  const AyoFootballApp({super.key});

  @override
  ConsumerState<AyoFootballApp> createState() => _AyoFootballAppState();
}

class _AyoFootballAppState extends ConsumerState<AyoFootballApp> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(authProvider.notifier).checkAuthStatus());
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
