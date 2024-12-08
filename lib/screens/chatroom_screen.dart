import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:globalchatapp/providers/userprovider.dart';
import 'package:provider/provider.dart';

class ChatroomScreen extends StatefulWidget {
  String chatRoomName;
  String chatRoomId;

  ChatroomScreen(
      {super.key, required this.chatRoomName, required this.chatRoomId});

  @override
  State<ChatroomScreen> createState() => _ChatroomScreenState();
}

class _ChatroomScreenState extends State<ChatroomScreen> {
  TextEditingController messageController = TextEditingController();
  var db = FirebaseFirestore.instance;
  String userID = FirebaseAuth.instance.currentUser!.uid;

  Future<void> sendMessage() async {
    if (messageController.text.isEmpty) {
      return;
    }
    Map<String, dynamic> msg = {
      "text": messageController.text,
      "sender_name": Provider.of<Userprovider>(context, listen: false).userName,
      "chatroom_id": widget.chatRoomId,
      "user_id": userID,
      "timestamp": FieldValue.serverTimestamp()
    };

    messageController.text = "";
    try {
      await db.collection("messages").add(msg);
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatRoomName),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                stream: db
                    .collection("messages")
                    .where("chatroom_id", isEqualTo: widget.chatRoomId)
                    .limit(100)
                    .orderBy("timestamp", descending: true)
                    .snapshots(),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text("Error has occured");
                  }

                  var allMessages = snapshot.data?.docs ?? [];

                  if (allMessages.isEmpty) {
                    return const Center(child: Text("No Messages"));
                  }
                  return ListView.builder(
                      reverse: true,
                      itemCount: allMessages.length,
                      itemBuilder: (BuildContext context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment:
                                (userID == allMessages[index]["user_id"])
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                            children: [
                              Text(
                                allMessages[index]["sender_name"],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(": "),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.7,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color:
                                      (userID == allMessages[index]["user_id"])
                                          ? Colors.green
                                          : Colors.blueAccent,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width -
                                              60, // Adjust padding
                                    ),
                                    child: Text(
                                      allMessages[index]["text"],
                                      textAlign: TextAlign.start,
                                      style: TextStyle(color: Colors.white),
                                      overflow: TextOverflow
                                          .visible, // Ensures no horizontal overflow
                                      softWrap:
                                          true, // Wraps text to the next line
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                }),
          ),
          Container(
            color: Colors.grey[200],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: "Send a message...",
                      border: InputBorder.none,
                    ),
                  )),
                  InkWell(
                      onTap: () {
                        sendMessage();
                      },
                      child: const Icon(Icons.send))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
