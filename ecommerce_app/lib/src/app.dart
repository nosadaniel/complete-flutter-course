import 'package:ecommerce_app/src/localization/string_hardcoded.dart';
import 'package:ecommerce_app/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ensure URL changes in the address bar when using push /pushNamed
    GoRouter.optionURLReflectsImperativeAPIs = true;
    final goRouter = ref.watch(appRouterProvider);
    return MaterialApp.router(
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
      restorationScopeId: 'app',
      // * The home page of the app
      //home: const ProductsListScreen(),
      onGenerateTitle: (BuildContext context) => 'My Shop'.hardcoded,
      theme: ThemeData(
        // * Use this to toggle Material 3 (defaults to true since Flutter 3.16)
        useMaterial3: true,
        primarySwatch: Colors.grey,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black87,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black, // background (button) color
            foregroundColor: Colors.white, // foreground (text) color
          ),
        ),
      ),
    );
  }
}
