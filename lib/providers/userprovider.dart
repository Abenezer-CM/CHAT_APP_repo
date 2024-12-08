import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Userprovider extends ChangeNotifier {
  String userName = "";
  String userCountrty = "";
  String userEmail = "";
  String userId = "";

  Map<String, dynamic>? userData = {};

  var db = FirebaseFirestore.instance;

  List<Map<String, dynamic>> chatRooms = [];
  List<String> chatRoomIds = [];

  void getChatRooms(bool refresh) {
    if (refresh) {
      chatRooms = [];
      chatRoomIds = [];
    }

    db.collection("chatRooms").get().then((dataSnapshots) {
      for (var singleChatRoom in dataSnapshots.docs) {
        chatRooms.add(singleChatRoom.data());
        chatRoomIds.add(singleChatRoom.id.toString());
      }
      notifyListeners(); // Notify listeners after updating the lists
    });
  }

  void getUserDetails() {
    var userid = FirebaseAuth.instance.currentUser;
    var userid2 = userid?.uid;

    db.collection("users").doc(userid!.uid).get().then((dataSnapshot) {
      userName = dataSnapshot.data()?["name"] ?? "";
      userCountrty = dataSnapshot.data()?["country"] ?? "";
      userEmail = dataSnapshot.data()?["email"] ?? "";
      userId = userid2!;
      notifyListeners();
    });
  }
}
