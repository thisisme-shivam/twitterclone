class AppwriteConstants {
  static const String databaseId = "65b36b28a17dd0330c36";
  static const String projectId = "659a83a90dc7bf64ea22";
  static const String endPoint = "http://localhost:80/v1";
  static const String usersCollection = "65b36b42786c0c540a77";
  static const String tweetsCollection = "65b36b524d6bca1c4f9f";
  static const String imagesBucket = "65b0f62acb9878890143";

  static  String imageUrl(String imageId){
    return '$endPoint/storage/buckets/$imagesBucket/files/$imageId/view?project=$projectId&mode=admin';
  }
}
