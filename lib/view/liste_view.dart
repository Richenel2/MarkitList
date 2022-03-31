import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:markit_list/constante/constante.dart';
import 'package:markit_list/models/liste_model.dart';
import 'package:markit_list/provider/liste_provider.dart';
import 'package:markit_list/screens/show_list.dart';
import 'package:provider/provider.dart';

class ListeView extends StatelessWidget {
  final Liste liste;
  const ListeView({Key? key, required this.liste}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(liste.id.toString()),
      child: ListTile(
        title: Text(
          liste.name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
        ),
        subtitle: Text('${liste.price} Fcfa'),
        trailing: Column(
          children: [
            Text(formatDate(liste.creationDate!, [dd, '/', mm, '/', yyyy])
                .toString()),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                liste.isImportant
                    ? const Icon(
                        Icons.star,
                        color: MyColor.primaryRed,
                        size: 15,
                      )
                    : const Icon(
                        Icons.star_border,
                        size: 15,
                      ),
                liste.isFinish
                    ? const Icon(
                        Icons.check_circle,
                        color: MyColor.primaryRed,
                        size: 15,
                      )
                    : const Icon(
                        Icons.check_circle_outline,
                        size: 15,
                      ),
              ],
            )
          ],
        ),
        leading: const Icon(
          Icons.app_registration,
          size: 30,
        ),
        onTap: () {
          context.read<ListeProvider>().setListeItem(liste);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ShowListeDetails()),
          );
        },
      ),
      onDismissed: (_) {
        Fluttertoast.showToast(
            msg: 'La liste ${liste.name} vient d\'etre supprime');
        liste.delete();
      },
    );
  }
}
