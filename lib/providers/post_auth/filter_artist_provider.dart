import 'package:flutter/material.dart';

// Provider for FilterSalons
class FilterArtitsProvider with ChangeNotifier {
  int _selectedDiscountIndex = -1;
  int get getSelectedDiscountIndex => _selectedDiscountIndex;
  
  int _page = 0,_limit = 10;
  set page(int i) => _page = i;
  set limit(int i) => _limit = i;
  int get getPage => _page;
  int get getLimit => _limit;

  
  int _selectedRatingIndex = -1;
  int get getSelectedRatingIndex => _selectedRatingIndex;
  
  int _selectedindex = 0;
  final List<String> _filterTypes = ['Category','Rating'];
  //final List<String> _filterTypes = ['Price','Category','Rating','Discount','Salon Type','Distance'];
  
  int get getSelectdIndex => _selectedindex;
  List<String> get getFilterTypes => _filterTypes;

  final List<String> _filterCategories = ["Hair","Threading","Hair Colour","Hair Treatment","Spa","Facial","Hands & Feet","Bleach","Waxing","Body","Makeup","Nails"];
  List<String> get filterCategories => _filterCategories;
  
  int _selectedCategoryIndex = -1;
  int get getselectedCategoryIndex => _selectedCategoryIndex;

  void changeIndex(int idx) {
    _selectedindex = idx;
    notifyListeners();
  }
  
  void setDiscountIndex(int idx){
     _selectedDiscountIndex = idx;
     notifyListeners();
  }

  void setRatingIndex(int idx){
     _selectedRatingIndex = idx;
     notifyListeners();
  }

  void setCategoryIndex(int idx){
    _selectedCategoryIndex = idx;
    notifyListeners();
  }

  void resetFilter(){
    _selectedCategoryIndex = -1;
    _selectedDiscountIndex = -1;
    _selectedRatingIndex = -1;
    notifyListeners();
  }

  int isFilterSelected(){
    int cnt = 0;
    if(getSelectedDiscountIndex != -1) cnt++;
    if(getSelectedRatingIndex != -1) cnt++;
    if(getselectedCategoryIndex != -1) cnt++;
    return cnt;
  }
  
}

