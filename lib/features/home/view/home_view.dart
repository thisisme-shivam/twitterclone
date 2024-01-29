import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twitterclone/constants/asset_constants.dart';
import 'package:twitterclone/constants/ui_constants.dart';
import 'package:twitterclone/features/tweet/views/create_tweet_view.dart';
import 'package:twitterclone/theme/theme.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  static route() => MaterialPageRoute(builder: (context) => const HomeView());

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _page = 0;
  final appBar = UIConstants.appBar();

  void onPageChange(int index){
    setState(() {
      _page = index;
    });
  }

  onCreateTweet(){
    Navigator.push(context,CreateTweetScreen.route());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: IndexedStack(
        index: _page,
        children: UIConstants.bottomTabBarPages,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onCreateTweet,
        child: const Icon(
          Icons.add,
          color: Pallete.whiteColor,
          size: 28,
        ),

      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: Pallete.backgroundColor,
        currentIndex: _page,
        onTap: onPageChange,
        items: [
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                  _page == 0
                      ? AssetsConstants.homeFilledIcon
                      : AssetsConstants.homeOutlinedIcon,
                  color: Pallete.whiteColor
              ),
          ),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                _page == 1
                    ? AssetsConstants.searchIcon
                    : AssetsConstants.searchIcon,
                color: Pallete.whiteColor,
              ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _page == 2
                  ? AssetsConstants.notifFilledIcon
                  : AssetsConstants.notifOutlinedIcon,
              color: Pallete.whiteColor,
            ),
          ),
        ],
      ),
    );
  }
}
