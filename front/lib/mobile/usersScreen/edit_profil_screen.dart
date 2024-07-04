import 'package:flutter/material.dart';
import 'package:mobile/mobile/models/profil.dart';
import 'package:mobile/mobile/utils/secureStorage.dart';
import 'package:mobile/mobile/services/userServices.dart';

class EditProfilePage extends StatefulWidget {
  final Profil userProfile;

  const EditProfilePage({super.key, required this.userProfile});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _lastnameController;
  late TextEditingController _emailController;
  late TextEditingController _firstnameController;

  String _userId = "";
  String _role = "";

  @override
  void initState() {
    super.initState();
    _lastnameController =
        TextEditingController(text: widget.userProfile.lastname);
    _emailController = TextEditingController(text: widget.userProfile.email);
    _firstnameController =
        TextEditingController(text: widget.userProfile.firstname);
    initUser();
  }

  @override
  void dispose() {
    _lastnameController.dispose();
    _emailController.dispose();
    _firstnameController.dispose();
    super.dispose();
  }

  Future<void> initUser() async {
    _userId = await SecureStorage.getStorageItem('userId') ?? "";
    _role = await SecureStorage.getStorageItem('userRole') ?? "";
  }

  void _saveProfile() {
    setState(() {
      widget.userProfile.lastname = _lastnameController.text;
      widget.userProfile.email = _emailController.text;
      widget.userProfile.firstname = _firstnameController.text;
    });
    updateBDD();
    Navigator.pop(context);
  }

  void updateBDD() {
    try {
      if (_role == "organizer") {
        UserServices().patchProfilOrga(_userId, widget.userProfile);
      } else {
        UserServices().patchProfilCusto(_userId, widget.userProfile);
      }
    } catch (error) {
      print('Unknown error in updateBDD: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier le profil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _lastnameController,
              decoration: const InputDecoration(labelText: 'Nom'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _firstnameController,
              decoration: const InputDecoration(labelText: 'Prénom'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProfile,
              child: const Text('Sauvegarder'),
            ),
          ],
        ),
      ),
    );
  }
}
