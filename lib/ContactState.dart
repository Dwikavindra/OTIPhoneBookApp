import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Contact.dart';

class ContactState with ChangeNotifier {
  List<Contact> _lists = [];
  List<Contact> _temporaryLists = [];
  ContactState() {
    getContacts();
  }

  Future<void> getContacts() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final String? contactsString = await sharedPreferences.getString('contact');
    _lists =
        contactsString != null ? Contact.decode(contactsString) : _lists = [];
    notifyListeners();
  }

  void addLists(Contact newContact) async {
    _lists.add(newContact);
    final encodedData = Contact.encode(_lists);
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('contact', encodedData);
    notifyListeners();
  }

  List<Contact> get list => _lists;
  List<Contact> get temporaryLists => _temporaryLists;

  void filterList(String search) {
    final searchValue = search;
    if (double.tryParse(searchValue) == null) {
      _temporaryLists = list
          .where((value) =>
              value.name.toLowerCase().contains(search.toLowerCase()))
          .toList();
    } else {
      _temporaryLists = list
          .where((value) =>
              value.phoneNumber.toLowerCase().contains(search.toLowerCase()))
          .toList();
    }

    notifyListeners();
  }
}
