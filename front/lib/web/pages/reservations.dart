import 'package:flutter/material.dart';
import 'package:mobile/web/ui/appbar.dart';
import 'package:mobile/web/utils/api_utils.dart';

class ReservationsPage extends StatefulWidget {
  const ReservationsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ReservationsPageState createState() => _ReservationsPageState();
}

class _ReservationsPageState extends State<ReservationsPage> {
  List<dynamic> reservations = [];

  @override
  void initState() {
    super.initState();
    fetchReservations();
  }

  Future<void> fetchReservations() async {
    var response = await ApiUtils.get("/reservations");
    if (response.statusCode == 200) {
      setState(() {
        reservations = response.data;
      });
    } else {
      // print('Failed to fetch reservations: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WebAppBar(),
      body: Center(
        child: reservations.isEmpty
            ? const CircularProgressIndicator()
            : ListView.builder(
                itemCount: reservations.length,
                itemBuilder: (context, index) {
                  final reservation = reservations[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(
                            "Titre de l'événement : ${reservation['Event']['Title']}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Réservation ID: ${reservation['ID']}',
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                              // const Spacer(),
                              reservation['Customer'] != null
                                  ? Row(
                                      children: [
                                        Text(
                                          'Client ID: ${reservation['CustomerID']}',
                                          style: TextStyle(
                                              color: Colors.grey[700]),
                                        ),
                                        const Text(" / "),
                                        Text(
                                          'Nom: ${reservation['Customer']['Firstname']} ${reservation['Customer']['Lastname']}',
                                          style: TextStyle(
                                              color: Colors.grey[700]),
                                        ),
                                      ],
                                    )
                                  : Container(),
                              // const Spacer(),
                              Text(
                                'Réservation faite le : ${reservation['CreatedAt']}',
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
