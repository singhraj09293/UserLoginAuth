// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Login {
  final String uid;
  final String email;
  final String fullName;
  final String phone;
  final DateTime createdAt;

  Login({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.phone,
    required this.createdAt,
  });

  Login copyWith({
    String? uid,
    String? email,
    String? fullName,
    String? phone,
    DateTime? createdAt,
  }) {
    return Login(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'phone': phone,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory Login.fromMap(Map<String, dynamic> map) {
    return Login(
      uid: map['uid'] as String,
      email: map['email'] as String,
      fullName: map['fullName'] as String,
      phone: map['phone'] as String,
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Login.fromJson(String source) =>
      Login.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Login(uid: $uid, email: $email, fullName: $fullName, phone: $phone, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant Login other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.email == email &&
        other.fullName == fullName &&
        other.phone == phone &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        email.hashCode ^
        fullName.hashCode ^
        phone.hashCode ^
        createdAt.hashCode;
  }
}
