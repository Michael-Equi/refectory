import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final Timestamp lastActivity;
  final List<String> cafeterias;
  final String uid;

  User({this.lastActivity, this.cafeterias, this.uid});

  factory User.fromMap(Map data) {
    return User(
      lastActivity: data['lastActivity'] ?? '',
      cafeterias: data['cafeterias'].cast<String>() ?? '',
      uid: data['uid'] ?? '',
    );
  }
}

class Cafeteria {
  final String iconUrl;
  final String name;
  final String uid;

  Cafeteria({this.iconUrl, this.name, this.uid});

  factory Cafeteria.fromMap(Map data) {
    return Cafeteria(
      iconUrl: data['iconUrl'] ?? '',
      name: data['name'] ?? '',
      uid: data['uid'] ?? '',
    );
  }
}
