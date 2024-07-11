import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile/mobile/services/formatDate.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:mobile/mobile/models/message.dart';
import 'package:mobile/mobile/models/organizer.dart';
import 'package:mobile/mobile/models/profil.dart';
import 'package:mobile/mobile/services/message_services.dart';
import 'package:mobile/mobile/services/userServices.dart';
import 'package:mobile/mobile/utils/secureStorage.dart';

class MessagePage extends StatefulWidget {
  final String id;

  const MessagePage({super.key, required this.id});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final TextEditingController _controller = TextEditingController();
  final List<Message> _messages = [];
  WebSocketChannel? _channel;
  var _userId = "";
  Profil? profil;
  Organizer? orga;

  @override
  void initState() {
    super.initState();
    getprofil();
    print(widget.id);
  }

  Future<void> getprofil() async {
    final userId = await SecureStorage.getStorageItem('userId');
    setState(() {
      _userId = userId!;
    });
    profil = await UserServices().profilOrga(_userId);
    _connectWebSocket();
    orga = await UserServices().getOrgaByUser(_userId);
    List<Message> oldMessages =
        await MessageServices().getMessagesByEvent(widget.id);
    setState(() {
      _messages.addAll(oldMessages);
    });
  }

  void sendMessageBdd(Message message) async {
    await MessageServices().postMessage(message);
  }

  void _sendMessageText() {
    if (_controller.text.isNotEmpty) {
      final text = _controller.text;
      final message = Message(
        sender: profil?.firstname ?? 'Unknown',
        date: DateTime.now().toUtc().toIso8601String(),
        text: text,
        organizerId: orga?.id,
        eventId: widget.id,
      );
      sendMessageBdd(message);
      setState(() {
        _messages.add(message);
        _controller.clear();
      });
      if (_channel != null) {
        final messageJson = jsonEncode(message.toJson());
        _channel!.sink.add(messageJson);
      }
    }
  }

  void _connectWebSocket() {
    _channel = WebSocketChannel.connect(
      Uri.parse('ws://10.0.2.2:3000/ws/room?roomName=${widget.id}'),
    );
    print('Connected to WebSocket server');

    _channel!.stream.listen((message) {
      setState(() {
        try {
          var decodedMessage = jsonDecode(message);
          _messages.add(Message.fromJson(decodedMessage));
        } catch (e) {
          print('Erreur lors du décodage du message: $e');
        }
      });
    }, onDone: () {
      print('Disconnected from WebSocket');
      _reconnectWebSocket();
    }, onError: (error) {
      print('WebSocket error: $error');
      _reconnectWebSocket();
    });
  }

  void _reconnectWebSocket() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        _connectWebSocket();
      }
    });
  }

  @override
  void dispose() {
    _channel?.sink.close(status.goingAway);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Message'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final bool isCurrentUserMessage =
                    message.organizerId == orga?.id;

                // Vérifier si le message est envoyé par l'organisateur actuel
                final bool isCurrentOrganizerMessage =
                    message.organizerId == orga?.id;

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: Column(
                    crossAxisAlignment: isCurrentOrganizerMessage
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.sender ?? 'Unknown',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      Align(
                        alignment: isCurrentOrganizerMessage
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4.0),
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: isCurrentOrganizerMessage
                                ? Colors.blue[200]
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                message.text,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              Text(
                                // traduireDate(message.date),
                                message.date,
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter your message',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessageText,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
