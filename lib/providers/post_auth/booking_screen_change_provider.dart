import 'package:flutter/material.dart';

class BookingScreenChangeProvider with ChangeNotifier {
   int _screenIndex = 0;
   int get screenIndex => _screenIndex;

   void setScreenIndex(int idx){
     _screenIndex = idx;
     notifyListeners();
   }
}