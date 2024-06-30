import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class EventMap extends StatefulWidget {
  final double lat;
  final double lng;
  const EventMap({super.key, required this.lat, required this.lng});

  @override
  State<EventMap> createState() => _EventMapState();
}

class _EventMapState extends State<EventMap> {
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
  }

  Future<void> printLocation() async {
    bool isAllowed = await _checkPermission();

    if (!isAllowed) {
      print('----------Permission denied----------');
      return;
    } else {
      print('----------Permission granted----------');
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      print(position);
      setState(() {
        _currentPosition = position;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Localisation de l\'événement'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('----------Geolocate user----------');
          printLocation();
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.location_searching),
      ),
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
          MarkerLayer(
            markers: [
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
              if (_currentPosition != null)
                Marker(
                  width: 80.0,
                  height: 80.0,
                  point: LatLng(
                    _currentPosition!.latitude,
                    _currentPosition!.longitude,
                  ),
                  child: const Icon(
                    Icons.my_location,
                    color: Colors.blue,
                    size: 50.0,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<bool> _checkPermission() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return false;
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return false;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return false;
  }

  return true;
}
