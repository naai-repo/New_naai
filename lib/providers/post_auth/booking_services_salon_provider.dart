import 'package:flutter/material.dart';
import 'package:naai/models/api_models/artist_item_model.dart';
import 'package:naai/models/api_models/service_item_model.dart';
import 'package:naai/models/api_models/single_salon_model.dart';
import 'package:naai/models/utility/booking_service_salon_model.dart';
import 'package:naai/models/utility/single_staff_services_model.dart';

class BookingServicesSalonProvider with ChangeNotifier {
  late SingleSalonResponseModel _salonDetails;
  SingleSalonResponseModel get salonDetails => _salonDetails;

  final List<BookingServiceSalonModel> _selectedServices = [];
  List<BookingServiceSalonModel> get selectedServices => _selectedServices;

  double _totalPrice = 0;
  double get totalPrice => _totalPrice;

  double _totalDiscountPrice = 0;
  double get totalDiscountPrice => _totalDiscountPrice;

  int _selectedStaffIndex = -1;
  int get selectedStaffIndex => _selectedStaffIndex;
  
  void setSalonDetails(SingleSalonResponseModel value){
      _salonDetails = value;
  }

  void setStaffIndex(int idx){
     _selectedStaffIndex = idx;
     notifyListeners();
  }
  
  void addService(ServiceDataModel value){
    for(var e in _selectedServices){
      if(e.service!.id == value.id){
          _selectedServices.remove(e);
          _totalPrice -= value.basePrice ?? 0;
          _totalDiscountPrice -= value.cutPrice ?? 0;
          notifyListeners();
          return;
      }
    }

    List<ArtistDataModel> eligibleArtists = [];
    final artists = _salonDetails.data?.artists ?? [];

    for(var e in artists){
        final services = e.services ?? [];
        for(var s in services){
            if(s.serviceId == value.id){
                eligibleArtists.add(e);
            }
        }
    }
     
    _selectedServices.add(BookingServiceSalonModel(
      artists: eligibleArtists,
      service: value
    ));

    _totalPrice += value.basePrice ?? 0;
    _totalDiscountPrice += value.cutPrice ?? 0;

    notifyListeners();
  }
  
  void removeService(ServiceDataModel value){
      _selectedServices.removeWhere((element) => element.service!.id == value.id);
      _totalPrice -= value.basePrice ?? 0;
      _totalDiscountPrice -= value.cutPrice ?? 0;
      notifyListeners();
  }

  bool isServiceSelected(ServiceDataModel value){
    for(var e in _selectedServices){
      if(e.service!.id == value.id) return true;
    }
    return false;
  }
  

  SingleStaffServicesModel getSingleStaffServicesAndArtists(){
     Map<String,ArtistDataModel> mp = {};
     List<ArtistDataModel> artists = [];


     for(var e in _selectedServices){
        for(var a in e.artists!){
           if((a.id ?? "").isNotEmpty){
              if(!mp.containsKey(a.id)){
                 mp[a.id!] = a;
              }
           }
        }
     }

     mp.forEach((key, value) {
         artists.add(value);
     });

     return SingleStaffServicesModel(
      artists: artists,
      selectedServices: _selectedServices
     );
  }
  
  // SingleStaffServicesModel getSingleStaffServicesAndArtists(){
  //    Map<String,int> mp = {};

  //    for(var e in _selectedServices){
  //       for(var a in e.artists!){
  //          if((a.id ?? "").isNotEmpty){
  //             if(mp.containsKey(a.id)){
  //               mp.update(a.id!, (value) => value + 1);
  //             }else{
  //               mp[a.id!] = 1;
  //             }
  //          }
  //       }
  //    }
  //    List<ArtistDataModel> artists = [];

  //    mp.forEach((key, value) { 
  //       if(value != _selectedServices.length) return;

  //       for(var e in _selectedServices){
  //         for(var a in e.artists!){
  //             if(a.id! == key){
  //                artists.add(a);
  //                return;
  //             }
  //         }
  //       }
  //    });

  //    return SingleStaffServicesModel(
  //     artists: artists,
  //     selectedServices: _selectedServices
  //    );
  // }
  
  
}