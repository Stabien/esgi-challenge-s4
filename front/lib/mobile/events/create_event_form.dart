// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/mobile/utils/file.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:mobile/web/utils/api_utils.dart';

class CreateEventForm extends StatefulWidget {
  const CreateEventForm({super.key});

  @override
  _CreateEventFormState createState() => _CreateEventFormState();
}

class _CreateEventFormState extends State<CreateEventForm> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _participantNumberController =
      TextEditingController();
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lngController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();

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

  void createEvent() async {
    log(_participantNumberController.text);

    try {
      var formData = FormData.fromMap({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'date': _dateController.text,
        'banner': await MultipartFile.fromFile(_banner!.path),
        'participantNumber': _participantNumberController.text,
        'lat': double.parse(_latController.text),
        'lng': double.parse(_lngController.text),
        'location': _locationController.text,
        'tag': _tagController.text,
        'image': await MultipartFile.fromFile(_image!.path),
        'place': _placeController.text,
      });

      var response = await ApiUtils.post('/event', formData);

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Succès"),
            content: Text("Événement créé avec succès."),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Erreur"),
          content: Text("Erreur lors de la création de l'événement. $e"),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
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
        title: Text("Créer un événement"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                style: TextStyle(color: Colors.white),
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: "Titre",
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                style: TextStyle(color: Colors.white),
                controller: _descriptionController,
                decoration: InputDecoration(
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
                    child: Text('Choisir une bannière'),
                  ),
                  Spacer(),
                  Text(_banner?.path.split('/').last ?? "")
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                style: TextStyle(color: Colors.white),
                controller: _participantNumberController,
                decoration: InputDecoration(
                  labelText: "Nombre de participants",
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                style: TextStyle(color: Colors.white),
                controller: _latController,
                decoration: InputDecoration(
                  labelText: "Latitude",
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                style: TextStyle(color: Colors.white),
                controller: _lngController,
                decoration: InputDecoration(
                  labelText: "Longitude",
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                style: TextStyle(color: Colors.white),
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: "Location",
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                style: TextStyle(color: Colors.white),
                controller: _tagController,
                decoration: InputDecoration(
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
                    child: Text('Choisir une image'),
                  ),
                  Spacer(),
                  Text(_image?.path.split('/').last ?? "")
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                style: TextStyle(color: Colors.white),
                controller: _placeController,
                decoration: InputDecoration(
                  labelText: "Place",
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: createEvent,
              child: Text("Créer Événement"),
            ),
          ],
        ),
      ),
    );
  }
}
