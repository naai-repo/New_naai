import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naai/models/api_models/artist_item_model.dart';
import 'package:naai/providers/post_auth/booking_services_salon_provider.dart';
import 'package:naai/utils/constants/colors_constant.dart';
import 'package:naai/utils/constants/image_path_constant.dart';
import 'package:provider/provider.dart';

class MultipleStaffSelect extends StatefulWidget {
  const MultipleStaffSelect({super.key});

  @override
  State<MultipleStaffSelect> createState() => _MultipleStaffSelectState();
}

class _MultipleStaffSelectState extends State<MultipleStaffSelect> {
  

  @override
  Widget build(BuildContext context){
    final ref = Provider.of<BookingServicesSalonProvider>(context,listen: true);
    bool isSelected = (ref.selectedStaffIndex == 1);
    String headingText = "Choose a Multple Staff";

    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text.rich(TextSpan(
             style: TextStyle(
              color:const Color(0xFF868686),
              fontFamily: "Poppins",
              fontSize: 14.sp,
              fontWeight: FontWeight.w500
             ),
             children: [
                  WidgetSpan(child: Icon(Icons.people,size: 20.sp,)),
                  WidgetSpan(child: SizedBox(width: 10.w)),
                  const TextSpan(text: "Multiple Staff for all Service")
             ]
           )),
           SizedBox(height: 15.h),
           Material(
              clipBehavior: Clip.hardEdge,
              borderRadius: BorderRadius.circular(10.r),
              color: Colors.white,
              elevation: 1,
             child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                decoration: BoxDecoration(
                  border: Border.all(color: ColorsConstant.greyBorderColor,width: 0.5.w),
                  borderRadius: BorderRadius.circular(10.r)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: ()async {
                           ref.setStaffIndex(1);
                        },
                        borderRadius: BorderRadius.circular(10.r),
                        child: Container(
                          padding: EdgeInsets.all(10.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                               Text(headingText.toUpperCase(),
                                 style: TextStyle(
                                   fontFamily: "Poppins",
                                   fontSize: 14.sp,
                                   fontWeight: FontWeight.w600
                                 ),
                               ),
                          
                               Radio(
                                 value: (isSelected) ? 1 : 0, 
                                 groupValue: 1, 
                                 activeColor: ColorsConstant.appColor,
                                 onChanged: (vv){
                                    ref.setStaffIndex(1);
                                 }
                               )
                            ],
                          ),
                        ),
                      ),
                      (!isSelected) ? const SizedBox() :
                      SizedBox(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(ref.selectedServices.length, (index){
                              String serviceName = ref.selectedServices[index].service?.serviceTitle ?? "Service Name";
                              String targetGender = ref.selectedServices[index].service?.targetGender ?? "male";
                              double amount = ref.selectedServices[index].service?.basePrice ?? 99999;
                              final finalMultiSelectedServices = ref.getSelectedServiceData();
                              double extraServiceBasePrice = 0;
                              print("Extra Amount Calculations  ${index} -- ${finalMultiSelectedServices.length}");
                           
                              if(index < finalMultiSelectedServices.length){
                                final multiServ = finalMultiSelectedServices[index];
                                final multiArtist = ref.selectedServices[index].artists!.singleWhere((element) => element.id == multiServ.artist,orElse: () => ArtistDataModel(id: "0000"));
                                if(multiArtist.id != "0000"){
                                  final service = multiArtist.services?.singleWhere((element) => element.serviceId == multiServ.service) ?? Service(variables: []);
                                  double selectedArtistBasePrice = double.tryParse(service.price.toString()) ?? 9999;
                                  extraServiceBasePrice = selectedArtistBasePrice - amount;
                                  print("${selectedArtistBasePrice} -- ${extraServiceBasePrice}");
                                }
                              }
                             
                              return Container(
                                padding: EdgeInsets.all(15.w),
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: ColorsConstant.greyBorderColor,width: 0.5.w))
                                ),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text.rich(TextSpan(
                                                children: [
                                                   WidgetSpan(
                                                    alignment: PlaceholderAlignment.middle,
                                                    child: SvgPicture.asset(
                                                      targetGender == "male"
                                                          ? ImagePathConstant.manIcon
                                                          : ImagePathConstant.womanIcon,
                                                      height: 30.h,
                                                    )),
                                                    WidgetSpan(child: SizedBox(width: 10.w,)),

                                                    TextSpan(text: serviceName.toUpperCase(),
                                                     style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontSize: 16.sp,
                                                      fontWeight: FontWeight.w500
                                                     )
                                                    )
                                                ]
                                              )),
                                              SizedBox(height: 10.h),
                                              Text.rich(TextSpan(
                                                children: [   
                                                    TextSpan(text: "Rs. $amount",
                                                     style: TextStyle(
                                                            fontFamily: "Poppins",
                                                            fontSize: 16.sp,
                                                            fontWeight: FontWeight.w500
                                                      )
                                                    ),
                                                    if(extraServiceBasePrice > 0) WidgetSpan(child: SizedBox(width: 5.w,)),

                                                    if(extraServiceBasePrice > 0) TextSpan(
                                                      text: "+ ${extraServiceBasePrice}",
                                                      style: TextStyle(
                                                        fontFamily: "Poppins",
                                                        fontWeight: FontWeight.w500,
                                                        color: ColorsConstant.appColor
                                                      )
                                                    )
                                                ]
                                              )),
                                            ],
                                          ),
                                      ),
                                      SizedBox(height: 20.h),
                                      ChooseAStaff(index: index),
                                      SizedBox(height: 20.h),
                                    ],
                                ),
                              );
                          }),
                        ),
                      ),
                    ],
                )),
           ),
           SizedBox(height: 50.h),
        ],
      ),
    );
  }

}

