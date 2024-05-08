import 'package:flutter/material.dart';
import 'package:mobile/models/eventDetail.dart';
import 'package:mobile/services/api_event_services.dart';

class DetailScreen extends StatefulWidget {
  final String id;
  const DetailScreen({super.key, required this.id});

    
  @override
  State<DetailScreen> createState() => _DetailScreen();
}

class _DetailScreen extends State<DetailScreen> {
  final List<EventDetail> _eventdetails = [];

  bool _loading = false;
  Error? _error;

  @override
  void initState() {
    super.initState();

    setState(() {
      _loading = true;
    });
    

    ApiServices.getEventDetail("285da4eb-3b00-4d8d-a6b7-e3c6cd1ec83d").then((data) {
      setState(() {
        _error = null;
        _eventdetails.clear();
        _eventdetails.addAll(data);
        _loading = false;
      });
    }).catchError((error) {
      setState(() {
        _error = error;
        _loading = false;
      });
    });


  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Builder(builder: (context) {
          if (_error != null) {
            return Center(
              child: Text(_error.toString()),
            );
          } else if (_loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              itemBuilder: (context, index) {
                final eventDetail  = _eventdetails[index];
                return ListTile(
                  title: Text(eventDetail.title),
                  subtitle: Text(eventDetail.description),
                );
              },
              itemCount: _eventdetails.length,
            );
          }
        }),
      ),
    );
  }
}