// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/mobile/utils/file.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:mobile/mobile/utils/secure_storage.dart';
import 'package:mobile/web/utils/api_utils.dart';

class UpdateEventForm extends StatefulWidget {
  final String eventId;

  const UpdateEventForm({super.key, required this.eventId});

  @override
  _UpdateEventFormState createState() => _UpdateEventFormState();
}

class _UpdateEventFormState extends State<UpdateEventForm> {
  late Event _event = Event.empty();
  late String _userRole;
  late bool _colorBlack = true;

  Future<void> fetchrole() async {
    String? userRole = await SecureStorage.getStorageItem('userRole');
    setState(() {
      _userRole = userRole!;
    });
    if (_userRole == 'admin') {
      _colorBlack = false;
    } else {
      _colorBlack = true;
    }
  }

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _dateController;
  late TextEditingController _participantNumberController;
  late TextEditingController _latController;
  late TextEditingController _lngController;
  late TextEditingController _locationController;
  late TextEditingController _tagController;
  late TextEditingController _placeController;

  File? _banner;
  File? _image;

  void pickBannerFile() async {
    final XFile? image = await pickImage();

    setState(() {
      if (image != null) {
        _banner = File(image.path);
      } else {
        log('No image selected.');
      }
    });
  }

  void pickImageFile() async {
    final XFile? image = await pickImage();

    setState(() {
      if (image != null) {
        _image = File(image.path);
      } else {
        log('No image selected.');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _dateController = TextEditingController();
    _participantNumberController = TextEditingController();
    _latController = TextEditingController();
    _lngController = TextEditingController();
    _locationController = TextEditingController();
    _tagController = TextEditingController();
    _placeController = TextEditingController();
    _fetchEventDetails();
    fetchrole();
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
          _participantNumberController.text =
              _event.participantNumber.toString();
          _latController.text = _event.lat.toString();
          _lngController.text = _event.lng.toString();
          _locationController.text = _event.location;
          _tagController.text = _event.tag;
          _placeController.text = _event.place;
        });
      }
    } catch (e) {
      // print("Error fetching event details: $e");
    }
  }

  void _updateEvent() async {
    try {
      if (_titleController.text.isEmpty ||
          _descriptionController.text.isEmpty ||
          _dateController.text.isEmpty ||
          _participantNumberController.text.isEmpty ||
          _latController.text.isEmpty ||
          _lngController.text.isEmpty ||
          _locationController.text.isEmpty ||
          _tagController.text.isEmpty ||
          _placeController.text.isEmpty) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Erreur"),
            content: const Text("Veuillez remplir tous les champs."),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
        return;
      }
      var formData = FormData.fromMap({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'date': _dateController.text,
        if (_banner != null)
          'banner': await MultipartFile.fromFile(_banner!.path),
        'participantNumber': int.parse(_participantNumberController.text),
        'lat': double.parse(_latController.text),
        'lng': double.parse(_lngController.text),
        'location': _locationController.text,
        'tag': _tagController.text,
        if (_image != null) 'image': await MultipartFile.fromFile(_image!.path),
        'place': _placeController.text,
      });
      var response =
          await ApiUtils.patchFormData('/event/${widget.eventId}', formData);

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
                style:
                    TextStyle(color: _colorBlack ? Colors.white : Colors.black),
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Titre",
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                style:
                    TextStyle(color: _colorBlack ? Colors.white : Colors.black),
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: "Description",
                ),
              ),
            ),
            _dateController.text.isEmpty
                ? const Text(
                    "Date (YYYY-MM-DD) :",
                    style: TextStyle(color: Colors.white),
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
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      pickBannerFile();
                    },
                    child: const Text('Choisir une nouvelle bannière'),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                style:
                    TextStyle(color: _colorBlack ? Colors.white : Colors.black),
                controller: _participantNumberController,
                decoration: const InputDecoration(
                  labelText: "Nombre de participants",
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                style:
                    TextStyle(color: _colorBlack ? Colors.white : Colors.black),
                controller: _latController,
                decoration: const InputDecoration(
                  labelText: "Latitude",
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                style:
                    TextStyle(color: _colorBlack ? Colors.white : Colors.black),
                controller: _lngController,
                decoration: const InputDecoration(
                  labelText: "Longitude",
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                style:
                    TextStyle(color: _colorBlack ? Colors.white : Colors.black),
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: "Location",
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                style:
                    TextStyle(color: _colorBlack ? Colors.white : Colors.black),
                controller: _tagController,
                decoration: const InputDecoration(
                  labelText: "Tag",
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      pickImageFile();
                    },
                    child: const Text('Choisir une nouvelle image'),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                style:
                    TextStyle(color: _colorBlack ? Colors.white : Colors.black),
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
