import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teamvortex/models/entities/ChatRoom.dart';
import 'package:teamvortex/models/services/firestore/firestore_chats.dart';

class ChatsViewModel extends ChangeNotifier {
  List<ChatRoom> _chatRooms = [];
  
  List<ChatRoom> get chatRooms => _chatRooms;

  void getChatRooms(String username) async {
    _chatRooms = await FirestoreUserChats().getChats(username);
    notifyListeners();
  }

  ChatsViewModel() {
    getChatRooms(FirebaseAuth.instance.currentUser!.displayName!);
  }
}