class ChooseAStaff extends StatefulWidget {
  final int index;
  const ChooseAStaff({super.key,required this.index});

  @override
  State<ChooseAStaff> createState() => _ChooseAStaffState();
}

class _ChooseAStaffState extends State<ChooseAStaff> {
  bool isCollapse = true;
  String selectedArtistName = "Choose a Staff";

  @override
  void initState() {
    isCollapse = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    final ref = Provider.of<BookingServicesSalonProvider>(context,listen: false);
    print("Multi Aritst Length : ${ref.selectedServices[widget.index].artists!.length}");
    final artists = ref.selectedServices[widget.index].artists ?? [];
    final selectedServiceId = ref.selectedServices[widget.index].service?.id ?? "";
    final double serviceBasePrice = ref.selectedServices[widget.index].service?.basePrice ?? 9999;
    //final double serviceCutPrice = ref.selectedServices[widget.index].service?.cutPrice ?? 9999;
    
    return SizedBox(
      child: Material(
         clipBehavior: Clip.hardEdge,
         borderRadius: BorderRadius.circular(10.r),
         color: Colors.white,
         elevation: 1,
        child: Container(
           decoration: BoxDecoration(
             border: Border.all(color: ColorsConstant.greyBorderColor,width: 0.5.w),
             borderRadius: BorderRadius.circular(10.r)
           ),
           child: Column(
               children: [
                 InkWell(
                   onTap: (){
                     setState(() {
                        isCollapse = !isCollapse;
                     });
                   },
                   borderRadius: BorderRadius.circular(10.r),
                   child: Container(
                     padding: EdgeInsets.all(15.w),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       crossAxisAlignment: CrossAxisAlignment.center,
                       children: [
                          Text(selectedArtistName.toUpperCase(),
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                     
                          Icon((isCollapse) ? Icons.arrow_drop_down : Icons.arrow_drop_up,color: Colors.black,size: 20.sp)
                       ],
                     ),
                   ),
                 ),
                 AnimatedContainer(
                   duration: const Duration(milliseconds: 200),
                   constraints: BoxConstraints(maxHeight: (isCollapse) ? 0.h : 250.h),
                   child: Scrollbar(
                     thumbVisibility: false,
                     trackVisibility: false,
                     thickness: 3.w,
                     child: ListView.builder(
                       itemCount: artists.length,
                       shrinkWrap: true,  
                       scrollDirection: Axis.vertical,
                       itemBuilder: (contex,idx){
                             String artitstName = artists[idx].name ?? "Artist Name";
                             double rating = artists[idx].rating ?? 0;
                             bool isSelected = ref.isMultiSatffArtistSelected(widget.index,artists[idx].id ?? "");
                             final service = artists[idx].services?.singleWhere((element) => element.serviceId == selectedServiceId) ?? Service(variables: []);
                             double artistBasePrice = double.tryParse(service.price.toString()) ?? 9999;
                             
                             //double artistCutPrice = double.tryParse(service.cutPrice.toString()) ?? 9999;
                            // print(artists[idx]);
                             
                            // print("Artist base p :: ${artistBasePrice}");
                             //print("Artist cut p :: ${artistCutPrice}");

                             double artistExtaBasePrice = artistBasePrice - serviceBasePrice;
                             bool extraPriceWillShow = (serviceBasePrice != artistBasePrice);

                             return InkWell(
                               onTap: () async {
                                       if(!isSelected){
                                            setState(() {
                                              selectedArtistName = artitstName;
                                              isCollapse = true;
                                              ref.addFinalMultiStaffServices(widget.index, artists[idx]);
                                            });
                                        }
                               },
                               borderRadius: BorderRadius.circular(10.r),
                     
                               child: Container(
                                 padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 5.w),
                                 decoration: BoxDecoration(
                                   border: Border(bottom: BorderSide(color: ColorsConstant.greyBorderColor,width: 0.5.w))
                                 ),
                                 child: Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   crossAxisAlignment: CrossAxisAlignment.center,
                                   children: [
                                     Text.rich(TextSpan(
                                         style: TextStyle(
                                           fontFamily: "Poppins",
                                           fontSize: 14.sp,
                                           color: const Color(0xFF727272),
                                           fontWeight: FontWeight.w500
                                         ),
                                         children: [
                                           WidgetSpan(
                                             alignment: PlaceholderAlignment.middle,
                                             child: Radio(
                                               value: (isSelected) ? 1 : 0, 
                                               groupValue: 1, 
                                               activeColor: ColorsConstant.appColor,
                                               onChanged: (vv){
                                                  if(!isSelected){
                                                      setState(() {
                                                        selectedArtistName = artitstName;
                                                        isCollapse = true;
                                                        ref.addFinalMultiStaffServices(widget.index, artists[idx]);
                                                      });
                                                  }
                                               }
                                             )
                                           ),
                                           WidgetSpan(child: SizedBox(width: 0.w)),
                                           TextSpan(text: artitstName),
                                           if(extraPriceWillShow) WidgetSpan(child: SizedBox(width: 5.w)),
                                           if(extraPriceWillShow) TextSpan(
                                            text: "+ Rs. ${artistExtaBasePrice}",
                                            style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontWeight: FontWeight.w500,
                                              color: ColorsConstant.appColor
                                            )
                                           )
                                         ]
                                     )),
                                             
                                     Text.rich(TextSpan(
                                         style: TextStyle(
                                           fontFamily: "Poppins",
                                           fontSize: 14.sp,
                                           color: Colors.black,
                                           fontWeight: FontWeight.w600
                                         ),
                                         children: [
                                           TextSpan(text: rating.toStringAsFixed(1)),
                                           WidgetSpan(child: SizedBox(width: 5.w)),
                                           WidgetSpan(
                                             child: Icon(Icons.star,color: Colors.amber,size: 22.sp)
                                           ),
                                         ]
                                     ))
                                   ],
                                 ),
                               ),
                             );
                           
                     }),
                   ),
                 )
               ],
           )),
      ),
    );
  }

}

