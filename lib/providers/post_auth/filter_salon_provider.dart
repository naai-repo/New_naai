import 'package:flutter/material.dart';

// Provider for FilterSalons
class FilterSalonsProvider with ChangeNotifier {
  int _selectedDiscountIndex = -1;
  int get getSelectedDiscountIndex => _selectedDiscountIndex;

  int _selectedRatingIndex = -1;
  int get getSelectedRatingIndex => _selectedRatingIndex;
  
  int _selectedindex = 0;
  final List<String> _filterTypes = ['Price','Category','Rating','Discount','Salon Type','Distance'];
  
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

  int isFilterSelected(){
    int cnt = 0;
    if(getSelectedDiscountIndex != -1) cnt++;
    if(getSelectedRatingIndex != -1) cnt++;
    return cnt;
  }

  
  
}

