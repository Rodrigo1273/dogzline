import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'models/message_model.dart'; // Importa message_model.dart
import 'models/chat_model.dart';
import 'models/message_model.dart';

class ChatScreen extends StatefulWidget {
  final String currentUserId;
  final String matchUserId;

  ChatScreen({required this.currentUserId, required this.matchUserId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ApiService _apiService = ApiService();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    try {
      List<Message> mensajes = await _apiService.obtenerMensajes(widget.matchUserId);
      setState(() {
        _messages.addAll(mensajes);
      });
      _scrollToBottom(); // Desplazar al final después de cargar los mensajes
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar los mensajes: $e')),
      );
    }
  }

  void _sendMessage() async {
    if (_controller.text.isEmpty) return;

    final message = Message(
      senderId: widget.currentUserId,
      receiverId: widget.matchUserId,
      content: _controller.text,
      timestamp: DateTime.now(),
    );

    // Limpiar el campo de texto
    _controller.clear();

    try {
      // Enviar el mensaje al backend
      await _apiService.guardarMensaje(widget.matchUserId, widget.currentUserId, message.content);

      // Añadir el mensaje a la lista local
      setState(() {
        _messages.insert(0, message); // Insertar al principio para el ListView invertido
      });

      _scrollToBottom(); // Desplazar al final después de enviar el mensaje
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al enviar el mensaje: $e')),
      );
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0, // ListView invertido, por lo que 0 es el final
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        backgroundColor: Colors.brown[700],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true, // ListView invertido para mostrar los mensajes más recientes abajo
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isMe = message.senderId == widget.currentUserId;
                return _buildMessageBubble(message, isMe);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Escribe un mensaje...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.brown[700]),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message message, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color: isMe ? Colors.brown[100] : Colors.grey[300],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 4),
            Text(
              _formatTimestamp(message.timestamp),
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}