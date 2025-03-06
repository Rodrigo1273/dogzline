import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'models/chat_model.dart';

class ChatListScreen extends StatelessWidget {
  final String currentUserId;
  final List<Map<String, dynamic>> matches;

  const ChatListScreen({required this.currentUserId, required this.matches, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        backgroundColor: Colors.brown[700],
      ),
      body: matches.isEmpty
          ? const Center(child: Text('No hay chats disponibles'))
          : ListView.builder(
              itemCount: matches.length,
              itemBuilder: (context, index) {
                final match = matches[index];
                final matchUserId = match['idUsuario'] ?? '';
                final matchUserName = match['nombre'] ?? 'Usuario desconocido';

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.brown[300],
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text(matchUserName),
                  subtitle: const Text('Tap to chat'),
                  onTap: () {
                    if (matchUserId.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            currentUserId: currentUserId,
                            matchUserId: matchUserId,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Error al abrir el chat')),
                      );
                    }
                  },
                );
              },
            ),
    );
  }
}
