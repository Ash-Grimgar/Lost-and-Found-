import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lost_and_found/core/domain/usecases/usecase.dart';
import 'package:lost_and_found/features/user/data/datasources/user_client.dart';
import 'package:lost_and_found/features/user/domain/usecases/update_locale_usecase.dart';
import 'package:lost_and_found/features/user/domain/usecases/update_password_usecase.dart';
import 'package:lost_and_found/features/user/domain/usecases/upload_user_image_usecase.dart';

import '../../../../core/data/datasources/utils.dart';
import '../models/get_user/user_dto.dart';

abstract class UserDataSource {
  Future<UserDto> getUserInfo(NoParams params, int userId);
  Future<void> uploadUserImage(UploadUserImageParams params);
  Future<void> updatePassword(UpdatePasswordParams params);
  Future<void> updateLocale(UpdateLocaleParams params);
}

class UserDataSourceImpl implements UserDataSource {
  final UserClient _client;

  UserDataSourceImpl(this._client);

  @override
  Future<UserDto> getUserInfo(NoParams params, int userId) async {
    final current = FirebaseAuth.instance.currentUser;
    if (current != null) {
      String username = current.displayName ?? current.email?.split('@').first ?? "User";
      String? imageUrl;
      try {
        final doc = await FirebaseFirestore.instance.collection('users').doc(current.uid).get();
        if (doc.exists && doc.data() != null) {
          final data = doc.data()!;
          if (data['username'] != null) username = data['username'] as String;
          if (data['imageUrl'] != null) imageUrl = data['imageUrl'] as String;
        }
      } catch (_) {}

      return UserDto(
        id: userId,
        username: username,
        image: imageUrl != null && imageUrl.isNotEmpty,
      );
    }
    return _client.getUserInfo(userId).catchError(handleError<UserDto>);
  }

  @override
  Future<void> uploadUserImage(UploadUserImageParams params) async {
    final current = FirebaseAuth.instance.currentUser;
    if (current != null) {
      try {
        final bytes = await params.image.readAsBytes();
        final base64Image = 'data:image/jpeg;base64,${base64Encode(bytes)}';
        await FirebaseFirestore.instance.collection('users').doc(current.uid).set({
          'imageUrl': base64Image,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      } catch (_) {}
    }
  }

  @override
  Future<void> updatePassword(UpdatePasswordParams params) async {
    final current = FirebaseAuth.instance.currentUser;
    if (current != null) {
      await current.updatePassword(params.newPassword);
      return;
    }
    return _client.updatePassword(params).catchError(handleError<void>);
  }

  @override
  Future<void> updateLocale(UpdateLocaleParams params) async {
    return;
  }
}
