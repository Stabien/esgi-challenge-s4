import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile/models/event.dart';
import 'package:mobile/models/eventDetail.dart';
import 'package:mobile/services/api_event_services.dart';
import 'package:mobile/services/api_reservation_services.dart';


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

  @override
  void initState() {
    super.initState();
    _fetchEvents();

    setState(() {
      _loading = true;
    });

  }

void _fetchEvents() {
    
  ApiServices.getEventDetail(widget.id).then((data) {
    setState(() {
      _error = null;
      _eventdetails = [data]; // Ajoutez les données dans une liste
      _loading = false;
    });
  }).catchError((error) {
    setState(() {
      _error = error;
      _loading = false;
    });
  });
  

  ApiReservation.isreserv(widget.id, "3e8aa051-4321-49a0-8bc1-f697585756a4").then((data){
    print(data);
    setState(() {
      if(data.isEmpty){
        _isReserv = false;
        _textReserv = "Reserver";
      }else{
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

void _updateReservationStatus() {
  setState(() {
    _isReserv = !_isReserv; 
    _textReserv = _isReserv ? "Annuler" : "Reserver";
  });
}
    

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
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
                return Column(
                  children: [
                    Image.network(
                      eventDetail.banner,
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
                            const Text(
                              "Par recupe l'organisateur",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                 eventDetail.placerestante.toString(),
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
                        Text(eventDetail.description,
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
                                eventDetail.date,
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
                                width: 1, // Épaisseur de la bordure
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
                                width: 1, // Épaisseur de la bordure
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
                         ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Go back'),
                        ),
                         ElevatedButton(
                          onPressed: () {
                            if(!_isReserv && eventDetail.placerestante > 0){
                              ApiReservation.reserveEvent(eventDetail.id,"3e8aa051-4321-49a0-8bc1-f697585756a4");
                              _updateReservationStatus();
                              print(_textReserv);
                              _fetchEvents();

                            }else if(_isReserv && eventDetail.placerestante <= 0){

                            }else{
                              ApiReservation.cancelReservation(eventDetail.id,"3e8aa051-4321-49a0-8bc1-f697585756a4");
                              _updateReservationStatus();
                              print(_textReserv);
                              _fetchEvents();
                              
                            }
                          },
                          child: Text(_textReserv),

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
      ),
    );
  }
}