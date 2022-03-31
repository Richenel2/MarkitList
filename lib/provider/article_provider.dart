import 'package:flutter/material.dart';
import 'package:markit_list/models/article_model.dart';

class ArticleProvider extends ChangeNotifier {
  List<Article> _article = [];
  List<Article> get article => _article;

  void setArticle(List<Article> article, {bool notif = true}) {
    _article = article;
    notifyListeners();
  }

  void notif() {
    notifyListeners();
  }

  Future finish() async {
    for (int i = 0; i < _article.length; i++) {
      _article[i].isBuy = true;
      await _article[i].update();
    }
    notifyListeners();
  }
}
