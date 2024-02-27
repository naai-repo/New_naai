import 'package:flutter/material.dart';
import 'package:naai/models/utility/booking_info_model.dart';
import 'package:naai/providers/pre_auth/auth_provider.dart';
import 'package:naai/services/artists/artist_services.dart';
import 'package:naai/services/booking/booking_services.dart';
import 'package:naai/services/salons/salons_service.dart';
import 'package:naai/services/services_artists/services_artist.dart';
import 'package:provider/provider.dart';

class BookingAppointmentsController {

  static Future<BookingInfoModel> getBookings(BuildContext context) async {
    final authRef = Provider.of<AuthenticationProvider>(context,listen: false);
    String token = await authRef.getAccessToken();
    String userId = await authRef.getUserId();
    final resBookings = await BookingServices.getBookings(userId: userId, accessToken: token, page: 1, limit: 2);
    

    final List<BookingInfoItemModel> prevBooking = [];
    final List<BookingInfoItemModel> upcommingBookings = [];
    final List<BookingInfoItemModel> currentBookings = [];

    for(var e in resBookings.coming_bookings!){
        final salonRes = await SalonsServices.getSalonByID(salonId: e.salonId ?? "");
        List<BookingInfoArtistServiceMapItemModel> temp = [];
        for(var s in e.artistServiceMap!){
          final artistRes = await ArtistsServices.getSimpleArtistByID(artistId: s.artistId ?? "");
          final serviceRes = await ServicesArtists.getServicesByID(serviceId: s.serviceId ?? "");
          
          temp.add(BookingInfoArtistServiceMapItemModel(
            artist: artistRes,
            artistMap: s,
            serviceArtist: serviceRes
          ));
        }

        upcommingBookings.add(BookingInfoItemModel(
          salonDetails: salonRes,
          appointmentData: e,
          artistMapServices: temp
        ));
    }
    
    if(upcommingBookings.isEmpty){
      for(var e in resBookings.prev_booking!){
          final salonRes = await SalonsServices.getSalonByID(salonId: e.salonId ?? "");

          List<BookingInfoArtistServiceMapItemModel> temp = [];
          for(var s in e.artistServiceMap!){
            final artistRes = await ArtistsServices.getSimpleArtistByID(artistId: s.artistId ?? "");
            final serviceRes = await ServicesArtists.getServicesByID(serviceId: s.serviceId ?? "");

            temp.add(BookingInfoArtistServiceMapItemModel(
              artist: artistRes,
              artistMap: s,
              serviceArtist: serviceRes
            ));

          }

          prevBooking.add(BookingInfoItemModel(
            salonDetails: salonRes,
            appointmentData: e,
            artistMapServices: temp
          ));
          break;
      }
    }

    // for(var e in resBookings.current_bookings!){
    //     final salonRes = await SalonsServices.getSalonByID(salonId: e.salonId ?? "");
    //     List<BookingInfoArtistServiceMapItemModel> temp = [];
    //     for(var s in e.artistServiceMap!){
    //       final artistRes = await ArtistsServices.getArtistByID(artistId: s.artistId ?? "");
    //       final serviceRes = await ServicesArtists.getServicesByID(serviceId: s.serviceId ?? "");
          
    //       temp.add(BookingInfoArtistServiceMapItemModel(
    //         artist: artistRes.artistDetails,
    //         artistMap: s,
    //         serviceArtist: serviceRes
    //       ));
    //     }

    //     currentBookings.add(BookingInfoItemModel(
    //       salonDetails: salonRes,
    //       appointmentData: e,
    //       artistMapServices: temp
    //     ));
    // }

    return BookingInfoModel(
      user: authRef.userData,
      prevBooking: prevBooking,
      upcommingBookings: upcommingBookings,
      currentBookings: currentBookings
    );
  }

}