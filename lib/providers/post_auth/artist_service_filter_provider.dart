
import 'package:flutter/material.dart';
import 'package:naai/models/api_models/service_item_model.dart';
import 'package:naai/models/utility/single_artist_screen_model.dart';

class ArtistServicesFilterProvider with ChangeNotifier {
   late SingleArtistScreenModel _artistDetials;
   SingleArtistScreenModel get artistDetials => _artistDetials;

   int _currentFilterActive = 0;
   int get currentFilterActive => _currentFilterActive;
   
   List<ServiceDataModel> _services = [];
   List<ServiceDataModel> get services => _services;

   final List<String> _categories = [];
   List<String> get categories => _categories;

   final List<int> _selectedCategoryIndex = [];
   List<int> get selectedCategoryIndex => _selectedCategoryIndex;

   String _genderType = "none";
   String get genderType => _genderType;

   void setArtistDetails(SingleArtistScreenModel value){
       _artistDetials = value;
       _services = value.services ?? [];
       for(var e in _services){
          if(!_categories.contains(e.category ?? "xxxx")) _categories.add(e.category ?? "");
       }
       _selectedCategoryIndex.clear();
       _genderType = "none";
       notifyListeners();
   }

   void filterByGender(String type,{bool usePre = false}){
      if(_genderType == type) return;
      
      final orgServices = (_currentFilterActive > 0 && _genderType == "none") ? _services : _artistDetials.services ?? [];
      _services = [];
      for(var e in orgServices){
            if(e.targetGender == type) _services.add(e);
      }
      if(!usePre && _genderType == "none") _currentFilterActive++;
      _genderType = type;
      globelFilter();
   }

   void filterByCategory(int i,{bool usePre = false}){
      if(_selectedCategoryIndex.contains(i)) return;

      final orgServices = (_currentFilterActive > 0) ? _services : _artistDetials.services ?? [];
      _services = [];
      _selectedCategoryIndex.add(i);

      for(var e in orgServices){
            if(e.category == _categories[i]) _services.add(e);
      }

      if(!usePre) _currentFilterActive++;
      globelFilter();
   }

   void filterBySearch(String value,{bool usePre = false}){
      final orgServices = (_currentFilterActive > 0) ? _services : _artistDetials.services ?? [];
      _services = [];
      for(var e in orgServices){
            if(e.serviceTitle?.contains(value) ?? false) _services.add(e);
      }
      if(!usePre) _currentFilterActive++;
      globelFilter();
      notifyListeners();
   }

   void globelFilter(){
      if(_selectedCategoryIndex.isNotEmpty){
          for(var i in _selectedCategoryIndex){
            final orgServices = (_currentFilterActive > 0) ? _services : _artistDetials.services ?? [];
            _services = [];

            for(var e in orgServices){
                  if(e.category == _categories[i]) _services.add(e);
            }
          }
      }
      
      print("${_services.length} - $_genderType - $_currentFilterActive");

      if(_genderType != "none"){
          filterByGender(_genderType,usePre: true);
      }

      notifyListeners();
   }

   void resetAllFilter(){
      _currentFilterActive = 0;
      _selectedCategoryIndex.clear();
      _genderType = "none";
      _services = _artistDetials.services ?? [];
      notifyListeners();
   }

   void resetCategoryFilter(){
      _selectedCategoryIndex.clear();
      _services = _artistDetials.services ?? [];
      _currentFilterActive--;
      globelFilter();
      notifyListeners();
   }

   void resetCategoryFilterByIndex(int idx){
      _selectedCategoryIndex.remove(idx);
      _services = _artistDetials.services ?? [];
      _currentFilterActive--;
      globelFilter();
      notifyListeners();
   }

   void resetGenderFilter(){
      _genderType = "none";
      _services = _artistDetials.services ?? [];
      _currentFilterActive--;
      globelFilter();
      notifyListeners();
   }
   
}