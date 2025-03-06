import 'message_model.dart'; // Importa Message si es necesario

class Chat {
  final String id;
  final String user1Id;
  final String user2Id;
  final DateTime createdAt;
  List<Message> messages;

  Chat({
    required this.id,
    required this.user1Id,
    required this.user2Id,
    required this.createdAt,
    this.messages = const [],
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'],
      user1Id: json['user1Id'],
      user2Id: json['user2Id'],
      createdAt: DateTime.parse(json['createdAt']),
      messages: (json['messages'] as List)
          .map((message) => Message.fromJson(message))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user1Id': user1Id,
      'user2Id': user2Id,
      'createdAt': createdAt.toIso8601String(),
      'messages': messages.map((message) => message.toJson()).toList(),
    };
  }
}