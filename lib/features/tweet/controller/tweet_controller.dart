import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitterclone/constants/appwrite_constants.dart';
import 'package:twitterclone/core/utils.dart';
import 'package:twitterclone/features/auth/controller/auth_controller.dart';
import 'package:twitterclone/models/tweet_model.dart';
import 'package:twitterclone/models/user_model.dart';

import '../../../apis/storage_api.dart';
import '../../../apis/tweet_api.dart';
import '../../../core/enums/tweet_type_enum.dart';

final tweetControllerProvider = StateNotifierProvider<TweetController,bool >((ref) {
  return TweetController(
      ref: ref,
      tweetAPI: ref.watch(tweetAPIProvider),
      storageAPI: ref.watch(appwriteStorageAPIProvider));
});

final tweetListProvider = FutureProvider((ref) async {
  return ref.watch(tweetControllerProvider.notifier).getTweets();
});

final getLatestTweetProvider = StreamProvider.autoDispose((ref)  {
  final tweetAPI = ref.watch(tweetAPIProvider);
  return tweetAPI.getLatestTweet();
});

class TweetController extends StateNotifier<bool> {
  final Ref _ref;
  final TweetAPI _tweetAPI;
  final StorageAPI _storageAPI;

  TweetController({required Ref ref, required TweetAPI tweetAPI,required StorageAPI storageAPI})
      : _ref = ref,
        _tweetAPI = tweetAPI,
        _storageAPI = storageAPI,
        super(false);
  Future<List<Tweet>> getTweets() async {
    final tweetList = await  _tweetAPI.getTweets();
    return tweetList.map((tweet) => Tweet.fromMap(tweet.data)).toList();
  }

  void shareTweet({
    required List<File> images,
    required String text,
    required BuildContext context
  }) {
    if(text.isEmpty) {
      showSnackBar(context,  'Please Enter text');
      return;
    }
    if(images.isNotEmpty){
      _shareImageTweet(images: images, text: text, context: context);
    }else{
      _shareTextTweet(text: text, context: context);
    }
  }

  Future<void> _shareImageTweet({
    required List<File> images,
    required String text,
    required BuildContext context
  }) async {
    state = true;
    final hashTags  = _getHashTagsFromText(text);
    final link  = _getLinkFromText(text);
    final user = _ref.read(currentUserDetailsProvider).value!;
    final List<String> imageUrls = await _storageAPI.uploadImages(images);
    Tweet tweet = Tweet(
        text: text,
        imageLinks:  imageUrls,
        hashTags: hashTags,
        link: link,
        tweetType: TweetType.image,
        tweetedAt: DateTime.now(),
        likes: [],
        commentIds: [],
        id: '',
        reshareCount: 0,
        uid: user.uid, retweetedBy: ''
    );
    final res = await  _tweetAPI.shareTweet(tweet);
    state = false;
    res.fold(
            (l) => showSnackBar(context,l.message),
            (r) {}
    );

  }

  Future<void> _shareTextTweet({
    required String text,
    required BuildContext context
  }) async {
    state = true;
    final hashTags  = _getHashTagsFromText(text);
    final link  = _getLinkFromText(text);
    final user = _ref.read(currentUserDetailsProvider).value!;
    Tweet tweet = Tweet(
        text: text,
        imageLinks: [],
        hashTags: hashTags,
        link: link,
        tweetType: TweetType.text,
        tweetedAt: DateTime.now(),
        likes: [],
        commentIds: [],
        id: '',
        reshareCount: 0,
        uid: user.uid, retweetedBy: ''
    );
    final res = await  _tweetAPI.shareTweet(tweet);
    state = false;
    res.fold(
            (l) => showSnackBar(context,l.message),
            (r) {}
    );
  }


  String _getLinkFromText(String text){
    String link = '';
    List<String> wordsInSentence = text.split(' ');
    for(String word in wordsInSentence){
      if(word.startsWith("https://") || word.startsWith("www.")){
        link = word;
      }
    }
    return link;
  }

  List<String> _getHashTagsFromText(String text){
    List<String> hashTags = [];
    List<String> wordsInSentence = text.split(' ');
    for(String word in wordsInSentence){
      if(word.startsWith("#")){
        hashTags.add(word);
      }
    }
    return hashTags;
  }

  Future<void> likeTweet(Tweet tweet,UserModel user) async {
    List<String> likes = tweet.likes;

    if(likes.contains(user.uid)){
      likes.remove(user.uid);
    }else{
      likes.add(user.uid);
    }
    tweet = tweet.copyWith(likes: likes);
    final res = await _tweetAPI.likeTweet(tweet);
    res.fold((l) => null, (r) => null);
  }


  Future<void> reshareTweet(Tweet tweet,UserModel currentUser,BuildContext context) async {
    tweet = tweet.copyWith(
        retweetedBy: currentUser.name,
        likes: [],
        commenIds: [],
        reshareCount: tweet.reshareCount + 1
    );
    final res = await _tweetAPI.updateReshareCount(tweet);
    res.fold((l) => null, (r) async{
      tweet = tweet.copyWith(
        id: ID.unique(),
        reshareCount: 0,
        tweetedAt: DateTime.now()
      );
      final res2 = await _tweetAPI.shareTweet(tweet);
      res2.fold((l) => showSnackBar(context,l.message), (r) => showSnackBar(context, 'Retweeted'));
    });

  }
}
