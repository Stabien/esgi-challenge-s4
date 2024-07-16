// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile/mobile/utils/secureStorage.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:mobile/web/utils/api_utils.dart';

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
  late TextEditingController _tagController;
  late TextEditingController _imageController;
  late TextEditingController _placeController;

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
    _tagController = TextEditingController();
    _imageController = TextEditingController();
    _placeController = TextEditingController();
    _fetchEventDetails();
  }

  void _fetchEventDetails() async {
    try {
      var response = await ApiUtils.get('/event/${widget.eventId}');
      if (response.statusCode == 200) {
        setState(() {
          _event = Event.fromJson(response.data);
          _titleController.text = _event.title;
          _descriptionController.text = _event.description;
          _dateController.text = _event.date;
          _bannerController.text = _event.banner;
          _participantNumberController.text =
              _event.participantNumber.toString();
          _latController.text = _event.lat.toString();
          _lngController.text = _event.lng.toString();
          _locationController.text = _event.location;
          _tagController.text = _event.tag;
          _imageController.text = _event.image;
          _placeController.text = _event.place;
        });
      }
    } catch (e) {
      print("Error fetching event details: $e");
    }
  }

  void _updateEvent() async {
    try {
      var data = {
        'title': _titleController.text,
        'description': _descriptionController.text,
        'date': _dateController.text,
        'banner': _bannerController.text,
        'participant_number': int.parse(_participantNumberController.text),
        'lat': double.parse(_latController.text),
        'lng': double.parse(_lngController.text),
        'location': _locationController.text,
        'tag': _tagController.text,
        'image': _imageController.text,
        'place': _placeController.text,
      };
      var response = await ApiUtils.patch('/event/${widget.eventId}', data);

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Succès"),
            content: const Text("Événement modifié avec succès."),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          ),
        );
      }
    } on DioException catch (e) {
      String errorMessage = '';
      if (e.response != null &&
          e.response?.data != null &&
          e.response?.data['error'] != null) {
        errorMessage += e.response!.data['error'];
      } else {
        errorMessage += e.message!;
      }
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Erreur"),
          content: Text(
              "Erreur lors de la modification de l'événement : $errorMessage"),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Erreur"),
          content: const Text("Erreur lors de la modification de l'événement."),
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
            Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Titre",
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: "Description",
                ),
              ),
            ),
            _dateController.text.isEmpty
                ? const Text(
                    "Date (YYYY-MM-DD) :",
                    style: const TextStyle(color: Colors.white),
                  )
                : Column(children: [
                    Text(
                      "Date (YYYY-MM-DD) : ${DateTime.parse(_dateController.text).day}/${DateTime.parse(_dateController.text).month > 9 ? DateTime.parse(_dateController.text).month : '0${DateTime.parse(_dateController.text).month}'}/${DateTime.parse(_dateController.text).year}",
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      "Heure : ${DateTime.parse(_dateController.text).hour}H${DateTime.parse(_dateController.text).minute > 9 ? DateTime.parse(_dateController.text).minute : '0${DateTime.parse(_dateController.text).minute}'}",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ]),
            Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: ElevatedButton(
                  onPressed: () {
                    DatePicker.showDateTimePicker(
                      context,
                      showTitleActions: true,
                      minTime: DateTime.now(),
                      maxTime: DateTime.now().add(const Duration(days: 730)),
                      onConfirm: (date) {
                        setState(() {
                          _dateController.text = date.toUtc().toIso8601String();
                        });
                      },
                      currentTime: _dateController.text.isNotEmpty
                          ? DateTime.parse(_dateController.text)
                          : DateTime.now(),
                      locale: LocaleType.fr,
                    );
                  },
                  child: const Text(
                    'Choisir une date et une heure',
                  )),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                controller: _bannerController,
                decoration: const InputDecoration(
                  labelText: "Bannière (URL)",
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                controller: _participantNumberController,
                decoration: const InputDecoration(
                  labelText: "Nombre de participants",
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                controller: _latController,
                decoration: const InputDecoration(
                  labelText: "Latitude",
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                controller: _lngController,
                decoration: const InputDecoration(
                  labelText: "Longitude",
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: "Location",
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                controller: _tagController,
                decoration: const InputDecoration(
                  labelText: "Tag",
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                controller: _imageController,
                decoration: const InputDecoration(
                  labelText: "Image",
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                controller: _placeController,
                decoration: const InputDecoration(
                  labelText: "Place",
                ),
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
  String tag;
  String image;
  String place;

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
    required this.tag,
    required this.image,
    required this.place,
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
      tag: json['tag'] ?? '',
      image: json['image'] ?? '',
      place: json['place'] ?? '',
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
      tag: '',
      image: '',
      place: '',
    );
  }
}
