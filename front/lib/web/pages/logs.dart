import 'package:flutter/material.dart';
import 'package:mobile/web/ui/appbar.dart';
import 'package:mobile/web/utils/api_utils.dart';

class LogsPage extends StatefulWidget {
  const LogsPage({super.key});

  @override
  State<LogsPage> createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
  List<String> logs = [];

  @override
  void initState() {
    super.initState();
    fetchLogs();
  }

  void fetchLogs() async {
    var response = await ApiUtils.get('/logs');

    if (response.statusCode == 200) {
      setState(() {
        var data = response.data.toString();
        logs = data.substring(1, data.length - 1).split(',');
      });
    } else {
      print('Failed to load logs');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WebAppBar(),
      body: FractionallySizedBox(
        widthFactor: 0.8,
        child: ListView.builder(
          itemCount: logs.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                logs[index],
              ),
            );
          },
        ),
      ),
    );
  }
}
