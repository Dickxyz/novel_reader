import 'package:flutter/material.dart';
import 'package:flutter_bookkeeper/models/tag.dart';
import 'package:flutter_bookkeeper/providers.dart';
import 'package:flutter_bookkeeper/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';


class NewRecord extends ConsumerStatefulWidget {
  const NewRecord({Key? key}) : super(key: key);

  @override
  _RecordState createState() => _RecordState();
}

class _RecordState extends ConsumerState<NewRecord> {
  int cost = 0;

  void setCost(int money) {
    setState(() {
      cost = money;
    });
  }

  @override
  Widget build(BuildContext context) {
    AsyncValue<List<Tag>> results = ref.watch(tagsProvider);
    return results.when(
        loading: () => const CircularProgressIndicator(),
        error: (err, stack) => Text('Error: $err'),
        data: (tags) {
          return Column(
            children: [
              const Text("支出"),
              TextButton(
                onPressed: () {
                  DatePicker.showDateTimePicker(context, locale: LocaleType.zh);
                },
                child: Text(cost.toString()),
              ),
              Wrap(
                  runSpacing: 20,
                  spacing: 20,
                  alignment: WrapAlignment.spaceBetween,
                  children: List.generate(tags.length, (index) {
                    return TagCard(tags[index]);
                  })),
            ],
          );
          logger.d("[_RecordState.build] get tags:${tags.toString()}");
        });
  }
}

class TagCard extends ConsumerWidget {
  final Tag tag;

  const TagCard(this.tag, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        constraints: BoxConstraints(minWidth: 100),
        padding: EdgeInsets.fromLTRB(10.0, 10.0, 10, 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: GestureDetector(
          onTap: () {},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [Icon(toIconData(tag.icon)), Text(tag.desc)],
          ),
        ));
  }
}
