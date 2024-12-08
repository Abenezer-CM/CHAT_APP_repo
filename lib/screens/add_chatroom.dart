import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:globalchatapp/providers/userprovider.dart';
import 'package:globalchatapp/screens/dashboard_screen.dart';
import 'package:provider/provider.dart';

class AddChatroom extends StatefulWidget {
  const AddChatroom({super.key});

  @override
  State<AddChatroom> createState() => _AddChatroomState();
}

class _AddChatroomState extends State<AddChatroom> {
  Future<void> addChatroom(String name, String description) async {
    CollectionReference chatRooms =
        FirebaseFirestore.instance.collection('chatRooms');

    // Data for the chatroom
    Map<String, dynamic> chatRoomData = {
      'chat_name': name,
      'desc': description,
    };

    try {
      await chatRooms.add(chatRoomData);
      print('Chatroom added successfully!');
    } catch (e) {
      print('Error adding chatroom: $e');
    }
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<Userprovider>(context);

    return Scaffold(
      appBar: AppBar(title: const Center(child: Text("Create Chatroom"))),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 15, right: 15),
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: "Chatroom Name",
              ),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                hintText: "Chatroom Description",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  addChatroom(nameController.text, descriptionController.text);
                  // get the getchatrooms methid from the dashboard screen
                  userProvider.getChatRooms(true);
                  Navigator.pop(context);
                },
                child: const Text("Create Chatroom"))
          ],
        ),
      ),
    );
  }
}
