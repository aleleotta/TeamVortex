import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teamvortex/backend/models/entities/ChatRoom.dart';
import 'package:teamvortex/backend/models/entities/Message.dart';
import 'package:teamvortex/backend/models/services/firestore/firestore_chats.dart';

class ChatsViewModel extends ChangeNotifier {
  List<ChatRoom> _chatRooms = [];
  ChatRoom? _selectedChatRoom;
  Stream<QuerySnapshot>? _chatRoomMessages;
  bool chatViewVisible = false;
  
  List<ChatRoom> get chatRooms => _chatRooms;
  ChatRoom? get selectedChatRoom => _selectedChatRoom;
  Stream<QuerySnapshot>? get chatRoomMessages => _chatRoomMessages;

  /// Creates a new ChatRoom with two users as members
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

  /// Returns a list of ChatRooms that the user is a member of
  void getChatRooms(String username) async {
    _chatRooms = await FirestoreUserChats().getChatRooms(username);
    notifyListeners();
  }

  /// Deletes a ChatRoom and notifies listeners.
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

  /// Sets the selected chat room and notifies listeners.
  void setChatRoom(ChatRoom chatRoom) {
    _selectedChatRoom = chatRoom;
    _chatRoomMessages = FirestoreUserChats().getMessages(chatRoom.id);
    chatViewVisible = true;
    notifyListeners();
  }

  /// Clears the list of ChatRooms and notifies listeners.
  void clearChatRoomsList() {
    _chatRooms.clear();
    notifyListeners();
  }

  /// Uploads a new message to Firestore
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