import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:novel_reader/pages/home_page.dart';
import 'package:novel_reader/pages/test_page.dart';
import 'package:novel_reader/provider.dart';
import 'package:novel_reader/requests.dart';
import 'consttants.dart';
import 'widgets/cards.dart';

void main() async {
  runApp(const ProviderScope(child: App()));
}

class App extends ConsumerWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GoRouter _router = GoRouter(
        initialLocation: "/home",
        debugLogDiagnostics: true,
        routes: <GoRoute>[
          GoRoute(
              path: '/test',
              builder: (BuildContext context, GoRouterState state) {
                return TestPage(novel: getTestNovelInfo());
              }),
          GoRoute(
              path: '/home',
              builder: (BuildContext context, GoRouterState state) {
                return const HomePage();
              })
        ],
        redirect: (state) {});

    return MaterialApp.router(
        debugShowMaterialGrid: false,
        routeInformationParser: _router.routeInformationParser,
        routerDelegate: _router.routerDelegate,
        title: "EbookReader",
        theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            textTheme: Theme.of(context).textTheme.apply(
                  displayColor: kBlackColor,
                )));
  }
}
