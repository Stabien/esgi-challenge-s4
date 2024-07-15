import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/mobile/models/eventDetail.dart';
import 'package:mobile/mobile/services/api_event_services.dart';
import 'package:mobile/mobile/services/api_reservation_services.dart';
import 'package:mobile/mobile/services/formatDate.dart';
import 'package:mobile/mobile/utils/secureStorage.dart';
import 'package:flutter/services.dart';

class DetailScreen extends StatefulWidget {
  final String id;
  const DetailScreen({super.key, required this.id});

  @override
  State<DetailScreen> createState() => _DetailScreen();
}

class _DetailScreen extends State<DetailScreen> {
  List<EventDetail> _eventdetails = [];

  bool _loading = false;
  Error? _error;
  bool _isReserv = false;
  String _textReserv = "";
  String _userId = "";
  String _userRole = "";

  Future<void> initUser() async {
    await SecureStorage.getStorageItem('userId').then((value) {
      _userId = value!;
      _fetchEvents();
    });

    await SecureStorage.getStorageItem('userRole').then((value) {
      _userRole = value!;
    });
  }

  @override
  void initState() {
    super.initState();
    initUser();

    _fetchEvents();

    setState(() {
      _loading = true;
    });
  }

  void _fetchEvents() {
    ApiServices.getEventDetail(widget.id).then((data) {
      setState(() {
        _error = null;
        _eventdetails = [data];
        _loading = false;
      });
    }).catchError((error) {
      setState(() {
        _error = error;
        _loading = false;
      });
    });

    _updateReservationStatus();
  }

  void _updateReservationStatus() {
    print('update reservation status');
    ApiReservation.isreserv(widget.id, _userId).then((data) {
      setState(() {
        if (data.isEmpty) {
          _isReserv = false;
          _textReserv = "Reserver";
        } else {
          _isReserv = true;
          _textReserv = "Annuler";
        }
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détail de l\'événement'),
      ),
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
              final eventDetail = _eventdetails[index];
              return Column(
                children: [
                  Image.memory(
                    base64Decode(eventDetail.image),
                    width: double.infinity,
                    height: 200,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          eventDetail.title,
                          style: const TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "Il reste : ${eventDetail.placerestante} places",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          eventDetail.description,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.date_range,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 15),
                              Text(
                                transformerDate(eventDetail.date),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Text(
                                  eventDetail.location,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.home,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Text(
                                  eventDetail.place,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 100),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed('/event/map', arguments: [
                                  eventDetail.lat,
                                  eventDetail.lng,
                                ]);
                              },
                              child: const Text('Voir la map'),
                            ),
                            _userRole == 'organizer'
                                ? ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.black,
                                      backgroundColor: Colors.white,
                                    ),
                                    onPressed: () async {
                                      await Clipboard.setData(
                                        ClipboardData(text: eventDetail.code),
                                      );
                                    },
                                    child: const Text('Copier le code'),
                                  )
                                : ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.black,
                                      backgroundColor: Colors.white,
                                    ),
                                    onPressed: () async {
                                      if (!_isReserv &&
                                          eventDetail.placerestante > 0) {
                                        await ApiReservation.reserveEvent(
                                            eventDetail.id, _userId);
                                        _updateReservationStatus();
                                        _fetchEvents();
                                      } else if (_isReserv &&
                                          eventDetail.placerestante <= 0) {
                                      } else {
                                        await ApiReservation.cancelReservation(
                                            eventDetail.id, _userId);
                                        _updateReservationStatus();
                                        _fetchEvents();
                                      }
                                    },
                                    child: Text(
                                      _textReserv,
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
            itemCount: _eventdetails.length,
          );
        }
      }),
    );
  }
}
