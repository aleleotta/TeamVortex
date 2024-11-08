// ignore_for_file: file_names

class ChatRoom {
  // Attributes
  final String id;
  final String title;
  final String preview;
  final String recentTimestamp;
  final List<String> members;

  // Getters
  String get getId => id;
  String get getTitle => title;
  String get getPreview => preview;
  String get getRecentTimestamp => recentTimestamp;
  List<String> get getMembers => members;

  // Constructor
  ChatRoom({
    required this.id,
    required this.title,
    required this.preview,
    required this.recentTimestamp,
    required this.members
  });

  // Methods
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "preview": preview,
      "recentTimestamp": recentTimestamp,
      "members": members
    };
  }

  static ChatRoom fromMap(Map<String, dynamic> map) {
    return ChatRoom(
      id: map["id"],
      title: map["title"],
      preview: map["preview"],
      recentTimestamp: map["recentTimestamp"],
      members: map["members"]
    );
  }
}