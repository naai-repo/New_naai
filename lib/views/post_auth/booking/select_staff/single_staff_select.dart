import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:naai/models/utility/single_staff_services_model.dart';
import 'package:naai/providers/post_auth/booking_services_salon_provider.dart';
import 'package:naai/utils/constants/colors_constant.dart';
import 'package:provider/provider.dart';

class SingleStaffSelect extends StatefulWidget {
  const SingleStaffSelect({super.key});

  @override
  State<SingleStaffSelect> createState() => _SingleStaffSelectState();
}

class _SingleStaffSelectState extends State<SingleStaffSelect> {
  
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    final ref = Provider.of<BookingServicesSalonProvider>(context,listen: true);
    SingleStaffServicesModel singleServices = ref.getSingleStaffServicesAndArtists();


    bool isSelected = (ref.selectedStaffIndex == 0);
    String selectedArtistName =  "Choose a Staff";
    // if(ref.singleStaffArtistSelected.id != "0000"){
    //     selectedArtistName = ref.singleStaffArtistSelected.name ?? "Choose a Staff";
    // }

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
                  WidgetSpan(child: Icon(Icons.person,size: 20.sp,)),
                  WidgetSpan(child: SizedBox(width: 10.w)),
                  const TextSpan(text: "Single Staff for all Service")
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
                    children: [
                      InkWell(
                        onTap: ()async {
                           ref.setStaffIndex(0);
                        },
                        borderRadius: BorderRadius.circular(10.r),
                        child: Container(
                          padding: EdgeInsets.all(10.w),
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
                          
                               Radio(
                                 value: (isSelected) ? 1 : 0, 
                                 groupValue: 1, 
                                 activeColor: ColorsConstant.appColor,
                                 onChanged: (vv){
                                   ref.setStaffIndex(0);
                                 }
                               )
                            ],
                          ),
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 100),
                        constraints: BoxConstraints(maxHeight: (isSelected) ? 250.h : 0.h),
                        child: Scrollbar(
                          thumbVisibility: false,
                          trackVisibility: false,
                          thickness: 3.w,
                          child: ListView.builder(
                            itemCount: singleServices.artists!.length,
                            shrinkWrap: true,  
                            physics: const ScrollPhysics(),
                            primary: false,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (contex,index){
                                  String artitstName = singleServices.artists?[index].name ?? "Artist Name";
                                  double rating = singleServices.artists?[index].rating ?? 0;
                                  bool isSelected = ref.isSingleSatffArtistSelected(singleServices.artists?[index].id ?? "");

                                  return InkWell(
                                    onTap: () async {
                                        if(!isSelected){
                                            ref.addFinalSingleStaffServices(singleServices.artists![index]);
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
                                                    value: isSelected ? 1 : 0, 
                                                    groupValue: 1, 
                                                    activeColor: ColorsConstant.appColor,
                                                    onChanged: (vv){}
                                                  )
                                                ),
                                                WidgetSpan(child: SizedBox(width: 0.w)),
                                                TextSpan(text: artitstName)
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
                ),
                       ),
           )
        ],
      ),
    );
  }

}