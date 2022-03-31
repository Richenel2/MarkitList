import 'package:flutter/material.dart';
import 'package:markit_list/models/liste_model.dart';

class ListeProvider extends ChangeNotifier {
  List<Liste> _liste = [];
  Liste _listeItem = Liste(name: "");
  List<Liste> get liste => _liste;

  Liste get listeItem => _listeItem;

  void setListe(List<Liste> liste) {
    _liste = liste;
    notifyListeners();
  }

  void setListeItem(Liste listeItem) {
    _listeItem = listeItem;
    notifyListeners();
  }

  Future updatePrice() async {
    await _listeItem.updatePrice();
    notifyListeners();
  }

  void update() {
    _listeItem.update();
    notifyListeners();
  }
}
