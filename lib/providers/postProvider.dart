import 'package:flutter/material.dart';

class PostProvider with ChangeNotifier {
  String id = "";
  String name = "";
  String description = "";
  List<dynamic> liked_users = [];
  String image = "";
  List<dynamic> ratings = [];
  List<dynamic> comments = [];

  String getId() {
    return id;
  }

  void setId(id) {
    this.id = id;
  }

  String getName() {
    return name;
  }

  void setName(name) {
    this.name = name;
    notifyListeners();
  }

  String getDescription() {
    return description;
  }

  void setDescription(description) {
    this.description = description;
  }

  List<dynamic> getLikedUsers() {
    return liked_users;
  }

  void setLikedUsers(liked_users) {
    this.liked_users = liked_users;
  }

  void addOrRemoveLike(user_id) {
    if (liked_users.contains(user_id)) {
      liked_users.remove(user_id);
    } else {
      liked_users.add(user_id);
    }
    notifyListeners();
  }

  String getImage() {
    return image;
  }

  void setImage(image) {
    this.image = image;
  }

  List<dynamic> getRatings() {
    return ratings;
  }

  void setRatings(ratings) {
    this.ratings = ratings;
    notifyListeners();
  }

  double getAvgRating() {
    double sum = 0;
    for (int i = 0; i < ratings.length; i++) {
      sum += ratings[i]['number'];
    }
    return sum / ratings.length;
  }

  List<dynamic> getComments() {
    return comments;
  }

  void setComments(comments) {
    this.comments = comments;
  }

  void addComment(comment) {
    comments.add(comment);
    notifyListeners();
  }
}
