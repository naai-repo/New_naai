import 'package:flutter/material.dart';

// Provider for FilterSalons
class FilterSalonsProvider with ChangeNotifier {
  int _selectedDiscountIndex = -1;
  int get getSelectedDiscountIndex => _selectedDiscountIndex;
  
  int _page = 0,_limit = 11;
  set page(int i) => _page = i;
  set limit(int i) => _limit = i;
  int get getPage => _page;
  int get getLimit => _limit;
  
  int _selectedRatingIndex = -1;
  int get getSelectedRatingIndex => _selectedRatingIndex;
  
  int _selectedindex = 0;
  final List<String> _filterTypes = ['Rating','Discount','Salon Type'];
  
  final List<String> _filterCategories = ["Hair","Threading","Hair Colour","Hair Treatment","Spa","Facial","Hands & Feet","Bleach","Waxing","Body","Makeup","Nails"];
  List<String> get filterCategories => _filterCategories;

  final List<String> _filterSalonType = ["Male","Female","Unisex"];
  List<String> get filterSalonType => _filterSalonType;

  int _selectedCategoryIndex = -1;
  int get getselectedCategoryIndex => _selectedCategoryIndex;

  int _selectedSalonTypeIndex = -1;
  int get selectedSalonTypeIndex => _selectedSalonTypeIndex;
  
  int get getSelectdIndex => _selectedindex;
  List<String> get getFilterTypes => _filterTypes;


   
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

  void setGenderFilter(int idx){
    _selectedSalonTypeIndex = idx;
    notifyListeners();
  }

  void resetFilter({bool notify = true}){
    _selectedCategoryIndex = -1;
    _selectedDiscountIndex = -1;
    _selectedRatingIndex = -1;
    _selectedSalonTypeIndex = -1;
    if(notify) notifyListeners();
  }

  int isFilterSelected(){
    int cnt = 0;
    if(getSelectedDiscountIndex != -1) cnt++;
    if(getSelectedRatingIndex != -1) cnt++;
    if(getselectedCategoryIndex != -1) cnt++;
    if(selectedSalonTypeIndex != -1) cnt++;
    print("$getSelectedDiscountIndex $getSelectedRatingIndex $getselectedCategoryIndex $selectedSalonTypeIndex");
    return cnt;
  }
  

}

