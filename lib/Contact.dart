import 'dart:convert';

class Contact {
  final String name;
  final String phoneNumber;

  Contact({required this.name, required this.phoneNumber});

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(name: json['name'], phoneNumber: json['phoneNumber']);
  }

  static Map<String, dynamic> toJson(contact) => {
        'name': contact.name,
        'phoneNumber': contact.phoneNumber,
      };

  static String encode(List<Contact> contacts) => json.encode(
        contacts
            .map<Map<String, dynamic>>((contacts) => Contact.toJson(contacts))
            .toList(),
      );

  static List<Contact> decode(String contact) =>
      (jsonDecode(contact) as List<dynamic>)
          .map<Contact>((item) => Contact.fromJson(item))
          .toList();
}
