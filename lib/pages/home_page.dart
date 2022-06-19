import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:novel_reader/provider.dart';
import 'package:novel_reader/requests.dart';

import '../consttants.dart';
import '../entity/record.dart';
import '../widgets/cards.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var size = MediaQuery.of(context).size;
    AsyncValue<List<NovelInfo>> results = ref.watch(myEbokksProvider);
    return results.when(
        loading: () => const CircularProgressIndicator(),
        error: (err, stack) => Text(
              'Error: $err',
              style: TextStyle(fontSize: 10),
            ),
        data: (List<NovelInfo> data) {
          return Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  ref.watch(dataBaseProvider).whenData((db) async {
                    final novels = await getNovelListApi();
                    final records = await db.recordDao.findAllRecord();
                    Set<int> existIds = {};
                    for (Record record in records) {
                      existIds.add(record.id);
                    }

                    for (NovelInfo novel in novels) {
                      if (!existIds.contains(novel.id)) {
                        await db.recordDao.insertNovel(Record(novel.id!, 0));
                      }
                    }
                  });
                },
                child: const Icon(Icons.refresh),
              ),
              body: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/main_page_bg.png"),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: size.height * .1),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: RichText(
                                text: TextSpan(
                                  style: Theme.of(context).textTheme.headline4,
                                  children: [
                                    TextSpan(text: "What are you \nreading "),
                                    TextSpan(
                                        text: "today?",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ))
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 30),
                            for (NovelInfo novel in data)
                              GestureDetector(child: EbookCard(novel), onTap: () => context.go("/test"))
                          ],
                        ),
                      )
                    ]),
              ));
        });
  }
}
