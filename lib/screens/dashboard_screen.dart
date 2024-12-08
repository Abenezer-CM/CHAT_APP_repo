import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:globalchatapp/providers/userprovider.dart';
import 'package:globalchatapp/screens/add_chatroom.dart';
import 'package:globalchatapp/screens/chatroom_screen.dart';
import 'package:globalchatapp/screens/profile_screen.dart';
import 'package:globalchatapp/screens/splash_screen.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  var user = FirebaseAuth.instance.currentUser;
  var db = FirebaseFirestore.instance;
  var userid = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    var userProvider = Provider.of<Userprovider>(context, listen: false);
    userProvider.getChatRooms(true);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<Userprovider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Global Chat")),
      drawer: Drawer(
        // ignore: avoid_unnecessary_containers
        child: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Container(
            child: Column(
              children: [
                ListTile(
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();

                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (context) {
                      return const SplashScreen();
                    }), (route) {
                      return false;
                    });
                  },
                  leading: const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Text(
                    userProvider.userName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(userProvider.userEmail),
                ),
                ListTile(
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();

                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (context) {
                      return const SplashScreen();
                    }), (route) {
                      return false;
                    });
                  },
                  leading: const Icon(Icons.logout),
                  title: const Text("Logout"),
                ),
                ListTile(
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return const ProfileScreen();
                      }),
                    );
                  },
                  leading: const Icon(Icons.people),
                  title: const Text("Profile"),
                )
              ],
            ),
          ),
        ),
      ),
      body: ListView.builder(
          itemCount: userProvider.chatRooms.length,
          itemBuilder: (BuildContext context, int index) {
            String chatNameChar =
                userProvider.chatRooms[index]["chat_name"] ?? "";

            return InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ChatroomScreen(
                    chatRoomName: chatNameChar,
                    chatRoomId: userProvider.chatRoomIds[index],
                  );
                }));
              },
              child: ListTile(
                leading: CircleAvatar(child: Text(chatNameChar[0])),
                title: Text(
                  userProvider.chatRooms[index]["chat_name"] ?? "",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(userProvider.chatRooms[index]["desc"] ?? ""),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const AddChatroom();
            }));
          }),
    );
  }
}
