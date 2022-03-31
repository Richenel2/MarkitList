import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:markit_list/database/database.dart';
import 'package:markit_list/models/article_model.dart';
import 'package:markit_list/models/liste_model.dart';
import 'package:markit_list/provider/article_provider.dart';
import 'package:markit_list/provider/liste_provider.dart';
import 'package:provider/provider.dart';

class ArticleDialog extends StatefulWidget {
  final Liste? liste;
  final Article? article;
  const ArticleDialog({Key? key, this.liste, this.article}) : super(key: key);

  @override
  State<ArticleDialog> createState() => _ArticleDialogState();
}

class _ArticleDialogState extends State<ArticleDialog>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation<double>? scaleAnimation;
  final key = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController qte = TextEditingController();

  @override
  void initState() {
    name.text = (widget().article == null ? "" : widget().article!.name);
    price.text =
        widget().article == null ? "" : widget().article!.price.toString();
    qte.text =
        widget().article == null ? "" : widget().article!.amount.toString();

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
              height: 300.0,
              decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Ajouter un article a'),
                  Form(
                    key: key,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: name,
                          decoration: const InputDecoration(
                              labelText: 'Nom de l\'article'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Veillez entrer un nom';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: price,
                          decoration: const InputDecoration(
                              labelText: 'Nom de le prix'),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'veillez saisir une valeur';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: qte,
                          decoration:
                              const InputDecoration(labelText: 'Nom de la qte'),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                      onPressed: () async {
                        if (key.currentState!.validate()) {
                          if (widget().article == null) {
                            Article article = Article(
                                name: name.text,
                                liste: widget().liste!.id!,
                                price: int.parse(price.text),
                                amount:
                                    qte.text.isEmpty ? 0 : int.parse(qte.text));
                            await article.save();
                            await Provider.of<ListeProvider>(context,
                                    listen: false)
                                .updatePrice();
                            MyDatabase.instance
                                .getArticle(widget().liste!.id!)
                                .then((value) => Provider.of<ArticleProvider>(
                                        context,
                                        listen: false)
                                    .setArticle(value));
                          } else {
                            widget().article!.name = name.text;
                            widget().article!.price = int.parse(price.text);
                            widget().article!.amount =
                                qte.text.isEmpty ? 0 : int.parse(qte.text);
                            widget().article!.update();
                            Provider.of<ArticleProvider>(context, listen: false)
                                .notif();
                            await Provider.of<ListeProvider>(context,
                                    listen: false)
                                .updatePrice();
                          }
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
