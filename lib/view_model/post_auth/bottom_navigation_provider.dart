import 'package:flutter/material.dart';
import 'package:naai/utils/enums.dart';
import 'package:naai/view_model/post_auth/explore/explore_provider.dart';
import 'package:provider/provider.dart';

class BottomNavigationProvider with ChangeNotifier {
  int _currentScreenIndex = 0;
  int _onetimeindex = 3;

  int get currentScreenIndex => _currentScreenIndex;
  int get onetimeindex => _onetimeindex;

  void setCurrentScreenIndex({
    required BuildContext context,
    required int indexValue,
    bool applyServiceFilter = false,
    Services? appliedService,
  }) {
    if (_currentScreenIndex == 1) {
      context.read<ExploreProvider>().clearSalonSearchController();
    }

    if (applyServiceFilter) {
      context.read<ExploreProvider>().setApplyServiceFilter(
            value: applyServiceFilter,
            service: appliedService,
          );
    }

    _onetimeindex = indexValue;
    notifyListeners();
  }
}

