import 'package:flutter/material.dart';
import 'package:flutter_bookkeeper/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

import 'new_record.dart';

var logger = Logger();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initProvider();
  runApp(ProviderScope(child: App()));
}

/// The main app.
class App extends ConsumerWidget {
  /// Creates an [App].
  App({Key? key}) : super(key: key);

  static const String title = 'Bookkeeper';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GoRouter _router = GoRouter(
        initialLocation: "/home",
        debugLogDiagnostics: true,
        routes: <GoRoute>[
          GoRoute(
              path: '/home',
              builder: (BuildContext context, GoRouterState state) {
                return Scaffold(
                  appBar: AppBar(),
                  body: NewRecord(),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      ref.refresh(tagsProvider);
                      logger.d("print");
                    },
                    tooltip: "双击进行记账",
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                  //放置位置 中间的缺口处
                  floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
                  bottomNavigationBar: BottomAppBar(
                    color: Colors.lightBlue,
                    //CircularNotchedRectangle 意思是一个带有圆形缺口的矩形
                    shape: CircularNotchedRectangle(),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      //将主轴空白区域均分，使各个子控件间距相等
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.home, color: Colors.white),
                          onPressed: () {
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.settings, color: Colors.white),
                          onPressed: () {
                          },
                        )
                      ],
                    ),
                  ),
                );
              }
            )
        ],
        redirect: (state) {

        });
    return MaterialApp.router(
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class EachView extends StatefulWidget {
  String _title;

  EachView(this._title);

  @override
  _EachViewState createState() => new _EachViewState();
}

class _EachViewState extends State<EachView> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title:Text(widget._title)),
      body: Center(child: Text(widget._title)),
    );
  }
}