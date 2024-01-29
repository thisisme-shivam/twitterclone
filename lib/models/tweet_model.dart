
import 'package:twitterclone/core/enums/tweet_type_enum.dart';

class Tweet{
  final String text;
  final List<String> imageLinks;
  final List<String> hashTags;
  final String link;
  final TweetType tweetType;
  final DateTime tweetedAt;
  final String uid;
  final List<String> likes;
  final List<String> commentIds;
  final String id;
  final int reshareCount;
  final String retweetedBy;
//<editor-fold desc="Data Methods">

  const Tweet({
    required this.text,
    required this.imageLinks,
    required this.hashTags,
    required this.link,
    required this.tweetType,
    required this.tweetedAt,
    required this.likes,
    required this.commentIds,
    required this.id,
    required this.uid,
    required this.reshareCount,
    required this.retweetedBy
  });

//</e@override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is Tweet &&
              runtimeType == other.runtimeType &&
              text == other.text &&
              imageLinks == other.imageLinks &&
              hashTags == other.hashTags &&
              link == other.link &&
              tweetType == other.tweetType &&
              tweetedAt == other.tweetedAt &&
              likes == other.likes &&
              commentIds == other.commentIds &&
              id == other.id &&
              reshareCount == other.reshareCount &&
              uid == other.uid &&
              retweetedBy == other.retweetedBy
          );


  @override
  int get hashCode =>
      text.hashCode ^
      imageLinks.hashCode ^
      hashTags.hashCode ^
      link.hashCode ^
      tweetType.hashCode ^
      tweetedAt.hashCode ^
      likes.hashCode ^
      commentIds.hashCode ^
      id.hashCode ^
      uid.hashCode ^
      reshareCount.hashCode ^
      retweetedBy.hashCode;


  @override
  String toString() {
    return 'Tweet{' +
        ' text: $text,' +
        ' imageLinks: $imageLinks,' +
        ' hashTags: $hashTags,' +
        ' link: $link,' +
        ' tweetType: $tweetType,' +
        ' tweetedAt: $tweetedAt,' +
        ' likes: $likes,' +
        ' commentIds: $commentIds,' +
        ' id: $id,' +
        ' uid: $uid,' +
        ' reshareCount: $reshareCount,' +
        '}';
  }


  Tweet copyWith({
    String? text,
    List<String>? imageLinks,
    List<String>? hashTags,
    String? link,
    TweetType? tweetType,
    DateTime? tweetedAt,
    String? uid,
    List<String>? likes,
    List<String>? commenIds,
    String? id,
    int? reshareCount,
    String? retweetedBy
  }) {
    return Tweet(
      text: text ?? this.text,
      imageLinks: imageLinks ?? this.imageLinks,
      hashTags: hashTags ?? this.hashTags,
      link: link ?? this.link,
      tweetType: tweetType ?? this.tweetType,
      tweetedAt: tweetedAt ?? this.tweetedAt,
      likes: likes ?? this.likes,
      uid: uid ?? this.uid,
      commentIds: commenIds ?? this.commentIds,
      id: id ?? this.id,
      reshareCount: reshareCount ?? this.reshareCount,
      retweetedBy: retweetedBy ?? this.retweetedBy,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'text': this.text,
      'imageLinks': this.imageLinks,
      'hashTags': this.hashTags,
      'link': this.link,
      'tweetType': this.tweetType.type,
      'tweetedAt': this.tweetedAt.millisecondsSinceEpoch,
      'likes': this.likes,
      'uid': this.uid,
      'retweetedBy': this.retweetedBy,
      'commentIds': this.commentIds,
      'reshareCount': this.reshareCount,
    };
  }

  factory Tweet.fromMap(Map<String, dynamic> map) {
    return Tweet(
      text: map['text'] ?? '',
      uid: map['uid'] ?? '',
      imageLinks: List<String>.from(map['imageLinks']) ?? [],
      hashTags: List<String>.from(map['hashTags'] ) ?? [],
      link: map['link'] ?? '',
      tweetType: (map['tweetType'] as String).toTweetTypeEnum() ?? TweetType.text,
      tweetedAt: DateTime.fromMillisecondsSinceEpoch(map['tweetedAt']) ?? DateTime.now(),
      likes: List<String>.from(map['likes'] ?? []),
      commentIds: List<String>.from(map['commentIds'])  ?? [],
      id: map['\$id'] ?? '',
      reshareCount: map['reshareCount'] ?? 0,
      retweetedBy: map['retweetedBy']?? '',
    );
  }



  //</editor-fold>
}