import 'package:flutter/material.dart';
import 'package:naai/models/api_models/artist_item_model.dart';
import 'package:naai/models/api_models/scheduling_response_model.dart';
import 'package:naai/models/api_models/service_item_model.dart';
import 'package:naai/models/api_models/single_salon_model.dart';
import 'package:naai/models/utility/booking_service_salon_model.dart';
import 'package:naai/models/utility/selected_service_artists.dart';
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

  VariableService _variableSelected = VariableService(id: "0000",variableCutPrice: 0,variablePrice: 0);
  VariableService get variableSelected => _variableSelected;

  final List<ServicesArtistItemModel> _finalSingleStaffSelectedServices = [];
  List<ServicesArtistItemModel> get finalSingleStaffSelectedServices => _finalSingleStaffSelectedServices;
  
  ArtistDataModel _singleStaffArtistSelected = ArtistDataModel(id: "0000");
  ArtistDataModel get singleStaffArtistSelected => _singleStaffArtistSelected;

  List<ServicesArtistItemModel> _finalMultiStaffSelectedServices = [];
  List<ServicesArtistItemModel> get finalMultiStaffSelectedServices => _finalMultiStaffSelectedServices;
  
  ScheduleResponseModel _scheduleResponseData = ScheduleResponseModel(salonId: "0000");
  ScheduleResponseModel get scheduleResponseData => _scheduleResponseData;
  
  DateTime _bookingSelectedDate = DateTime(1999,9,7,17,30);
  DateTime get bookingSelectedDate => _bookingSelectedDate;
  
  List<String> _selectedArtistTimeSlot = ["00","00"];
  List<String> get selectedArtistTimeSlot => _selectedArtistTimeSlot;

  void setArtistTimeSlot(String slot){
      for(var e in _scheduleResponseData.timeSlotsVisible!){
         if(e[0] == slot){
            _selectedArtistTimeSlot = e;
            break;
         }
      }
      notifyListeners();
  }

  void setBookingSelectedDateAndScheduleResponse(DateTime value,ScheduleResponseModel res){
        _bookingSelectedDate = value;
        _scheduleResponseData = res;
        _selectedArtistTimeSlot = ["00","00"];
        notifyListeners();
  }
  
  bool isTimeSlotAvialable(String timeSlot){
      for(var e in _scheduleResponseData.timeSlotsVisible!){
         if(e[0] == timeSlot) return true;
      }
      return false;
  }

  void setScheduleResponse(ScheduleResponseModel value){
      _scheduleResponseData = value;
      notifyListeners();
  }

  void resetAll(){
    resetFinalMultiStaffServices();
    resetFinalSingleStaffArtist();
    _selectedArtistTimeSlot = ["00","00"];
    _bookingSelectedDate = DateTime(1999);
    _selectedStaffIndex = -1;
    //_finalMultiStaffSelectedServices.clear();
    ///_finalSingleStaffSelectedServices.clear();
  }
  
  List<ServicesArtistItemModel> getSelectedServiceData(){
     if(_selectedStaffIndex == 0){
         return _finalSingleStaffSelectedServices;
     }
     return _finalMultiStaffSelectedServices;
  }

  void addFinalSingleStaffServices(ArtistDataModel value){
      _singleStaffArtistSelected = value;
      _finalSingleStaffSelectedServices.clear();

      for(var e in _selectedServices){
         for(var s in value.services!){
             if(e.service!.id == s.serviceId){
                 _finalSingleStaffSelectedServices.add(ServicesArtistItemModel(
                  artist: value.id,
                  service: (e.service?.variables?.isEmpty ?? false) ? s.serviceId : null,
                  variable: (e.service?.variables?.isNotEmpty ?? false) ? e.service!.variables!.first : null
                ));
             }
         }
      }
      notifyListeners();
  }

  void addFinalMultiStaffServices(int serviceIndex,ArtistDataModel value){
      if(serviceIndex < _finalMultiStaffSelectedServices.length){
           final service = _selectedServices[serviceIndex].service;
           _finalMultiStaffSelectedServices[serviceIndex] = ServicesArtistItemModel(
                  artist: value.id,
                  service: (service?.variables?.isEmpty ?? false) ? (service?.id ?? "0000") : null,
                  variable: (service?.variables?.isNotEmpty ?? false) ? service!.variables!.first : null
            );
      }
      notifyListeners();
  }
  
  bool checkIsSingleStaffSelected(){
     if(_singleStaffArtistSelected.id == "0000") return false;
     return true;
  }
  
  void resetFinalMultiStaffServices(){
      _finalMultiStaffSelectedServices = List.filled(_selectedServices.length, ServicesArtistItemModel(
          artist: "0000",
          service: "0000",
          variable: VariableService()
      ));
  }

  void resetFinalSingleStaffArtist(){
      _singleStaffArtistSelected = ArtistDataModel(id: "0000");
  }

  bool checkIsMultiStaffSelected(){
     for(var e in finalMultiStaffSelectedServices){
       if(e.artist == "0000") return false;
     }
     return true;
  }

  bool isSingleSatffArtistSelected(String value){
    if(_singleStaffArtistSelected.id == value) return true;
    return false;
  }

  bool isMultiSatffArtistSelected(int serviceIndex,String value){
    if(_finalMultiStaffSelectedServices[serviceIndex].artist == value) return true;
    return false;
  }

  void setVariableSelected(VariableService value){
      _variableSelected = value;
      notifyListeners();
  }

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
          if(e.service?.variables?.isNotEmpty ?? false){
             _totalPrice -= e.service?.variables?.first.variableCutPrice ?? 0;
             _totalDiscountPrice -= e.service?.variables?.first.variablePrice ?? 0;
          }else{
             _totalPrice -= value.cutPrice ?? 0;
             _totalDiscountPrice -= value.basePrice ?? 0;
          }
          _selectedServices.remove(e);
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
    
    if(value.variables?.isNotEmpty ?? false){
      _totalPrice += value.variables?.first.variableCutPrice ?? 0;
      _totalDiscountPrice += value.variables?.first.variablePrice ?? 0;
    }else{
      _totalPrice += value.cutPrice ?? 0;
      _totalDiscountPrice += value.basePrice ?? 0;
    }

    notifyListeners();
  }
  
  void removeService(ServiceDataModel value){
      _selectedServices.removeWhere((element) {
         if(element.service!.id == value.id){
             if(element.service?.variables?.isNotEmpty ?? false){
                  _totalPrice -= element.service?.variables?.first.variableCutPrice ?? 0;
                  _totalDiscountPrice -= element.service?.variables?.first.variablePrice ?? 0;
              }else{
                  _totalPrice -= value.cutPrice ?? 0;
                  _totalDiscountPrice -= value.basePrice ?? 0;
              }
              return true;
         }
         return false;
      });
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
  
}