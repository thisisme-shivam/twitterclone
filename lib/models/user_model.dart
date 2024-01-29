import 'package:flutter/cupertino.dart';

@immutable
class UserModel{
  final String email;
  final String name;
  final List<String> followers;
  final List<String> following;
  final String profilePic;
  final String bannerPic;
  final String bio;
  final String uid;
  final bool isTwitterBlue;


  const UserModel({
    required this.email,
    required this.name,
    required this.followers,
    required this.following,
    required this.profilePic,
    required this.bannerPic,
    required this.bio,
    required this.uid,
    required this.isTwitterBlue,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserModel &&
          runtimeType == other.runtimeType &&
          email == other.email &&
          name == other.name &&
          followers == other.followers &&
          following == other.following &&
          profilePic == other.profilePic &&
          bannerPic == other.bannerPic &&
          bio == other.bio &&
          uid == other.uid &&
          isTwitterBlue == other.isTwitterBlue);

  @override
  int get hashCode =>
      email.hashCode ^
      name.hashCode ^
      followers.hashCode ^
      following.hashCode ^
      profilePic.hashCode ^
      bannerPic.hashCode ^
      bio.hashCode ^
      uid.hashCode ^
      isTwitterBlue.hashCode;

  @override
  String toString() {
    return 'UserModel{' +
        ' email: $email,' +
        ' name: $name,' +
        ' followers: $followers,' +
        ' following: $following,' +
        ' profilePic: $profilePic,' +
        ' bannerPic: $bannerPic,' +
        ' bio: $bio,' +
        ' uid: $uid,' +
        ' isTwitterBlue: $isTwitterBlue,' +
        '}';
  }

  UserModel copyWith({
    String? email,
    String? name,
    List<String>? followers,
    List<String>? following,
    String? profilePic,
    String? bannerPic,
    String? bio,
    String? uid,
    bool? isTwitterBlue,
  }) {
    return UserModel(
      email: email ?? this.email,
      name: name ?? this.name,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      profilePic: profilePic ?? this.profilePic,
      bannerPic: bannerPic ?? this.bannerPic,
      bio: bio ?? this.bio,
      uid: uid ?? this.uid,
      isTwitterBlue: isTwitterBlue ?? this.isTwitterBlue,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': this.email,
      'name': this.name,
      'followers': this.followers,
      'following': this.following,
      'profilePic': this.profilePic,
      'bannerPic': this.bannerPic,
      'bio': this.bio,
      'uid': this.uid,
      'isTwitterBlue': this.isTwitterBlue,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      followers: List<String>.from(map['followers']),
      following: List<String>.from(map['following']),
      profilePic: map['profilePic'] ?? '',
      bannerPic: map['bannerPic'] ?? '',
      bio: map['bio'] ?? '',
      uid: map['\$id'] ?? '', // Adjust the type based on your actual data type
      isTwitterBlue: map['isTwitterBlue']?? false,
    );
  }


//</editor-fold>
}