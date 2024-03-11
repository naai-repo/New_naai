import 'package:flutter/material.dart';
import 'package:naai/models/api_models/artist_item_model.dart';
import 'package:naai/models/api_models/booking_appointment_model.dart';
import 'package:naai/models/api_models/confirm_booking_model.dart';
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

  bool _isFromArtistScreen = false;
  bool get isFromArtistScreen => _isFromArtistScreen;

  int _selectedStaffIndex = -1;
  int get selectedStaffIndex => _selectedStaffIndex;
  
  BookingAppointmentResponseModel _appointmentResponseModel = BookingAppointmentResponseModel(totalTime: 0);
  BookingAppointmentResponseModel get appointmentResponseModel => _appointmentResponseModel;
  
  ConfirmBookingModel _confirmBookingModel = ConfirmBookingModel(status: "false");
  ConfirmBookingModel get confirmBookingModel => _confirmBookingModel;

  VariableService _variableSelected = VariableService(id: "0000",variableCutPrice: 0,variablePrice: 0);
  VariableService get variableSelected => _variableSelected;

  List<ServicesArtistItemModel> _finalSingleStaffSelectedServices = [];
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
        
        final services = getSelectedServiceData();
        for(var e in services){
           if(e.variable != null){
               for(var s in res.timeSlots!){
                  for(int i = 0;i < s.order.length;i++){
                     if(s.order[i].service!.id == e.service){
                          final slots = res.timeSlots!;
                          res = res.copyWith(timeSlots: List.generate(slots.length, (index) {
                              return TimeSlotResponseTimeSlot(key: slots[index].key, possible: slots[index].possible, timeSlot: slots[index].timeSlot, order: List.generate(slots[index].order.length, (idx) {
                                return Order(
                                     artist: slots[index].order[idx].artist,
                                     time: slots[index].order[idx].time,
                                     service: slots[index].order[idx].service,
                                     variable: VariableSchedule(
                                        id: e.variable!.id,
                                        variableCutPrice: e.variable!.variableCutPrice,
                                        variableName: e.variable!.variableName,
                                        variablePrice: e.variable!.variablePrice,
                                        variableTime: e.variable!.variableTime!.toDouble(),
                                        variableType: e.variable!.variableType
                                     )
                                );
                              }));
                          }));
                          break;
                     }
                  }
               }
           }
        }
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

  void resetAll({bool notify = false}){
    resetFinalMultiStaffServices();
    resetFinalSingleStaffArtist();

    _selectedArtistTimeSlot = ["00","00"];
    _bookingSelectedDate = DateTime(1999);
    _selectedStaffIndex = -1;
    _isFromArtistScreen = false;
    _confirmBookingModel = ConfirmBookingModel(status: "false");
    _scheduleResponseData = ScheduleResponseModel(salonId: "0000");

    _selectedServices.clear();
    _totalPrice = 0;
    _totalDiscountPrice = 0;
    
    if(notify) notifyListeners();
  }

  void resetSelectSlotAndSlot(){
    _selectedArtistTimeSlot = ["00","00"];
    _bookingSelectedDate = DateTime(1999);
    notifyListeners();
  }
  
  List<ServicesArtistItemModel> getSelectedServiceData(){
     if(_selectedStaffIndex == 0){
         return _finalSingleStaffSelectedServices;
     }
     return _finalMultiStaffSelectedServices;
  }

  void addFinalSingleStaffServices(ArtistDataModel value){
      resetFinalSingleStaffArtist();
      _singleStaffArtistSelected = value;

      //print("${selectedServices.length} - ${_finalSingleStaffSelectedServices.length}");
      for(int i = 0;i < _selectedServices.length;i++){
           final currentService = _selectedServices[i];
    

           for(var s in (value.services ?? [])){
             if(currentService.service!.id == s.serviceId){
                _finalSingleStaffSelectedServices[i] = ServicesArtistItemModel(
                  artist: value.id,
                  service: currentService.service!.id,
                  variable: (currentService.service?.variables?.isNotEmpty ?? false) ? currentService.service!.variables!.first : null
                );
                break;
             }else {
                _finalSingleStaffSelectedServices[i] = ServicesArtistItemModel(
                  artist: "000000000000000000000000",
                  service: currentService.service!.id,
                  variable: (currentService.service?.variables?.isNotEmpty ?? false) ? currentService.service!.variables!.first : null
                );
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
                  service: (service?.id ?? "0000"),
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
      _finalSingleStaffSelectedServices = List.filled(_selectedServices.length, ServicesArtistItemModel(
          artist: "0000",
          service: "0000",
          variable: VariableService()
      ));
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
    if(_finalMultiStaffSelectedServices.length != _selectedServices.length) resetFinalMultiStaffServices();
    if(_finalMultiStaffSelectedServices[serviceIndex].artist == value) return true;
    return false;
  }

  void setVariableSelected(VariableService value){
      _variableSelected = value;
      notifyListeners();
  }

  void setSalonDetails(SingleSalonResponseModel value){
      _salonDetails = value;
      resetFinalSingleStaffArtist();
      resetFinalMultiStaffServices();
  }

  void setStaffIndex(int idx){
     _selectedStaffIndex = idx;
     notifyListeners();
  }
  
  void addService(ServiceDataModel value,{bool isFromArtistScreen = false}){
    if(isFromArtistScreen) _selectedStaffIndex = 0;
    _isFromArtistScreen = isFromArtistScreen;

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
  
  String getSelectedServiceNameById(String serviceId){
     for(var e in _selectedServices){
        if(e.service!.id == serviceId) return e.service?.serviceTitle ?? "";
     }
     return "";
  }

  List<double> getSelectedServiceAmountById(String serviceId,{String variableId = ""}){
    double serviceBasePrice = 9999, serviceCutPrice = 9999;

    final service = _selectedServices.singleWhere((element) => element.service!.id == serviceId);

    serviceBasePrice = service.service?.basePrice ?? 9999;
    serviceCutPrice = service.service?.cutPrice ?? 9999;

    if(variableId.isNotEmpty && (service.service?.variables?.isNotEmpty ?? false)){
        final variable = service.service!.variables!.singleWhere((element) => element.id == variableId);
        serviceBasePrice = variable.variablePrice ?? 9999;
        serviceCutPrice = variable.variableCutPrice ?? 9999;
    }

     return [serviceBasePrice,serviceCutPrice];
  }

  List<double> getSelectedServiceArtistAmountById(String serviceId,String artistId,{String variableId = ""}){
    double artistBasePrice = 9999, artistCutPrice = 9999;

     for(var e in _selectedServices){
      if(e.service!.id != serviceId) continue;
      
       for(var a in e.artists!){
          if(a.id == artistId){
              final s = a.services!.singleWhere((element) => element.serviceId == serviceId);
              artistBasePrice = double.tryParse(s.price.toString()) ?? 9999;
              artistCutPrice = double.tryParse(s.cutPrice.toString()) ?? e.service!.cutPrice!;
              print(s);

              print("${artistBasePrice} -- ${double.tryParse(s.cutPrice.toString())} -- ${e.service!.cutPrice!}");

              if(variableId.isNotEmpty){
                  final variable = s.variables!.singleWhere((element) => element.variableId == variableId);
                  artistBasePrice = double.tryParse(variable.price.toString()) ?? 9999;
                  artistCutPrice = double.tryParse(variable.cutPrice.toString()) ?? e.service!.cutPrice!;
              }

              return [artistBasePrice,artistCutPrice];
          }
       }
     }

     return [artistBasePrice,artistCutPrice];
  }

  String getSelectedServiceArtistNameById(String artistId){
     for(var e in _selectedServices){
        for(var a in e.artists!){
            if(a.id == artistId) return a.name ?? "Random Artist";
        }
     }
     return "Random Artist";
  }

  void setMakeAppointmentData(BookingAppointmentResponseModel value){
    _appointmentResponseModel = value;
    final finalServices = getSelectedServiceData();

    for(int i = 0;i < finalServices.length;i++){
        final e = finalServices[i];
        if(e.artist == "000000000000000000000000"){
           //print("${e.artist} - ${e.service}");

            final services = value.booking?.artistServiceMap ?? [];
            for(var s in services){
               if(s.serviceId == e.service){
                  finalServices[i] = finalServices[i].copyWith(artist: s.artistId);
                  //print(finalServices[i]);
               }
            }
          
        }
     }
    
    if(_selectedStaffIndex == 0){
      _finalSingleStaffSelectedServices = finalServices;
    }else{
      _finalMultiStaffSelectedServices = finalServices;
    }

    notifyListeners();
  }

  void setConfirmBookingModel(ConfirmBookingModel value){
     _confirmBookingModel = value;
     notifyListeners();
  }
  
}