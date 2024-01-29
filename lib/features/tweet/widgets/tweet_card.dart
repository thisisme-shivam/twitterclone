import 'dart:ffi';

import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:like_button/like_button.dart';
import 'package:twitterclone/common/error_page.dart';
import 'package:twitterclone/constants/asset_constants.dart';
import 'package:twitterclone/features/auth/controller/auth_controller.dart';
import 'package:twitterclone/features/tweet/controller/tweet_controller.dart';
import 'package:twitterclone/features/tweet/widgets/carousel_image.dart';
import 'package:twitterclone/features/tweet/widgets/hashtags_text.dart';
import 'package:twitterclone/features/tweet/widgets/tweet_icon_button.dart';
import 'package:twitterclone/models/tweet_model.dart';
import 'package:twitterclone/theme/pallete.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../common/loading_page.dart';
import '../../../core/enums/tweet_type_enum.dart';

class TweetCard extends ConsumerWidget {
  final Tweet tweet;
  const TweetCard({super.key, required this.tweet}) ;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    return currentUser == null ? const Loader(): ref.watch(userDetailsProvider(tweet.uid)).when(
        data: (user){
          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(user.profilePic),
                      radius: 35,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(tweet.retweetedBy.isNotEmpty)
                        Row(
                          children: [
                            SvgPicture.asset(
                                AssetsConstants.retweetIcon,
                              color: Pallete.greyColor,
                              height: 20,
                            ),
                            const SizedBox(height: 2,),
                            Text(
                              '${tweet.retweetedBy} retweeted',
                              style: const TextStyle(
                                color: Pallete.greyColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right:5),
                              child: Text(
                                  user.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 19
                                ),
                              ),
                    
                            ),
                            Text(
                              "@${user.name} . ${timeago.format(tweet.tweetedAt,locale: 'en_short')}" ,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Pallete.greyColor),
                            ),
                          ],
                        ),
                        // replied to
                        HashTagText(text: tweet.text),
                        if(tweet.tweetType == TweetType.image)
                          CarouselImage(imageLinks: tweet.imageLinks),
                        if(tweet.link.isNotEmpty)...[
                          const SizedBox(height: 4,),
                          AnyLinkPreview(displayDirection: UIDirection.uiDirectionHorizontal, link: tweet.link),
                        ],
                        Container(
                          margin: const EdgeInsets.only(
                            top: 10,
                            right: 20
                          ),
                          child: Row(
                            children: [
                              TweetIconButton(
                                  pathName: AssetsConstants.viewsIcon,
                                  text: (tweet.commentIds.length+tweet.reshareCount+tweet.likes.length).toString(),
                                  onTap: () {}
                              ),
                              TweetIconButton(
                                  pathName: AssetsConstants.commentIcon,
                                  text: (tweet.commentIds.length).toString(),
                                  onTap: () {}
                              ),
                              TweetIconButton(
                                  pathName: AssetsConstants.retweetIcon,
                                  text: (tweet.reshareCount).toString(),
                                  onTap: () {
                                        ref.watch(tweetControllerProvider.notifier)
                                            .reshareTweet(
                                                tweet, currentUser, context
                                            );
                                      }
                              ),
                              LikeButton(
                                onTap: (isLiked) async {
                                  ref.read(tweetControllerProvider.notifier).likeTweet(tweet, currentUser);
                                  return !isLiked;
                                },
                                size: 25,
                                isLiked: tweet.likes.contains(currentUser.uid),
                                likeBuilder: (isLiked){
                                  return isLiked
                                      ? SvgPicture.asset(
                                    AssetsConstants.likeFilledIcon,
                                    color: Pallete.redColor,
                                  ) : SvgPicture.asset(
                                    AssetsConstants.likeOutlinedIcon,
                                    color : Pallete.greyColor
                                  );
                                },
                                likeCount: tweet.likes.length,
                                countBuilder: (likeCount,isLiked,text){
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      text,
                                      style: TextStyle(
                                        color: isLiked? Pallete.redColor:Pallete.whiteColor,
                                        fontSize: 16
                                      ),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.share_outlined,
                                    size: 24,
                                    color: Pallete.greyColor,
                                  )
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 1,)
                      ],
                    ),
                  )
                ],
              ),
              const Divider(color: Pallete.greyColor,)
            ],
          );
        },
        error: (error,st) => ErrorText(errorText: error.toString(),)
        ,
        loading: () => const Loader());

  }
}