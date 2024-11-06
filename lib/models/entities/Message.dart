// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  // Attributes
  final String senderId;
  final String senderUsername;
  final String receiverId;
  final String messageString;
  final Timestamp timestamp;

  // Getters
  String get getSenderId => senderId;
  String get getSenderUsername => senderUsername;
  String get getReceiverId => receiverId;
  String get getMessageString => messageString;
  Timestamp get getTimestamp => timestamp;

  // Constructor
  Message(
    {required this.senderId,
    required this.senderUsername,
    required this.receiverId,
    required this.messageString,
    required this.timestamp}
  );

  /// Converts a Message object to a map.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "senderId": senderId,
      "senderUsername": senderUsername,
      "receiverId": receiverId,
      "messageString": messageString,
      "timestamp": timestamp
    };
  }

  /// Converts a map of type Message to an object.
  static Message fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map["senderId"] as String,
      senderUsername: map["senderUsername"] as String,
      receiverId: map["receiverId"] as String,
      messageString: map["messageString"] as String,
      timestamp: map["timestamp"] as Timestamp
    );
  }
}