import "package:flutter/material.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class CustomCard extends StatelessWidget {
  final AsyncSnapshot<QuerySnapshot<Object?>> snapshot;
  final int index;

  const CustomCard({
    Key? key,
    required this.snapshot,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var snapshotData = snapshot.data!.docs[index];
    var id = snapshot.data!.docs[index].id;

    var timeToDate = DateTime.fromMillisecondsSinceEpoch(
        snapshotData["timestamp"].seconds * 1000);
    var dateFormatted = DateFormat("EEE, MM, d, y").format(timeToDate);

    return Column(
      children: <Widget>[
        SizedBox(
          height: 190,
          child: Card(
            elevation: 5,
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    snapshotData["title"],
                  ),
                  subtitle: Text(
                    snapshotData["description"],
                  ),
                  leading: CircleAvatar(
                    radius: 34,
                    child: Text(
                      snapshotData["title"].toString()[0],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("By ${snapshot.data!.docs[index]["name"]}: "),
                      Text(dateFormatted),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        FontAwesomeIcons.edit,
                        size: 15,
                      ),
                    ),
                    // SizedBox(),
                    IconButton(
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection("board")
                            .doc(id)
                            .delete();
                      },
                      icon: const Icon(FontAwesomeIcons.trashAlt, size: 15),
                    ),
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
