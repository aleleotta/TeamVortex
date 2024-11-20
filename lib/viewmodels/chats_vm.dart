import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teamvortex/models/entities/ChatRoom.dart';
import 'package:teamvortex/models/services/firestore/firestore_chats.dart';

class ChatsViewModel extends ChangeNotifier {
  List<ChatRoom> _chatRooms = [];
  
  List<ChatRoom> get chatRooms => _chatRooms;

  Future<int> addChatRoom(String username) async {
    int statusCode = 0;
    try {
      ChatRoom chatRoom = ChatRoom(id: "", creationDate: Timestamp.now(),
      members: [FirebaseAuth.instance.currentUser!.displayName!, username]);
      statusCode = await FirestoreUserChats().addChatRoom(chatRoom);
    }
    catch (err) {
      statusCode = -1;
    }
    return statusCode;
  }

  void getChatRooms(String username) async {
    _chatRooms = await FirestoreUserChats().getChatRooms(username);
    notifyListeners();
  }

  ChatsViewModel() {
    getChatRooms(FirebaseAuth.instance.currentUser!.displayName!);
  }
}