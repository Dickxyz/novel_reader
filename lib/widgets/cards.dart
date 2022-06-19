import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novel_reader/requests.dart';
import 'package:novel_reader/widgets/text.dart';

import '../consttants.dart';
import '../widgets/two_side_rounded_button.dart';

class EbookCard extends ConsumerWidget {
  const EbookCard(this.novel, {Key? key}) : super(key: key);

  final NovelInfo novel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var size = MediaQuery.of(context).size;
    return Container(

      margin: EdgeInsets.symmetric(horizontal: 6),
      height: 80,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(38.5),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 10),
            blurRadius: 33,
            color: Color(0xFFD3D3D3).withOpacity(.84),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(38.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 30, right: 20),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          PrimaryText(
                            text: novel.name,
                          ),
                          PrimaryText(
                            text: novel.author,
                            color: kLightBlackColor,
                            size: 12,
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              "Chapter 7 of 10",
                              style: TextStyle(
                                fontSize: 10,
                                color: kLightBlackColor,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),

                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: 7,
              width: size.width * .65,
              decoration: BoxDecoration(
                color: kProgressIndicator,
                borderRadius: BorderRadius.circular(7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
