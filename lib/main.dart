import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme/app_theme.dart';
import 'routes/app_router.dart';

void main() {
  runApp(const ProviderScope(child: MySmartClosetApp()));
}

class MySmartClosetApp extends ConsumerWidget {
  const MySmartClosetApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(appRouterProvider);
    return MaterialApp.router(
      title: 'My Smart Closet',
      theme: appTheme,
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
