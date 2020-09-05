import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final Timestamp lastActivity;
  final List<String> cafeterias;
  final String uid;
  final String email;
  final String name;

  User({this.lastActivity, this.cafeterias, this.uid, this.email, this.name});

  factory User.fromMap(Map data) {
    return User(
        lastActivity: data['lastActivity'] ?? '',
        cafeterias: data['cafeterias'].cast<String>() ?? '',
        uid: data['uid'] ?? '',
        email: data['email'] ?? '',
        name: data['name'] ?? '');
  }
}

class Cafeteria {
  final String iconUrl;
  final String name;
  final String uid;
  final String ownerId;
  final String admin;

  Cafeteria({this.iconUrl, this.name, this.uid, this.ownerId, this.admin});

  factory Cafeteria.fromMap(Map data) {
    return Cafeteria(
      iconUrl: data['iconUrl'] ?? '',
      name: data['name'] ?? '',
      uid: data['uid'] ?? '',
      ownerId: data['ownerId'] ?? '',
      admin: data['admin'] ?? '',
    );
  }
}

class MealDoc {
  final String iconUrl;
  final String name;
  final String uid;
  final bool isVegan;
  final String meal; //breakfast, brunch, lunch, dinner
  final Map<dynamic, dynamic> ratings;
  final List<dynamic> savers;

  MealDoc(
      {this.iconUrl,
      this.name,
      this.uid,
      this.isVegan,
      this.meal,
      this.ratings,
      this.savers});

  factory MealDoc.fromMap(Map data) {
    return MealDoc(
      iconUrl: data['iconUrl'] ?? '',
      name: data['name'] ?? '',
      uid: data['uid'] ?? '',
      isVegan: data['isVegan'] ?? '',
      meal: data['meal'] ?? '',
      ratings: data['ratings'] ?? {},
      savers: data['savers'] ?? [],
    );
  }
}
