import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twitterclone/constants/asset_constants.dart';
import 'package:twitterclone/features/tweet/widgets/tweet_list.dart';
import 'package:twitterclone/theme/pallete.dart';

class UIConstants{
  static  AppBar appBar(){
    return AppBar(
      title: SvgPicture.asset(
         AssetsConstants.twitterLogo,
        color: Pallete.blueColor,
        height: 30,
      ),
      centerTitle: true,
    );
  }

  static List<Widget> bottomTabBarPages = [
    const TweetList(),
    Text('search Screen'),
    Text('Notification creen'),
  ];
}