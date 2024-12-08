import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:globalchatapp/providers/userprovider.dart';
import 'package:provider/provider.dart';

class EditprofileScreen extends StatefulWidget {
  const EditprofileScreen({super.key});

  @override
  State<EditprofileScreen> createState() => _EditprofileScreenState();
}

class _EditprofileScreenState extends State<EditprofileScreen> {
  Map<String, dynamic>? UserData = {};
  TextEditingController nameController = TextEditingController();

  var db = FirebaseFirestore.instance;
  var userid = FirebaseAuth.instance.currentUser;

  void getData() {
    db.collection("users").doc(userid!.uid).get().then((dataSnapshot) {
      setState(() {
        UserData = dataSnapshot.data();
      });
    });
  }

  @override
  void initState() {
    getData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<Userprovider>(context);

    var editProfileForm = GlobalKey<FormState>();

    void updateData() {
      Map<String, dynamic> newName = {"name": nameController.text};

      db.collection('users').doc(userid!.uid).update(newName);
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text("Edit Profile"),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  if (editProfileForm.currentState!.validate()) {
                    updateData();
                    userProvider.getUserDetails();
                    Navigator.pop(context);
                  }
                },
                child: const Icon(
                  Icons.check,
                  color: Colors.green,
                ),
              ),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: editProfileForm,
            child: Container(
              child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Name cant be empty";
                    }
                    return null;
                  },
                  controller: nameController,
                  decoration: const InputDecoration(
                    label: Text("Name"),
                  )),
            ),
          ),
        ));
  }
}
