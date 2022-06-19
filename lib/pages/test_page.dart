import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novel_reader/provider.dart';
import 'package:novel_reader/requests.dart';
import 'package:tuple/tuple.dart';

import '../consttants.dart';
import '../entity/record.dart';
import '../widgets/cards.dart';

class TestPage extends ConsumerStatefulWidget {
  const TestPage({Key? key, required this.novel}) : super(key: key);

  final NovelInfo novel;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return TestPageState();
  }
}

class TestPageState extends ConsumerState<TestPage> {
  TestPageState();

  final ScrollController _scrollController = ScrollController();
  int currentChapterId = 0;
  List<ChapterInfo> chapters = [];

  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() async {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent) {
        loadNewChapter();
      }
    });
  }

  void loadNewChapter() async {
    ChapterInfo newChapter = await ref.watch(
        chapterContentProvider(Tuple2(widget.novel.id!, currentChapterId + 1))
            .future);
    setState(() {
      currentChapterId += 1;
      chapters.add(newChapter);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  Widget _build(ChapterInfo chapter) {
    return Column(
      children: [
        Text(chapter.name, style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),),
        SizedBox(height: 30),
        Text(chapter.content!, style: TextStyle(fontSize: 15)),
      ],
    );
    return ListTile(
      title: Text(chapter.name),
      subtitle: Text(chapter.content!),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (chapters.isEmpty) {
      return ref.watch(contentProvider(widget.novel.id!)).when(
          loading: () => const CircularProgressIndicator(),
          error: (err, stack) => Text('Error: $err'),
          data: (result) {
            chapters = [result];
            currentChapterId = result.chapterId;
            return Scaffold(
              appBar: AppBar(
                title: Text(widget.novel.name),
                centerTitle: true,
              ),
              body: RefreshIndicator(
                  onRefresh: () async {
                    print("refresh");
                  },
                  child: Padding(
                      padding: EdgeInsets.all(10),
                      child: ListView.builder(
                          itemCount: chapters.length,
                          controller: _scrollController,
                          itemBuilder: (context, index) {
                            return _build(chapters[index]);
                          }))),
              drawer: ChapterList(novel: widget.novel),
            );
          });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.novel.name),
        centerTitle: true,
      ),
      body: RefreshIndicator(
          onRefresh: () async {
            print("refresh");
          },
          child: Padding(
              padding: EdgeInsets.all(10),
              child: ListView.builder(
                  itemCount: chapters.length,
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    return _build(chapters[index]);
                  }))),
      drawer: ChapterList(novel: widget.novel),
    );
  }
}

class ChapterList extends ConsumerWidget {
  const ChapterList({Key? key, required this.novel}) : super(key: key);

  final NovelInfo novel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<ChapterInfo>> results =
        ref.watch(chaptersProvider(novel.id!));
    return results.when(
        loading: () => const CircularProgressIndicator(),
        error: (err, stack) => Text('Error: $err'),
        data: (results) {
          return Drawer(
            child: ListView(
              children: <Widget>[
                Container(
                  height: 100,
                  child: UserAccountsDrawerHeader(
                    accountEmail: Text(novel.author),
                    accountName: Text(novel.name),
                  ),
                ),
                for (ChapterInfo chapter in results)
                  ListTile(
                    title: Text(chapter.name),
                    onTap: () {
                      print(233);
                    },
                  )
              ],
            ),
          );
        });
  }
}
