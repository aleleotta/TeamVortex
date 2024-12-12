import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teamvortex/models/entities/ChatRoom.dart';
import 'package:teamvortex/models/entities/Message.dart';
import 'package:teamvortex/models/services/firestore/firestore_chats.dart';

class ChatsViewModel extends ChangeNotifier {
  List<ChatRoom> _chatRooms = [];
  ChatRoom? _selectedChatRoom;
  Stream<QuerySnapshot>? _chatRoomMessages;
  bool chatViewVisible = false;
  
  List<ChatRoom> get chatRooms => _chatRooms;
  ChatRoom? get selectedChatRoom => _selectedChatRoom;
  Stream<QuerySnapshot>? get chatRoomMessages => _chatRoomMessages;

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

  Future<int> deleteChatRoom() async {
    int statusCode = 0;
    try {
      statusCode = await FirestoreUserChats().deleteChatRoom(_selectedChatRoom!.id);
      getChatRooms(FirebaseAuth.instance.currentUser!.displayName!);
      _selectedChatRoom = null;
      _chatRoomMessages = null;
      chatViewVisible = false;
    }
    catch (err) {
      statusCode = -1;
    }
    notifyListeners();
    return statusCode;
  }

  void setChatRoom(ChatRoom chatRoom) {
    _selectedChatRoom = chatRoom;
    _chatRoomMessages = FirestoreUserChats().getMessages(chatRoom.id);
    chatViewVisible = true;
    notifyListeners();
  }

  void clearChatRoomsList() {
    _chatRooms.clear();
    notifyListeners();
  }

  Future<int> sendMessage(String messageString) async {
    int statusCode = 0;
    try {
      Message message = Message(
          senderId: FirebaseAuth.instance.currentUser!.uid,
          senderUsername: FirebaseAuth.instance.currentUser!.displayName!,
          receiverId: _selectedChatRoom!.id,
          messageString: messageString,
          timestamp: Timestamp.now()
      );
      FirestoreUserChats().sendMessage(message);
    }
    catch (err) {
      statusCode = -1;
    }
    return statusCode;
  }

  ChatsViewModel() {
    getChatRooms(FirebaseAuth.instance.currentUser!.displayName!);
  }
}