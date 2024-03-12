
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

   String _searchValue = "";
   String get searchValue => _searchValue;

   List<ServiceDataModel> _orgServices = [];
   List<ServiceDataModel> get orgServices => _orgServices;

   void setArtistDetails(SingleArtistScreenModel value){
       _artistDetials = value;
       _services = value.services ?? [];
       List<ServiceDataModel> tempServices = [];
       
       _services.asMap().forEach((key, resService) {
          //final artistServicesForPrices = _artistDetials.artistDetails?.data?.services ?? [];
          final salonArtistServices = _artistDetials.salonDetails!.data!.artists!.singleWhere((element) => element.id == value.artistDetails!.data!.id).services;
          final serviceItem = salonArtistServices!.singleWhere((element) => element.serviceId == resService.id);
          
          List<VariableService> variablesItem = [];

          resService.variables!.asMap().forEach((hhd, varserv) {
             final servForPrice = serviceItem.variables!.singleWhere((element) => element.variableId == varserv.id);
             varserv = varserv.copyWith(variableCutPrice: servForPrice.cutPrice,variablePrice: double.tryParse(servForPrice.price.toString()));
             variablesItem.add(varserv);
          });
          // serviceItem.variables!.asMap().forEach((idx, variableRes) {
          //     final variable = resService.variables!.singleWhere((element) => element.id == variableRes.variableId);
          //     variablesItem.add(variable.copyWith(variablePrice: variableRes.price,variableCutPrice: variableRes.cutPrice));
          // });
          tempServices.add(resService.copyWith(basePrice: serviceItem.price,cutPrice: serviceItem.cutPrice,variables: variablesItem));
       });
       
       _services = tempServices;
       _orgServices = tempServices;

       
       for(var e in _services){
          if(!_categories.contains(e.category ?? "xxxx")) _categories.add(e.category?.toLowerCase() ?? "");
       }
       _selectedCategoryIndex.clear();
       _genderType = "none";
       
       notifyListeners();
   }
   
   List<ServiceDataModel> getServices(){
       final orgServices = _orgServices;
       if(_currentFilterActive <= 0 && _searchValue.isEmpty) return orgServices;
       
       // Gender Filter
      _services = orgServices;
      if(_genderType != "none"){
         _services = _services.where((element) => element.targetGender == _genderType).toList();
      }
      

      //Category Filter
      if(_selectedCategoryIndex.isNotEmpty){
         _services = _services.where((element){
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
      _services = _artistDetials.services ?? [];
      notifyListeners();
   }

   void resetCategoryFilter(){
      _selectedCategoryIndex.clear();
      _services = _artistDetials.services ?? [];
      _currentFilterActive--;
      notifyListeners();
   }

   void resetCategoryFilterByIndex(int idx){
      _selectedCategoryIndex.remove(idx);
      _services = _artistDetials.services ?? [];
      _currentFilterActive--;
      notifyListeners();
   }

   void resetGenderFilter(){
      _genderType = "none";
      _services = _artistDetials.services ?? [];
      _currentFilterActive--;
      notifyListeners();
   }
   
}


// class ArtistServicesFilterProvider with ChangeNotifier {
//    late SingleArtistScreenModel _artistDetials;
//    SingleArtistScreenModel get artistDetials => _artistDetials;

//    int _currentFilterActive = 0;
//    int get currentFilterActive => _currentFilterActive;
   
//    List<ServiceDataModel> _services = [];
//    List<ServiceDataModel> get services => _services;

//    final List<String> _categories = [];
//    List<String> get categories => _categories;

//    final List<int> _selectedCategoryIndex = [];
//    List<int> get selectedCategoryIndex => _selectedCategoryIndex;

//    String _genderType = "none";
//    String get genderType => _genderType;

//    void setArtistDetails(SingleArtistScreenModel value){
//        _artistDetials = value;
//        _services = value.services ?? [];
//        for(var e in _services){
//           if(!_categories.contains(e.category ?? "xxxx")) _categories.add(e.category ?? "");
//        }
//        _selectedCategoryIndex.clear();
//        _genderType = "none";
//        notifyListeners();
//    }

//    void filterByGender(String type,{bool usePre = false}){
//       if(_genderType == type) return;
      
//       final orgServices = (_currentFilterActive > 0 && _genderType == "none") ? _services : _artistDetials.services ?? [];
//       _services = [];
//       for(var e in orgServices){
//             if(e.targetGender == type) _services.add(e);
//       }
//       if(!usePre && _genderType == "none") _currentFilterActive++;
//       _genderType = type;
//       globelFilter();
//    }

//    void filterByCategory(int i,{bool usePre = false}){
//       if(_selectedCategoryIndex.contains(i)) return;

//       final orgServices = (_currentFilterActive > 0) ? _services : _artistDetials.services ?? [];
//       _services = [];
//       _selectedCategoryIndex.add(i);

//       for(var e in orgServices){
//             if(e.category == _categories[i]) _services.add(e);
//       }

//       if(!usePre) _currentFilterActive++;
//       globelFilter();
//    }

//    void filterBySearch(String value,{bool usePre = false}){
//       final orgServices = (_currentFilterActive > 0) ? _services : _artistDetials.services ?? [];
//       _services = [];
//       for(var e in orgServices){
//             if(e.serviceTitle?.contains(value) ?? false) _services.add(e);
//       }
//       if(!usePre) _currentFilterActive++;
//       globelFilter();
//       notifyListeners();
//    }

//    void globelFilter(){
//       if(_selectedCategoryIndex.isNotEmpty){
//           for(var i in _selectedCategoryIndex){
//             final orgServices = (_currentFilterActive > 0) ? _services : _artistDetials.services ?? [];
//             _services = [];

//             for(var e in orgServices){
//                   if(e.category == _categories[i]) _services.add(e);
//             }
//           }
//       }
      
//       print("${_services.length} - $_genderType - $_currentFilterActive");

//       if(_genderType != "none"){
//           filterByGender(_genderType,usePre: true);
//       }

//       notifyListeners();
//    }

//    void resetAllFilter(){
//       _currentFilterActive = 0;
//       _selectedCategoryIndex.clear();
//       _genderType = "none";
//       _services = _artistDetials.services ?? [];
//       notifyListeners();
//    }

//    void resetCategoryFilter(){
//       _selectedCategoryIndex.clear();
//       _services = _artistDetials.services ?? [];
//       _currentFilterActive--;
//       globelFilter();
//       notifyListeners();
//    }

//    void resetCategoryFilterByIndex(int idx){
//       _selectedCategoryIndex.remove(idx);
//       _services = _artistDetials.services ?? [];
//       _currentFilterActive--;
//       globelFilter();
//       notifyListeners();
//    }

//    void resetGenderFilter(){
//       _genderType = "none";
//       _services = _artistDetials.services ?? [];
//       _currentFilterActive--;
//       globelFilter();
//       notifyListeners();
//    }
   
// }


