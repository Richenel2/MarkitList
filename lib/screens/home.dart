import 'package:flutter/material.dart';
import 'package:markit_list/database/database.dart';
import 'package:markit_list/provider/liste_provider.dart';
import 'package:markit_list/view/liste_view.dart';
import 'package:provider/provider.dart';

import '../controllers/liste_dialog.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "MarkitList",
          style: TextStyle(fontSize: 23),
        ),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.menu),
            onSelected: (value) async {
              context
                  .read<ListeProvider>()
                  .setListe(await MyDatabase.instance.getListe(trie: '$value ,'));
            },
            itemBuilder: (_) => <PopupMenuEntry>[
              const PopupMenuItem(
                value: 'name ASC',
                child: Text('Trier par nom'),
              ),
              const PopupMenuItem(
                value: 'price Desc',
                child: Text('Trier par prix'),
              ),
              const PopupMenuItem(
                value: 'isFinish Desc',
                child: Text('Trier par liste terminee'),
              ),
              const PopupMenuItem(
                value: 'isImportant Desc',
                child: Text('Trier par liste important'),
              ),
            ],
          )
        ],
      ),
      body: context.watch<ListeProvider>().liste.isEmpty
          ? const Center(
              child: Text('Aucune liste pour l\'instant'),
            )
          : ListView.builder(
              itemBuilder: (context, index) =>
                  ListeView(liste: context.watch<ListeProvider>().liste[index]),
              itemCount: context.watch<ListeProvider>().liste.length,
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(context: context, builder: (_) => const ListeDialog());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
