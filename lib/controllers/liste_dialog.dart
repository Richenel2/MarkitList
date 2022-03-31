import 'package:flutter/material.dart';
import 'package:markit_list/database/database.dart';
import 'package:markit_list/models/liste_model.dart';
import 'package:markit_list/provider/liste_provider.dart';
import 'package:provider/provider.dart';

class ListeDialog extends StatefulWidget {
  const ListeDialog({
    Key? key,
  }) : super(key: key);

  @override
  State<ListeDialog> createState() => _ListeDialogState();
}

class _ListeDialogState extends State<ListeDialog>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation<double>? scaleAnimation;
  final key = GlobalKey<FormState>();
  TextEditingController inputController = TextEditingController();

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller!, curve: Curves.elasticInOut);

    controller!.addListener(() {
      setState(() {});
    });

    controller!.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation!,
          child: Container(
              margin: const EdgeInsets.all(20.0),
              padding: const EdgeInsets.all(15.0),
              height: 180.0,
              decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Creer une Nouvelle liste'),
                  Form(
                    key: key,
                    child: TextFormField(
                      controller: inputController,
                      decoration:
                          const InputDecoration(labelText: 'Nom de la liste'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Veillez entrer un nom';
                        }
                        return null;
                      },
                    ),
                  ),
                  TextButton(
                      onPressed: () async {
                        if (key.currentState!.validate()) {
                          Liste liste = Liste(name: inputController.text);
                          await liste.save();
                          
                          MyDatabase.instance.getListe().then((value) =>
                              Provider.of<ListeProvider>(context, listen: false)
                                  .setListe(value));
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Valider'))
                ],
              )),
        ),
      ),
    );
  }
}
