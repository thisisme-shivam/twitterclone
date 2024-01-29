import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitterclone/constants/appwrite_constants.dart';
import 'package:twitterclone/core/core.dart';
import 'package:twitterclone/core/providers.dart';

import '../models/user_model.dart';

final userAPIProvider = Provider((ref) {
  return UserAPI(db: ref.watch(appwriteDatabaseProvider));
});

abstract class IUserAPI{
  FutureEitherVoid saveUserData(UserModel userModel);
  Future<model.Document> getUserData(String uid);
}

class UserAPI implements IUserAPI{
  final Databases _db;

  UserAPI( {required Databases db}) : _db = db;

  @override
  FutureEitherVoid saveUserData(UserModel userModel) async {
    try{
      final document = await _db.createDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.usersCollection,
          documentId: userModel.uid,
          data: userModel.toMap());

      return Either.right(null);
    } on AppwriteException catch (e,st){
      return Either.left(Failure(e.message??"Some unexpected error occured",st));
    }catch (e,st){
      return Either.left(Failure(e.toString(),st));
    }
  }

  @override
  Future<model.Document> getUserData(String uid) async {
    return await _db.getDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollection,
        documentId: uid
    );
  }

}