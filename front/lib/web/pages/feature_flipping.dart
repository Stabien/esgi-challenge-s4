import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:mobile/web/ui/appbar.dart';
import 'package:mobile/web/utils/api_utils.dart';

class FeatureFlippingPage extends StatefulWidget {
  const FeatureFlippingPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FeatureFlippingPageState createState() => _FeatureFlippingPageState();
}

class _FeatureFlippingPageState extends State<FeatureFlippingPage> {
  List<dynamic> _features = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchFeatures();
  }

  Future<void> _fetchFeatures() async {
    setState(() {
      _loading = true;
    });

    try {
      var response = await ApiUtils.get('/features');

      setState(() {
        _features = response.data;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      // print('Error fetching features: $e');
    }
  }

  Future<void> _updateFeature(String name, bool isEnabled) async {
    try {
      var response = await ApiUtils.patch(
          '/features',
          FormData.fromMap({
            'feature': name,
            'is_enabled': isEnabled.toString(),
          }));

      if (response.statusCode == 200) {
        setState(() {
          _features.firstWhere(
              (feature) => feature['Name'] == name)['IsEnabled'] = isEnabled;
        });
      } else {
        // print('Failed to update feature: ${response.statusCode}');
      }
    } catch (e) {
      // print('Error updating feature: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WebAppBar(),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: _features.length,
                  itemBuilder: (context, index) {
                    final feature = _features[index];
                    return ListTile(
                      title: Text(feature['Name']),
                      trailing: Switch(
                        value: feature['IsEnabled'],
                        onChanged: (bool value) {
                          _updateFeature(feature['Name'], value);
                        },
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
