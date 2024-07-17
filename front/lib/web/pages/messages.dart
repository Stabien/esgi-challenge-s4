import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/mobile/events/chat_screen.dart';
import 'package:mobile/web/pages/events.dart';
import 'package:mobile/web/ui/appbar.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  late Future<List<Event>> _allEventsFuture;
  List<Event> _allEvents = [];

  @override
  void initState() {
    super.initState();
    _allEventsFuture = fetchAllEvents();

    _allEventsFuture.then((events) {
      setState(() {
        _allEvents = events;
      });
    }).catchError((error) {
      print('Error fetching events: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WebAppBar(),
      body: FutureBuilder<List<Event>>(
        future: _allEventsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Event event = snapshot.data![index];
                return ListTile(
                  leading: Image.memory(
                    base64Decode(event.banner),
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  title: Text(event.title),
                  subtitle:
                      Text(event.description, style: TextStyle(fontSize: 16)),
                  trailing: IconButton(
                    icon: const Icon(Icons.message),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: MediaQuery.of(context).size.height * 0.7,
                              child: MessagePage(id: event.id),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No events found'));
          }
        },
      ),
    );
  }
}
