import 'package:flutter/material.dart';
import 'package:naai/models/api_models/service_artist_model.dart';
import 'package:naai/models/api_models/single_artist_model.dart';
import 'package:naai/models/api_models/single_salon_model.dart';
import 'package:naai/models/utility/booking_info_model.dart';
import 'package:naai/providers/pre_auth/auth_provider.dart';
import 'package:naai/services/artists/artist_services.dart';
import 'package:naai/services/booking/booking_services.dart';
import 'package:naai/services/salons/salons_service.dart';
import 'package:naai/services/services_artists/services_artist.dart';
import 'package:provider/provider.dart';

class BookingAppointmentsController {

  static Future<BookingInfoModel> getBookingsForHistory(BuildContext context,int page,int limit) async {
    final authRef = Provider.of<AuthenticationProvider>(context,listen: false);
    String token = await authRef.getAccessToken();
    String userId = await authRef.getUserId();
    final resBookings = await BookingServices.getBookings(userId: userId, accessToken: token, page: page, limit: limit);
    
   // print(resBookings);

    final List<BookingInfoItemModel> prevBooking = [];
    final List<BookingInfoItemModel> upcommingBookings = [];
    final List<BookingInfoItemModel> currentBookings = [];

    List<Future<SingleSalonResponseModel>> salonRequests = [];
    List<Future<SingleArtistModel>> artistsRequests = []; 
    List<Future<ServiceArtistModel>> servicesRequests = [];

    List<SingleSalonResponseModel> salonResponses = [];
    List<SingleArtistModel> artistRes = [];
    List<ServiceArtistModel> servicesRes = [];
    int idx = 0;


    salonRequests.clear();
    artistsRequests.clear();
    servicesRequests.clear();
    idx = 0;
    
    for(var e in resBookings.coming_bookings!){
        salonRequests.add(SalonsServices.getSalonByID(salonId: e.salonId ?? ""));

        for(var s in e.artistServiceMap!){
          artistsRequests.add(ArtistsServices.getSimpleArtistByID(artistId: s.artistId ?? ""));
          servicesRequests.add(ServicesArtists.getServicesByID(serviceId: s.serviceId ?? ""));
        }
    }

    salonResponses = await Future.wait(salonRequests);
    artistRes = await Future.wait(artistsRequests);
    servicesRes = await Future.wait(servicesRequests);
    print("commings ::: ${salonResponses.length}-${artistRes.length}-${servicesRes.length}");
    
    salonResponses.asMap().forEach((i, salonRes) { 
       final bookings = resBookings.coming_bookings!;
       final artistMap = bookings[i].artistServiceMap ?? [];
       List<BookingInfoArtistServiceMapItemModel> temp = [];
       print("Range :: $idx - ${idx + artistMap.length}");
       final artistRange = artistRes.getRange(idx, idx + artistMap.length).toList();

       artistRange.asMap().forEach((key, res) { 
          temp.add(BookingInfoArtistServiceMapItemModel(
            artist: res,
            artistMap: artistMap[key],
            serviceArtist: servicesRes[key]
          ));
       });

       upcommingBookings.add(BookingInfoItemModel(
          salonDetails: salonRes,
          appointmentData: bookings[i],
          artistMapServices: temp
       ));
       
       idx = idx + artistMap.length;
    });

    salonRequests.clear();
    artistsRequests.clear();
    servicesRequests.clear();
    idx = 0;
    
    for(var e in resBookings.current_bookings!){
        salonRequests.add(SalonsServices.getSalonByID(salonId: e.salonId ?? ""));
        
        for(var s in e.artistServiceMap!){
          artistsRequests.add(ArtistsServices.getSimpleArtistByID(artistId: s.artistId ?? ""));
          servicesRequests.add(ServicesArtists.getServicesByID(serviceId: s.serviceId ?? ""));
        }
    }

    salonResponses = await Future.wait(salonRequests);
    artistRes = await Future.wait(artistsRequests);
    servicesRes = await Future.wait(servicesRequests);

    salonResponses.asMap().forEach((i, salonRes) { 
       final bookings = resBookings.current_bookings!;
       final artistMap = bookings[i].artistServiceMap ?? [];
       List<BookingInfoArtistServiceMapItemModel> temp = [];
      

       final artistRange = artistRes.getRange(idx, idx + artistMap.length).toList();

       artistRange.asMap().forEach((key, res) { 
          temp.add(BookingInfoArtistServiceMapItemModel(
            artist: res,
            artistMap: artistMap[key],
            serviceArtist: servicesRes[key]
          ));
       });

       currentBookings.add(BookingInfoItemModel(
          salonDetails: salonRes,
          appointmentData: bookings[i],
          artistMapServices: temp
       ));
       
       idx = idx + artistMap.length;
    });


    salonRequests.clear();
    artistsRequests.clear();
    servicesRequests.clear();
    idx = 0;
    
    for(var e in resBookings.prev_booking!){
        salonRequests.add(SalonsServices.getSalonByID(salonId: e.salonId ?? ""));
        
        for(var s in e.artistServiceMap!){
          artistsRequests.add(ArtistsServices.getSimpleArtistByID(artistId: s.artistId ?? ""));
          servicesRequests.add(ServicesArtists.getServicesByID(serviceId: s.serviceId ?? ""));
        }
    }

    salonResponses = await Future.wait(salonRequests);
    artistRes = await Future.wait(artistsRequests);
    servicesRes = await Future.wait(servicesRequests);

    salonResponses.asMap().forEach((i, salonRes) { 
       final bookings = resBookings.prev_booking!;
       final artistMap = bookings[i].artistServiceMap ?? [];
       List<BookingInfoArtistServiceMapItemModel> temp = [];
      

       final artistRange = artistRes.getRange(idx, idx + artistMap.length).toList();

       artistRange.asMap().forEach((key, res) { 
          temp.add(BookingInfoArtistServiceMapItemModel(
            artist: res,
            artistMap: artistMap[key],
            serviceArtist: servicesRes[key]
          ));
       });

       prevBooking.add(BookingInfoItemModel(
          salonDetails: salonRes,
          appointmentData: bookings[i],
          artistMapServices: temp
       ));
       
       idx = idx + artistMap.length;
    });


    return BookingInfoModel(
      user: authRef.userData,
      prevBooking: prevBooking,
      upcommingBookings: upcommingBookings,
      currentBookings: currentBookings
    );
  }

}