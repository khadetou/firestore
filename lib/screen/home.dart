import 'package:firestore/widget/show_dialog.dart';
import "package:flutter/material.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "../widget/custome_card.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var firestoreDb = FirebaseFirestore.instance.collection("board").snapshots();
  TextEditingController nameInputController = TextEditingController();
  TextEditingController titleInputController = TextEditingController();
  TextEditingController descriptionInputController = TextEditingController();
  void _add(
      {required String name,
      required String title,
      required String description}) {
    FirebaseFirestore.instance.collection("board").add({
      "name": name,
      "title": title,
      "description": description,
      "timestamp": DateTime.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FireStore app"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var showDialogFunction2 = showDialogFunction(
              context: context,
              titleInputController: titleInputController,
              nameInputController: nameInputController,
              descriptionInputController: descriptionInputController,
              isUpdate: false);
        },
        child: const Icon(FontAwesomeIcons.pen),
      ),
      body: StreamBuilder(
        stream: firestoreDb,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              return CustomCard(snapshot: snapshot, index: index);
            },
          );
        },
      ),
    );
  }
}
