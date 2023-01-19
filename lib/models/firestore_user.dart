import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserField {
  static final String lastCreationTime = 'lastCreationTime';
}


class FirestoreUser extends Equatable {
  final String idUser;
  final String email;
  final String isPromo;
  final DateTime? lastCreationTime;
  FirestoreUser(
      {required this.idUser,
    required  this.email,
    required  this.isPromo,
    required  this.lastCreationTime});

  static FirestoreUser fromJson(DocumentSnapshot snapshot) {
    FirestoreUser firestoreUser = FirestoreUser(
        idUser: snapshot['idUser'],
        email: snapshot['email'],
        isPromo: snapshot['isPromo'],
        lastCreationTime: Utils.toDateTime(snapshot['lastCreationTime']));
    return firestoreUser;
  }

  Map<String, Object> toMap() {
    return {
      'idUser': idUser,
      'email': email,
      'isPromo': isPromo,
      'lastCreationTime': Utils.fromDateTimeToJson(lastCreationTime),
    };
  }

  @override
  List<Object> get props => [idUser, email, lastCreationTime as Object];
}

class Utils {
  static DateTime? toDateTime(Timestamp? value) {
    if (value == null) return null;

    return value.toDate();
  }

  static dynamic fromDateTimeToJson(DateTime? date) {
    if (date == null) return null;

    return date.toUtc();
  }
}
