import 'package:flutter/material.dart';
import 'package:mobile/mobile/services/format_date.dart';
import 'package:mobile/mobile/models/message.dart';
import 'package:mobile/mobile/models/profil.dart';
import 'package:mobile/mobile/services/message_services.dart';
import 'package:mobile/mobile/services/user_services.dart';
import 'package:mobile/mobile/utils/secure_storage.dart';

class MessageView extends StatefulWidget {
  final String id;

  const MessageView({super.key, required this.id});

  @override
  State<MessageView> createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  final List<Message> _messages = [];
  var _userId = "";
  Profil? profil;

  @override
  void initState() {
    super.initState();
    getprofil();
  }

  Future<void> getprofil() async {
    final userId = await SecureStorage.getStorageItem('userId');

    setState(() {
      _userId = userId!;
    });

    profil = await UserServices().profilOrga(_userId);
    List<Message> oldMessages =
        await MessageServices().getMessagesByEvent(widget.id);
    setState(() {
      _messages.addAll(oldMessages);
    });
  }

  @override
  void dispose() {
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

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.sender,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4.0),
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
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
                                traduireDate(message.date),
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
        ],
      ),
    );
  }
}
