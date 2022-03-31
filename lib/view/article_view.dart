import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:markit_list/controllers/article_dialog.dart';
import 'package:markit_list/models/article_model.dart';
import 'package:markit_list/provider/article_provider.dart';
import 'package:markit_list/provider/liste_provider.dart';
import 'package:provider/provider.dart';

class ArticleView extends StatelessWidget {
  final Article article;
  const ArticleView({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(article.id.toString()),
      child: ListTile(
        title: Text(
          article.name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
        ),
        subtitle: Text('${article.price} Fcfa'),
        leading: const Icon(
          Icons.list,
          size: 30,
        ),
        trailing: IconButton(
          onPressed: () {
            article.isBuy = !article.isBuy;
            article.update();
            context.read<ArticleProvider>().notif();
            if (article.isBuy) {
              Fluttertoast.showToast(msg: "${article.name} achete");
            }
          },
          icon: article.isBuy
              ? const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                )
              : const Icon(
                  Icons.check_circle_outline,
                  color: Colors.grey,
                ),
        ),
        onLongPress: () {
          showDialog(
              context: context,
              builder: (_) => ArticleDialog(article: article));
        },
      ),
      onDismissed: (_) async {
        Fluttertoast.showToast(
            msg: 'La liste ${article.name} vient d\'etre supprime');
        article.delete();
        await context.read<ListeProvider>().updatePrice();
      },
    );
  }
}
