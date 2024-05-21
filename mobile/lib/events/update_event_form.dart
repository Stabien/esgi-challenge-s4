// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UpdateEventForm extends StatefulWidget {
  final String eventId;

  const UpdateEventForm({super.key, required this.eventId});

  @override
  _UpdateEventFormState createState() => _UpdateEventFormState();
}

class _UpdateEventFormState extends State<UpdateEventForm> {
  late Event _event = Event.empty();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _dateController;
  late TextEditingController _bannerController;
  late TextEditingController _participantNumberController;
  late TextEditingController _latController;
  late TextEditingController _lngController;
  late TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _dateController = TextEditingController();
    _bannerController = TextEditingController();
    _participantNumberController = TextEditingController();
    _latController = TextEditingController();
    _lngController = TextEditingController();
    _locationController = TextEditingController();
    _fetchEventDetails();
  }

  void _fetchEventDetails() async {
    try {
      var dio = Dio();
      dio.options.connectTimeout = const Duration(milliseconds: 10000);
      String? apiUrl = '${dotenv.env['URL_BACK']}/event/${widget.eventId}';
      var response = await dio.get(apiUrl);
      print("---------------------------------------------------------------");
      print(response.statusCode);
      if (response.statusCode == 200) {
        setState(() {
          print(response.data);
          _event = Event.fromJson(response.data);
          print(_event.title);
          _titleController.text = _event.title;
          _descriptionController.text = _event.description;
          _dateController.text = _event.date;
          _bannerController.text = _event.banner;
          _participantNumberController.text =
              _event.participantNumber.toString();
          _latController.text = _event.lat.toString();
          _lngController.text = _event.lng.toString();
          _locationController.text = _event.location;
        });
      }
    } catch (e) {
      print("Error fetching event details: $e");
    }
  }

  void _updateEvent() async {
    var dio = Dio();
    String? apiUrl = '${dotenv.env['URL_BACK']}/event/${widget.eventId}';

    try {
      var response = await dio.patch(apiUrl, data: {
        'title': _titleController.text,
        'description': _descriptionController.text,
        'date': _dateController.text,
        'banner': _bannerController.text,
        'participant_number': int.parse(_participantNumberController.text),
        'lat': double.parse(_latController.text),
        'lng': double.parse(_lngController.text),
        'location': _locationController.text,
      });

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Succès"),
            content: const Text("Événement modifié avec succès."),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Erreur"),
          content: Text("Erreur lors de la modification de l'événement. $e"),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Modifier un événement"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: "Titre",
              ),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: "Description",
              ),
            ),
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(
                labelText: "Date (YYYY-MM-DD)",
              ),
            ),
            TextField(
              controller: _bannerController,
              decoration: const InputDecoration(
                labelText: "Bannière (URL)",
              ),
            ),
            TextField(
              controller: _participantNumberController,
              decoration: const InputDecoration(
                labelText: "Nombre de participants",
              ),
            ),
            TextField(
              controller: _latController,
              decoration: const InputDecoration(
                labelText: "Latitude",
              ),
            ),
            TextField(
              controller: _lngController,
              decoration: const InputDecoration(
                labelText: "Longitude",
              ),
            ),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: "Location",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateEvent,
              child: const Text("Mettre à jour l'événement"),
            ),
          ],
        ),
      ),
    );
  }
}

class Event {
  final String id;
  String title;
  String description;
  String date;
  String banner;
  int participantNumber;
  double lat;
  double lng;
  String location;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.banner,
    required this.participantNumber,
    required this.lat,
    required this.lng,
    required this.location,
  });

  // Factory method to create Event object from JSON
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      date: json['date'] ?? '',
      banner: json['banner'] ?? '',
      participantNumber: json['participant_number'] ?? 0,
      lat: json['lat'] ?? 0.0,
      lng: json['lng'] ?? 0.0,
      location: json['location'] ?? '',
    );
  }

  // Static method to create empty Event object
  factory Event.empty() {
    return Event(
      id: '',
      title: '',
      description: '',
      date: '',
      banner: '',
      participantNumber: 0,
      lat: 0.0,
      lng: 0.0,
      location: '',
    );
  }
}
