import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";

showDialogFunction(
    {required BuildContext context,
    required TextEditingController titleInputController,
    required TextEditingController nameInputController,
    required TextEditingController descriptionInputController,
    required bool isUpdate,
    String? id}) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(10),
        content: Column(
          children: <Widget>[
            Text(
                isUpdate ? "Fill out the form to update" : "Fill out the form"),
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
              nameInputController.clear();
              titleInputController.clear();
              descriptionInputController.clear();
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameInputController.text.isNotEmpty &&
                  titleInputController.text.isNotEmpty &&
                  descriptionInputController.text.isNotEmpty) {
                if (isUpdate) {
                  FirebaseFirestore.instance
                      .collection("board")
                      .doc(id)
                      .update({
                    "name": nameInputController.text,
                    "title": titleInputController.text,
                    "description": descriptionInputController.text,
                    "timestamp": DateTime.now(),
                  }).then((response) {
                    Navigator.pop(context);
                  });
                } else {
                  FirebaseFirestore.instance.collection("board").add({
                    "name": nameInputController.text,
                    "title": titleInputController.text,
                    "description": descriptionInputController.text,
                    "timestamp": DateTime.now(),
                  }).then((response) {
                    print(response.id);
                    Navigator.pop(context);
                    nameInputController.clear();
                    titleInputController.clear();
                    descriptionInputController.clear();
                  }).catchError((error) => print(error));
                }
              }
            },
            child: Text(isUpdate ? "Update" : "Save"),
          )
        ],
      );
    },
  );
}
