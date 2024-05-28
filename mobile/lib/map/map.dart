import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class EventMap extends StatefulWidget {
  final double lat;
  final double lng;
  const EventMap({super.key, required this.lat, required this.lng});

  @override
  State<EventMap> createState() => _EventMap();
}

class _EventMap extends State<EventMap> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Localisation de l\'événement'),
      ),
      backgroundColor: Colors.black,
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(widget.lat, widget.lng),
          initialZoom: 17.0,
          maxZoom: 20.0,
          minZoom: 3.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'dev.fleaflet.flutter_map.example',
          ),
          MarkerLayer(markers: [
            Marker(
              width: 80.0,
              height: 80.0,
              point: LatLng(widget.lat, widget.lng),
              child: const Icon(
                Icons.location_on,
                color: Colors.red,
                size: 50.0,
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
