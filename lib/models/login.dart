// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Login {
  final String uid;
  final String email;
  final String fullName;
  final String phone;

  Login({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.phone,
  });

  Login copyWith({
    String? uid,
    String? email,
    String? fullName,
    String? phone,
  }) {
    return Login(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'phone': phone,
    };
  }

  factory Login.fromMap(Map<String, dynamic> map) {
    return Login(
      uid: map['uid'] as String,
      email: map['email'] as String,
      fullName: map['fullName'] as String,
      phone: map['phone'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Login.fromJson(String source) => Login.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Login(uid: $uid, email: $email, fullName: $fullName, phone: $phone)';
  }

  @override
  bool operator ==(covariant Login other) {
    if (identical(this, other)) return true;
  
    return 
      other.uid == uid &&
      other.email == email &&
      other.fullName == fullName &&
      other.phone == phone;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
      email.hashCode ^
      fullName.hashCode ^
      phone.hashCode;
  }
}
