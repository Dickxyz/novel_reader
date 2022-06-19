import 'dart:async';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

const String columnId = "id";
const String columnIcon = "icon";
const String columnDesc = "desc";
const String tableTag = "tags";

const Map<String, IconData> iconMap = {
  "fastfood": Icons.fastfood,
  "smoke_free": Icons.smoke_free,
  "shopping_cart": Icons.shopping_cart,
  "commute": Icons.commute,
};

IconData toIconData(String name) {
  return iconMap[name]!;
}


class Tag {
  int? id;
  late String icon, desc;

  List<String> toList() {
    List<String> res = [id.toString(), icon, desc];
    return res;
  }

  Map<String, Object?> toMap() {
    return <String, Object?>{
      columnId: id,
      columnIcon: icon,
      columnDesc: desc,
    };
  }

  Tag.fromMap(Map<String, Object?> map) {
    if (map.containsKey(columnId)) {
      id = map[columnId] as int;
    }

    icon = map[columnIcon] as String;
    desc = map[columnDesc] as String;
  }
}

class TagDao {
  late Database db;

  TagDao(this.db);

  Future<void> init() async {
      await db.execute('''
          create table IF NOT EXISTS $tableTag ( 
            $columnId integer primary key autoincrement, 
            $columnIcon text not null,
            $columnDesc text not null)
          ''');

      final tags = [
        Tag.fromMap({columnIcon: "fastfood", columnDesc: "正餐"}),
        Tag.fromMap({columnIcon: "smoke_free", columnDesc: "烟"}),
        Tag.fromMap({columnIcon: "shopping_cart", columnDesc: "生活用品"}),
        Tag.fromMap({columnIcon: "commute", columnDesc: "交通工具"}),
      ];

      for (Tag tag in tags) {
        await insert(tag);
      }
  }

  Future<List<Tag>> getAllTag() async {
    List<Tag> res = [];
    List<Map<String, Object?>> maps =
        await db.query(tableTag, columns: [columnId, columnIcon, columnDesc]);
    for (Map<String, Object?> map in maps) {
      res.add(Tag.fromMap(map));
    }
    return res;
  }

  Future<Tag> insert(Tag tag) async {
    tag.id = await db.insert(tableTag, tag.toMap());
    return tag;
  }

  Future<int> delete(int id) async {
    return await db.delete(tableTag, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(Tag tag) async {
    return await db.update(tableTag, tag.toMap(),
        where: '$columnId = ?', whereArgs: [tag.id]);
  }

  Future<String> toCsvString() async {
    List<List<String>> tmp = [];
    List<Map<String, Object?>> maps =
        await db.query(tableTag, columns: [columnId, columnIcon, columnDesc]);
    for (Map<String, Object?> map in maps) {
      tmp.add(Tag.fromMap(map).toList());
    }
    final String res = const ListToCsvConverter().convert(tmp);
    return res;
  }

  Future close() async => db.close();
}
