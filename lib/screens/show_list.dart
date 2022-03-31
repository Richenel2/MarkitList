import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:markit_list/constante/constante.dart';
import 'package:markit_list/controllers/article_dialog.dart';
import 'package:markit_list/database/database.dart';
import 'package:markit_list/models/article_model.dart';
import 'package:markit_list/models/liste_model.dart';
import 'package:markit_list/provider/article_provider.dart';
import 'package:markit_list/provider/liste_provider.dart';
import 'package:markit_list/view/article_view.dart';
import 'package:provider/provider.dart';

class ShowListeDetails extends StatelessWidget {
  const ShowListeDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Liste liste = context.watch<ListeProvider>().listeItem;
    return Scaffold(
      appBar: AppBar(
        title: Text(liste.name),
        actions: [
          IconButton(
              onPressed: () {
                liste.isImportant = !liste.isImportant;
                context.read<ListeProvider>().update();
              },
              icon: Icon(liste.isImportant ? Icons.star : Icons.star_border)),
          IconButton(
            onPressed: () {
              liste.isFinish = !liste.isFinish;
              context.read<ListeProvider>().update();
              context.read<ArticleProvider>().finish();
              if (liste.isFinish) {
                Fluttertoast.showToast(msg: "Liste ${liste.name} termine");
              }
            },
            icon: liste.isFinish
                ? const Icon(
                    Icons.check_circle,
                  )
                : const Icon(
                    Icons.check_circle_outline,
                  ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: MyDatabase.instance.getArticle(liste.id!).then((value) {
          context.read<ArticleProvider>().setArticle(value);
          return value;
        }),
        builder: (context, AsyncSnapshot<List<Article>> snapshot) {
          if (!snapshot.hasData) {
            return const SpinKitFadingFour(
              color: MyColor.primaryRed,
            );
          }
          return context.watch<ArticleProvider>().article.isEmpty
              ? const Center(
                  child: Text('Aucun article pour cette liste'),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 60),
                  itemBuilder: (context, index) => ArticleView(
                      article: context.watch<ArticleProvider>().article[index]),
                  itemCount: context.watch<ArticleProvider>().article.length,
                );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total:',
                style: TextStyle(fontSize: 20),
              ),
              RichText(
                  text: TextSpan(
                      text: '${liste.price}',
                      style: const TextStyle(
                          color: MyColor.primaryRed, fontSize: 20),
                      children: const [
                    TextSpan(
                        text: ' Fcfa',
                        style: TextStyle(color: Colors.black, fontSize: 16))
                  ]))
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (() {
          showDialog(
              context: context, builder: (_) => ArticleDialog(liste: liste));
        }),
        child: const Icon(Icons.add),
      ),
    );
  }
}
