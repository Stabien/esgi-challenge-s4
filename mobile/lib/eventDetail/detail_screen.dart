import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile/models/eventDetail.dart';
import 'package:mobile/services/api_event_services.dart';

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

  @override
  void initState() {
    super.initState();

    setState(() {
      _loading = true;
    });
    

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
                        const Row(
                          children: [
                            Text(
                              "Par recupe l'organisateur",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                                "Il reste nbplace ",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
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
                        Row(
                          children: [
                            const Icon(
                              Icons.date_range,
                              color: Colors.grey,
                            ),
                            Text(
                              eventDetail.date,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.grey,
                            ),
                            Text(
                              eventDetail.location,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(
                              Icons.home,
                              color: Colors.grey,
                            ),
                            Text(
                              eventDetail.place,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                          
                        ),
                         ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Go back'),
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