import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Contact.dart';
import 'ContactState.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  final textFieldNameController = TextEditingController();
  final textFieldPhoneNumberController = TextEditingController();
  List<Contact> contact_lists = [];

  @override
  void initState() {
    // TODO: implement initState

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   getContacts();
    // });
    // setState(() async {
    //   final SharedPreferences preferences = await prefs;
    //   final String? contactsString = await preferences.getString('contact');
    //   contact_lists = jsonDecode(contactsString!) as List<Contact>;
    // });
    getContacts();
    super.initState();
  }

  getContacts() async {
    final SharedPreferences preferences = await prefs;
    final String? contactsString = await preferences.getString('contact');
    print(contactsString);

    if (contactsString != null) {
      setState(() {
        contact_lists = Contact.decode(contactsString);
      });
    } else {
      contact_lists = [];
    }
  }

  @override
  void dispose() {
    textFieldNameController.dispose();
    textFieldPhoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ContactState>(
      create: (context) => ContactState(),
      child: Consumer<ContactState>(
        builder: ((context, value, _) => SafeArea(
              child: Scaffold(
                  body: Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            left: 8.0, right: 8.0, bottom: 8.0, top: 50),
                        child: TextFormField(
                          controller: textFieldNameController,
                          decoration: InputDecoration(
                              suffixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(),
                              hintText: 'Enter name'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 8.0, right: 8.0, bottom: 8.0, top: 8.0),
                        child: TextFormField(
                          controller: textFieldPhoneNumberController,
                          decoration: InputDecoration(
                              suffixIcon: Icon(Icons.phone),
                              border: OutlineInputBorder(),
                              hintText: 'Enter phone number'),
                        ),
                      ),
                      ElevatedButton(
                          onPressed: (() async {
                            String name = textFieldNameController.text;
                            String phoneNumber =
                                textFieldPhoneNumberController.text;
                            Contact newContact =
                                Contact(name: name, phoneNumber: phoneNumber);
                            setState(() {
                              contact_lists.add(newContact);
                              print(contact_lists);
                            });

                            final String encodedData =
                                Contact.encode(contact_lists);
                            final SharedPreferences sharedpreferences =
                                await prefs;
                            await sharedpreferences.setString(
                                'contact', encodedData);
                          }),
                          child: const Text("Add")),
                      SizedBox(
                        height: 500,
                        child: ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: contact_lists.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                key: UniqueKey(),
                                height: 50,
                                child: Center(
                                    child: Text(
                                        'Name: ${contact_lists[index].name} Phone Number ${contact_lists[index].phoneNumber}')),
                              );
                            }),
                      )
                    ],
                  ),
                ),
              )),
            )),
      ),
    );
  }
}
