import 'package:dio/dio.dart';

final OPTIONS =
    BaseOptions(followRedirects: true, baseUrl: "http://101.43.134.222:8000");
final dio = Dio(OPTIONS);

class NovelInfo {
  late String name,
      newChapterName,
      author,
      lastUpdate,
      href,
      newChapterHref,
      crawler;
  late int newChapterId, status;
  int? id;

  NovelInfo.from(Map<String, dynamic> map) {
    id = map["id"];
    name = map["name"]!;
    newChapterName = map["new_chapter_name"]!;
    author = map["author"]!;
    lastUpdate = map["last_update"]!;
    href = map["href"]!;
    newChapterHref = map["new_chapter_href"]!;
    crawler = map["crawler"]!;
    newChapterId = map["new_chapter_id"]!;
    status = map["status"]!;
  }
}

NovelInfo getTestNovelInfo() {
  return NovelInfo.from( {
    "id": 1,
    "name": "美漫：我的战锤模拟器",
    "new_chapter_name": " 059、太空死灵：血腥百日（上）",
    "new_chapter_id": 60,
    "author": "慈父纳垢",
    "last_update": "22-06-11",
    "status": 0,
    "href": "https://www.shuquzw.com//0/236/236714/",
    "new_chapter_href": "https://www.shuquzw.com//0/236/236714/32911125.html",
    "crawler": "SilukeCrawler"
  });
}

class ChapterInfo {
  late String name, href, crawler;
  late int chapterId;
  int? id;
  String? content;

  ChapterInfo.from(Map<String, dynamic> map) {
    id = map["id"];
    name = map["name"]!;
    href = map["href"]!;
    crawler = map["crawler"]!;
    chapterId = map["chapter_id"]!;
    content = map["content"];
  }
}

Future<List<NovelInfo>> getNovelListApi() async {
  final resp = await dio.get("/novel_crawler/api/v1/novels/get_novel");
  resp.data as List<dynamic>;

  List<NovelInfo> res = [];
  for (Map<String, dynamic> map in resp.data) {
    res.add(NovelInfo.from(map));
  }
  return res;
}

Future<List<ChapterInfo>> getChapterInfoListApi(int novelId) async {
  final resp = await dio.get("/novel_crawler/api/v1/chapter/get_chapter_list",
      queryParameters: {"novel_id": novelId});
  resp.data as List<dynamic>;

  List<ChapterInfo> res = [];
  for (Map<String, dynamic> map in resp.data) {
    res.add(ChapterInfo.from(map));
  }
  return res;
}

Future<List<ChapterInfo>> getChapterDetailListApi(
    int novelId, List<int> chapterIds) async {
  final resp = await dio.get("/novel_crawler/api/v1/chapter/get_chapter_detail",
      queryParameters: {"novel_id": novelId, "chapter_id": chapterIds});
  resp.data as List<dynamic>;
  List<ChapterInfo> res = [];
  for (Map<String, dynamic> map in resp.data) {
    res.add(ChapterInfo.from(map));
  }
  return res;
}

void main() async {
  // print(await getNovelListApi());
  print(await getChapterDetailListApi(1, [1, 2, 3]));
}
