import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:naai/models/api_models/artist_item_model.dart';
import 'package:naai/models/api_models/artist_model.dart';
import 'package:naai/models/api_models/service_item_model.dart';
import 'package:naai/models/api_models/single_artist_model.dart';
import 'package:naai/models/api_models/single_salon_model.dart';
import 'package:naai/models/api_models/top_artist_model.dart';
import 'package:naai/models/utility/single_artist_screen_model.dart';
import 'package:naai/services/salons/salons_service.dart';
import 'package:naai/utils/constants/api_constant.dart';

class ArtistsServices {
  static Dio dio = Dio();

  static Future<List<TopArtistResponseModel>> getArtistsByRating({required List<double> coords,required int page,required int limit,required String type,required int min}) async {
    final apiUrl = "${UrlConstants.artistFilter}?page=${page.toString()}&limit=${limit.toString()}&filter=rating&min=${min.toString()}&type=$type";

     final Map<String, dynamic> requestData = {
      "location": {"type": "Point", "coordinates": coords},
    };

    try {
      dio.options.connectTimeout = const Duration(seconds: 10);
      final response = await dio.post(
        apiUrl,
        options: Options(headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        }),
        data: requestData,
      );

      if (response.statusCode == 200) {
        ArtistResponseModel artistApiResponse = ArtistResponseModel.fromJson(jsonEncode(response.data).replaceAll("_id", "id"));

        List<TopArtistResponseModel> res = [];
        List<Future<SingleSalonResponseModel>> salonRequests = [];
        List<ArtistDataModel> artistsDetails = [];

        for (var artistData in artistApiResponse.data){
          salonRequests.add(SalonsServices.getSalonByID(salonId: artistData.salonId ?? ""));
          artistsDetails.add(artistData);
        }

        final salonResponses = await Future.wait(salonRequests);

        salonResponses.asMap().forEach((i, salonRes) {
          res.add(TopArtistResponseModel(
              artistDetails: artistsDetails[i],
              salonDetails: salonRes
          ));
        });

        return res;
      } else {
        throw ErrorDescription(jsonEncode(response.data));
      }
    } catch (e,stacktrace) {
      print(stacktrace.toString());
      print("Error : ${e.toString()}");
      return [TopArtistResponseModel()];
    }
  } 
  
  static Future<SingleArtistScreenModel> getArtistByID({required String artistId}) async {
    final apiUrl = "${UrlConstants.getSingleArtist}/$artistId";

    try {
      dio.options.connectTimeout = const Duration(seconds: 10);
      final response = await dio.get(apiUrl);
      List<ServiceDataModel> services = [];

      if (response.statusCode == 200) {
        final artistResponse = SingleArtistModel.fromJson(jsonEncode(response.data).replaceAll("_id", "id"));
        final salonResponse = await SalonsServices.getSalonByID(salonId: artistResponse.data?.salonId ?? "");
        
        List<Service> artistServices = artistResponse.data?.services ?? [];
        //artistServices.asMap().forEach((key, value) => services.add(ServiceDataModel.fromMap(value.toMap())));

        artistServices.asMap().forEach((key, value) {
            final serv = salonResponse.data!.services!.singleWhere((element) => element.id == value.serviceId,orElse: () => ServiceDataModel(id: "00"));
            if(serv.id != "00") services.add(serv);
        });
        
        // List<Future<ServiceArtistModel>> servicesRequests = [];
        
        // for(var e in artistServices){
        //     servicesRequests.add(ServicesArtists.getServicesByID(serviceId: e.serviceId ?? ""));
        // }

        // final res = await Future.wait(servicesRequests);

        // for(int i = 0;i < artistServices.length;i++){
        //     services.add(res[i].data ?? ServiceDataModel());
        // }

        return SingleArtistScreenModel(
          artistDetails: artistResponse,
          salonDetails: salonResponse,
          services: services
        );
      }else{
        throw ErrorDescription(jsonEncode(response.data));
      }
    } catch (e,stacktrace) {
      print(stacktrace.toString());
      print("Error : ${e.toString()}");
      return SingleArtistScreenModel();
    }
  } 
  
  static Future<SingleArtistModel> getSimpleArtistByID({required String artistId}) async {
    final apiUrl = "${UrlConstants.getSingleArtist}/$artistId";

    try {
      dio.options.connectTimeout = const Duration(seconds: 10);
      final response = await dio.get(apiUrl);
  
      if (response.statusCode == 200) {
        final artistResponse = SingleArtistModel.fromJson(jsonEncode(response.data).replaceAll("_id", "id"));
        return artistResponse;
      }else{
        throw ErrorDescription(jsonEncode(response.data));
      }
    } catch (e,stacktrace) {
      print(stacktrace.toString());
      print("Error Simple Artist: ${e.toString()}");
      return SingleArtistModel();
    }
  } 
  
  static Future<List<TopArtistResponseModel>> getArtistsByCategory({required List<double> coords,required int page,required int limit,required String type,required String category}) async {
    final apiUrl = "${UrlConstants.getArtistsByCategory}?page=${page.toString()}&limit=${limit.toString()}&name=${category.toString()}${(type.isNotEmpty) ? "&type=$type" : ""}";
    
    final Map<String, dynamic> requestData = {
      "location": {"type": "Point", "coordinates": coords},
    };

    try {
      dio.options.connectTimeout = const Duration(seconds: 10);

      final response = await dio.post(
        apiUrl,
        options: Options(headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        }),
        data: requestData,
      );

      List<TopArtistResponseModel> ans = [];
      List<Future<SingleSalonResponseModel>> salonRequests = [];
      List<ArtistDataModel> artistsDetails = [];

      if (response.statusCode == 200) {
        if((response.data["data"] as dynamic).isNotEmpty){
          for(var e in (response.data["data"]["list"] as dynamic)){
              final artists = ArtistDataModel.fromJson(jsonEncode(e).replaceAll("_id", "id"));
              salonRequests.add(SalonsServices.getSalonByID(salonId: artists.salonId ?? ""));
              artistsDetails.add(artists);
          }

          final salonResponses = await Future.wait(salonRequests);

          salonResponses.asMap().forEach((i, res) {
            ans.add(TopArtistResponseModel(
                artistDetails: artistsDetails[i],
                salonDetails: res
            ));
          });
        }
        return ans;
      }else{
        throw ErrorDescription(jsonEncode(response.data));
      }
    } catch (e,stacktrace) {
      print(stacktrace.toString());
      print("Error : ${e.toString()}");
      return [];
    }
  } 
  
  static Future<List<TopArtistResponseModel>> getTopArtists({required List<double> coords,required int page,required int limit,required String type}) async {
    final apiUrl = "${UrlConstants.topArtist}?page=${page.toString()}&limit=${limit.toString()}${(type.isNotEmpty) ? "&type=$type" : ""}";

    final Map<String, dynamic> requestData = {
      "location": {"type": "Point", "coordinates": coords},
    };

    try {
      dio.options.connectTimeout = const Duration(seconds: 10);
      
      final response = await dio.post(
        apiUrl,
        options: Options(headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        }),
        data: requestData,
      );

      if (response.statusCode == 200) {
        ArtistResponseModel artistApiResponse = ArtistResponseModel.fromJson(jsonEncode(response.data).replaceAll("_id", "id"));

        List<TopArtistResponseModel> res = [];
   
        List<Future<SingleSalonResponseModel>> requests = [];
      
        for (var artistData in artistApiResponse.data){
          requests.add(SalonsServices.getSalonByID(salonId: artistData.salonId ?? ""));
        }

       final resss = await Future.wait(requests);
       
       for(int i = 0;i < artistApiResponse.data.length;i++){
           res.add(TopArtistResponseModel(
             artistDetails: artistApiResponse.data[i],
             salonDetails: resss[i]
          ));
       }

        return res;
      } else {
        throw ErrorDescription(jsonEncode(response.data));
      }
    } catch (e,stacktrace) {
    //  print(stacktrace.toString());
    //  print("Error : ${e.toString()}");
      return [];
    }
  }
  
}