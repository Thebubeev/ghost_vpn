import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserField {
  static final String lastCreationTime = 'lastCreationTime';
}

class FirestoreUser extends Equatable {
  final String idUser;
  final String email;
  final bool isPaid;
  final bool isPromo;
  final DateTime lastCreationTime;
  FirestoreUser(
      {this.idUser,
      this.email,
      this.isPaid,
      this.isPromo,
      this.lastCreationTime});

  static FirestoreUser fromJson(DocumentSnapshot snapshot) {
    FirestoreUser firestoreUser = FirestoreUser(
        idUser: snapshot['idUser'],
        email: snapshot['email'],
        isPaid: snapshot['isPaid'],
        isPromo: snapshot['isPromo'],
        lastCreationTime: Utils.toDateTime(snapshot['lastCreationTime']));
    return firestoreUser;
  }

  Map<String, Object> toMap() {
    return {
      'idUser': idUser,
      'email': email,
      'isPaid': isPaid,
      'isPromo': isPromo,
      'lastCreationTime': Utils.fromDateTimeToJson(lastCreationTime),
    };
  }

  @override
  List<Object> get props => [idUser, email, lastCreationTime];
}

class Utils {
  static DateTime toDateTime(Timestamp value) {
    if (value == null) return null;

    return value.toDate();
  }

  static dynamic fromDateTimeToJson(DateTime date) {
    if (date == null) return null;

    return date.toUtc();
  }
}
