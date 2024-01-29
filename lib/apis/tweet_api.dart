import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitterclone/core/core.dart';
import 'package:twitterclone/core/providers.dart';

import '../constants/appwrite_constants.dart';
import '../models/tweet_model.dart';

final tweetAPIProvider = Provider((ref) {
  return TweetAPI(db: ref.watch(appwriteDatabaseProvider),realtime: ref.watch(appwriteRealtimeProvider) );
});

abstract class ITweetAPI{
  FutureEither<model.Document> shareTweet(Tweet tweet);
  Future<List<model.Document>> getTweets();
  Stream<RealtimeMessage>  getLatestTweet();
  FutureEither<model.Document> likeTweet(Tweet tweet);
  FutureEither<model.Document> updateReshareCount(Tweet tweet);
}


class TweetAPI implements ITweetAPI{
  final Databases _db;
  final Realtime _realTime;

  TweetAPI({required Databases db, required Realtime realtime})
      : _db = db,
        _realTime = realtime;
  @override
  FutureEither<model.Document> shareTweet(Tweet tweet) async {

    try{
      final document = await _db.createDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.tweetsCollection,
          documentId: ID.unique(),
          data: tweet.toMap());

      return Either.right(document);
    } on AppwriteException catch (e,st){
      return Either.left(Failure(e.message??"Some unexpected error occured",st));
    }catch (e,st){
      return Either.left(Failure(e.toString(),st));
    }
  }

  @override
  Future<List<model.Document>> getTweets() async {
    final documents = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.tweetsCollection,
        queries: [
          Query.orderDesc('tweetedAt')
        ]
    );

    return documents.documents;
  }

  @override
  Stream<RealtimeMessage> getLatestTweet() {
    return _realTime.subscribe([
      'databases.${AppwriteConstants.databaseId}'
          '.collections.${AppwriteConstants.tweetsCollection}.documents'
    ]).stream;
  }

  @override
  FutureEither<model.Document> likeTweet(Tweet tweet) async {
    try{
      final document = await _db.updateDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.tweetsCollection,
          documentId: tweet.id,
          data: {
            'likes' : tweet.likes
          });

      return Either.right(document);
    } on AppwriteException catch (e,st){
      return Either.left(Failure(e.message??"Some unexpected error occured",st));
    }catch (e,st){
      return Either.left(Failure(e.toString(),st));
    }
  }

  @override
  FutureEither<model.Document> updateReshareCount(Tweet tweet) async {
    try{
      final document = await _db.updateDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.tweetsCollection,
          documentId: tweet.id,
          data: {
            'reshareCount' : tweet.reshareCount
          });

      return Either.right(document);
    } on AppwriteException catch (e,st){
      return Either.left(Failure(e.message??"Some unexpected error occured",st));
    }catch (e,st){
      return Either.left(Failure(e.toString(),st));
    }
  }
}