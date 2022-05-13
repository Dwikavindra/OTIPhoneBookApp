import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactState with ChangeNotifier {
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  List<String> _lists = [''];
  void lists(String newcontent) {
    _lists.add(newcontent);
    notifyListeners();
  }

  List<String> get list => _lists;
}
