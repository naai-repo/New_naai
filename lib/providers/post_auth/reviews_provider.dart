import 'package:flutter/material.dart';
import 'package:naai/models/utility/reviews_username_model.dart';

class ReviewsProvider with ChangeNotifier {
    List<ReviewsModel> _reviews = [];
    List<ReviewsModel> get reviews => _reviews;

    void setReviews(List<ReviewsModel> value){
          _reviews = value;
          notifyListeners();
    }
}