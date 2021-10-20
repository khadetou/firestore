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
  TextEditingController? nameInputController;
  TextEditingController? titleInputController;
  TextEditingController? descriptionInputController;

  @override
  void initState() {
    super.initState();
    nameInputController = TextEditingController();
    titleInputController = TextEditingController();
    descriptionInputController = TextEditingController();
  }

  _showDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(10),
          content: Column(
            children: <Widget>[
              const Text("Fill out the form"),
              Expanded(
                child: TextField(
                  autofocus: true,
                  autocorrect: true,
                  decoration: const InputDecoration(labelText: "Your Name"),
                  controller: nameInputController,
                ),
              ),
              Expanded(
                child: TextField(
                  autofocus: true,
                  autocorrect: true,
                  decoration: const InputDecoration(labelText: "Your Title"),
                  controller: titleInputController,
                ),
              ),
              Expanded(
                child: TextField(
                  autofocus: true,
                  autocorrect: true,
                  decoration:
                      const InputDecoration(labelText: "Your Description"),
                  controller: descriptionInputController,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                nameInputController!.clear();
                titleInputController!.clear();
                descriptionInputController!.clear();
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameInputController!.text.isNotEmpty &&
                    titleInputController!.text.isNotEmpty &&
                    descriptionInputController!.text.isNotEmpty) {
                  FirebaseFirestore.instance.collection("board").add({
                    "name": nameInputController!.text,
                    "title": titleInputController!.text,
                    "description": descriptionInputController!.text,
                    "timestamp": DateTime.now(),
                  }).then((response) {
                    print(response.id);
                    Navigator.pop(context);
                    nameInputController!.clear();
                    titleInputController!.clear();
                    descriptionInputController!.clear();
                  }).catchError((error) => print(error));
                }
              },
              child: const Text("Save"),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FireStore app"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDialog(context);
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
