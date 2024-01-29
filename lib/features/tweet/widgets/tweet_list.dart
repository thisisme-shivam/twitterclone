import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitterclone/common/error_page.dart';
import 'package:twitterclone/core/providers.dart';
import 'package:twitterclone/features/tweet/controller/tweet_controller.dart';
import 'package:twitterclone/features/tweet/widgets/tweet_card.dart';
import '../../../common/loading_page.dart';
import '../../../constants/appwrite_constants.dart';
import '../../../models/tweet_model.dart';

class TweetList extends ConsumerWidget {
  const TweetList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(tweetListProvider).when(
      data: (tweets) {
        return ref.watch(getLatestTweetProvider).when(
          data: (data) {
            if (data.events.contains(
                'databases.*.collections.${AppwriteConstants.tweetsCollection}.documents.*.create')) {
              tweets.insert(0,Tweet.fromMap(data.payload));
            }else if(data.events.contains(
                'databases.*.collections.${AppwriteConstants.tweetsCollection}.documents.*.update')){
              //get tweet
              final startingPoint = data.events[0].lastIndexOf('documents.');
              final endingPoint = data.events[0].lastIndexOf('.update');
              final tweetId = data.events[0].substring(startingPoint+10,endingPoint);

              var tweet = tweets.where((element) => element.id == tweetId).first;
              final tweetIndex = tweets.indexOf(tweet);
              tweets.removeWhere((element) => element.id==tweetId);
              tweet = Tweet.fromMap(data.payload);
              tweets.insert(tweetIndex,tweet);
            }
            return ListView.builder(
              itemCount: tweets.length,
              itemBuilder: (BuildContext context, int index) {
                final tweet = tweets[index];
                return TweetCard(tweet: tweet);
              },
            );
          },
          error: (error, stackTrace) =>
              ErrorText(errorText: error.toString()),
          loading: () {
            return ListView.builder(
              itemCount: tweets.length,
              itemBuilder: (BuildContext context, int index) {
                final tweet = tweets[index];
                return TweetCard(tweet: tweet);
              },
            );
          }
        );
      },
      error: (error, stackTrace) => ErrorText(errorText: error.toString()),
      loading: () => const Loader(),
    );
  }
}
