
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:naai/utils/routing/named_routes.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class Loader {
  static late Timer _timer;
  static showLoader(BuildContext context) {
    showDialog(
        context: context,
        barrierColor: Colors.white.withOpacity(0.3),
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: const Center(
              child: CupertinoActivityIndicator()
            ),
          );
        });
  }

  static hideLoader(BuildContext context) {
    Navigator.pop(context);
  }

}
class AppState extends ChangeNotifier {
  int _keywordState = 1;

  int get keywordState => _keywordState;

  setKeywordState(int newState) {
    _keywordState = newState;
    notifyListeners();
  }
}

class AnimatedSearch extends StatefulWidget {
  // final Function(bool) onSearchExpanded;
  final double width;
  final TextEditingController? textEditingController;
  final IconData? startIcon;
  final IconData? closeIcon;
  final Color? iconColor;
  final Color? cursorColor;
  final Function(String,bool) onChanged; // Add the onChanged callback here
  final InputDecoration? decoration;
  const AnimatedSearch({
    Key? key,
    this.width = 0.7,
    this.textEditingController,
    this.startIcon = Icons.abc,
    this.closeIcon = Icons.close,
    this.iconColor = Colors.white,
    this.cursorColor = Colors.white,
    required this.onChanged,
    this.decoration,
  }) : super(key: key);
  @override
  State<AnimatedSearch> createState() => _AnimatedSearchState();
}

class _AnimatedSearchState extends State<AnimatedSearch> {
  bool isFolded = true;
  int keywordState = 0; // Added keywordState variable

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 7.h,
      width: isFolded ? width / 7 : width * widget.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        color: Colors.white,
        boxShadow: kElevationToShadow[6],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left:3.w),
              child: !isFolded
                  ? TextField(
                controller: widget.textEditingController,
                autofocus: true,
                cursorColor: widget.cursorColor,
                decoration: widget.decoration ??
                    InputDecoration(
                        hintText: 'Searchbbbbbbbbbbbbb',
                        hintStyle: TextStyle(color: Colors.grey[300]),
                        filled: true,
                        fillColor: ColorsConstant.graphicFillDark,
                        border: InputBorder.none),
                onChanged: (String value) {
                  setState(() {
                    print("Typed text: $value");
                  //  widget.textEditingController?.text = value;
                    isFolded = value.isEmpty;
                    context.read<AppState>().setKeywordState(isFolded ? 1 : 0);
                  });
                  widget.onChanged(value,isFolded);

                },
              )
                  : null,
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            child: InkWell(
                onTap: () {
                  setState(() {
                    isFolded = !isFolded;
                    context.read<AppState>().setKeywordState(isFolded ? 1 : 0);
                  });
                },
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 3.5.w),
                  child: Icon(
                    isFolded ? widget.startIcon : widget.closeIcon,
                    color: widget.iconColor,
                    size: 26,
                  ),
                )),
          )
        ],
      ),
    );
  }
}

