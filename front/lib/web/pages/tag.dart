import 'package:flutter/material.dart';
import 'package:mobile/mobile/services/api_tag_services.dart';
import 'package:mobile/web/ui/appbar.dart';
import 'package:mobile/mobile/models/tag.dart';

class TagPage extends StatefulWidget {
  const TagPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TagPageState createState() => _TagPageState();
}

class _TagPageState extends State<TagPage> {
  late Future<List<Tag>> futureTags;

  @override
  void initState() {
    super.initState();
    futureTags = TagServices.getTags();
  }

  Future<void> _refreshTags() async {
    setState(() {
      futureTags = TagServices.getTags();
    });
  }

  Future<void> _createTag(String name) async {
    var payload = {'name': name};

    await TagServices().postTag(payload);
    _refreshTags();
  }

  Future<void> _deleteTag(String id) async {
    await TagServices().deleteTag(id);
    _refreshTags();
  }

  void _showCreateTagDialog() {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Créer un nouveau tag'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Nom du tag'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                _createTag(controller.text);
                Navigator.of(context).pop();
              },
              child: const Text('Créer'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WebAppBar(),
      body: Column(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Liste des Tags',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Tag>>(
              future: futureTags,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erreur: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Aucun tag trouvé'));
                } else {
                  List<Tag> tags = snapshot.data!;
                  return ListView.builder(
                    itemCount: tags.length,
                    itemBuilder: (context, index) {
                      Tag tag = tags[index];
                      return ListTile(
                        title: Text(tag.name),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            _deleteTag(tag.id);
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateTagDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
