import 'package:flutter/cupertino.dart';
import 'package:naai/models/api_models/service_item_model.dart';
import 'package:naai/models/api_models/single_salon_model.dart';

class SalonsServiceFilterProvider with ChangeNotifier {
   late SingleSalonResponseModel _salonDetials;
   SingleSalonResponseModel get salonDetials => _salonDetials;
   
   List<ServiceDataModel> _services = [];
   List<ServiceDataModel> get services => _services;

   int _currentFilterActive = 0;
   int get currentFilterActive => _currentFilterActive;

   final List<String> _categories = [];
   List<String> get categories => _categories;

   final List<int> _selectedCategoryIndex = [];
   List<int> get selectedCategoryIndex => _selectedCategoryIndex;

   String _genderType = "none";
   String get genderType => _genderType;
   
   String _searchValue = "";
   String get searchValue => _searchValue;

   void setSalonDetails(SingleSalonResponseModel value){
       _salonDetials = value;
       _services = value.data?.services ?? [];
       for(var e in _services){
          if(!_categories.contains(e.category ?? "xxxx")) _categories.add(e.category ?? "");
       }
       _selectedCategoryIndex.clear();
       _genderType = "none";
       notifyListeners();
   }

     List<ServiceDataModel> getServices(){
       final orgServices = _salonDetials.data?.services ?? [];
       if(_currentFilterActive <= 0 && _searchValue.isEmpty) return orgServices;
       
       // Gender Filter
      _services = orgServices;
      if(_genderType != "none"){
         _services = _services.where((element) => element.targetGender == _genderType).toList();
      }
      print("Servce ${_services.length}");

      //Category Filter
      if(_selectedCategoryIndex.isNotEmpty){
         _services = _services.where((element) {
              if(_selectedCategoryIndex.contains(categories.indexOf(element.category?.toLowerCase() ?? ""))){
                return true;
              }
              return false;
          }).toList();
      }

      // Search Filter
      if(_searchValue.isNotEmpty){
         print(_searchValue);
         _services = _services.where((element) => (element.serviceTitle?.toLowerCase().contains(_searchValue.toLowerCase()) ?? true)).toList();
      }
      return _services;

   }
   
   void filterByGender(String type){
      if(_genderType == type) return;
      if(_genderType == "none") _currentFilterActive++;
      _genderType = type;
      notifyListeners();
   }

   void filterByCategory(int i){
      if(_selectedCategoryIndex.contains(i)) return;
      _selectedCategoryIndex.add(i);
      _currentFilterActive++;
      notifyListeners();
   }

   void filterBySearch(String value){
      if(value.isEmpty) return;
       _searchValue = value;
      notifyListeners();
   }

   void resetAllFilter(){
      _currentFilterActive = 0;
      _selectedCategoryIndex.clear();
      _searchValue = "";
      _genderType = "none";
      _services = _salonDetials.data?.services ?? [];
      notifyListeners();
   }

   void resetCategoryFilter(){
      _selectedCategoryIndex.clear();
      _services = _salonDetials.data?.services ?? [];
      _currentFilterActive--;
      notifyListeners();
   }

   void resetCategoryFilterByIndex(int idx){
      _selectedCategoryIndex.remove(idx);
      _services = _salonDetials.data?.services ?? [];
      _currentFilterActive--;
      notifyListeners();
   }

   void resetGenderFilter(){
      _genderType = "none";
      _services = _salonDetials.data?.services ?? [];
      _currentFilterActive--;
      notifyListeners();
   }
   
}