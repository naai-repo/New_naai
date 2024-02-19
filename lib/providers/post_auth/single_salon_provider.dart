import 'package:flutter/material.dart';
import 'package:naai/models/api_models/single_salon_model.dart';

class SingleSalonProvider with ChangeNotifier{
   late SingleSalonResponseModel _salonDetials;
   SingleSalonResponseModel get salonDetials => _salonDetials;
   
   void setSalonDetails(SingleSalonResponseModel value){
       _salonDetials = value;
       notifyListeners();
   }
}