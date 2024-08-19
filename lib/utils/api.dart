import 'dart:convert';
import 'dart:io';
import 'package:bus_ticket_reservation_app/utils/hiveBoxKeys.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:bus_ticket_reservation_app/utils/ErrorMessageKeys.dart';
import 'package:bus_ticket_reservation_app/utils/internetConnectivity.dart';
import 'package:bus_ticket_reservation_app/utils/strings.dart';

import 'constant.dart';

class ApiMessageAndCodeException implements Exception {
  final String errorMessage;

  ApiMessageAndCodeException({required this.errorMessage});

  Map toError() => {"message": errorMessage};

  @override
  String toString() => errorMessage;
}

class ApiException implements Exception {
  String errorMessage;

  ApiException(this.errorMessage);

  @override
  String toString() {
    return errorMessage;
  }
}

class Api {
  static String getToken() {
    final claimSet = JwtClaim(issuedAt: DateTime.now(), issuer: "WRTEAM", subject: "WRTEAM Authentication");
    String token = issueJwtHS256(claimSet, jwtKey);
    debugPrint("token $token");
    return token;
  }

  static String getNewToken() {
    var box = Hive.box(authBoxKey);
    String token = box.get(tokenKey);
    //debugPrint("api key $token");
    return token;
  }

  static String getApiKey() {
    var box = Hive.box(authBoxKey);
    String token = box.get(apiKey);
    //debugPrint("api key $token");
    return token;
  }



  static Map<String, String> get headers => {
        "Authorization": 'Bearer ${getToken()}',
      };

  static Map<String, String> get newHeaders => {
        "X-Api-key": getNewToken().isNotEmpty ? getNewToken() : getApiKey(),
        "X-Device": Platform.isAndroid ? "Android" : "iOS"
      };

  static Map<String, String> get _headers => {
    "Accept": "application/json",
    "Content-Type": "application/json; charset=UTF-8"
  };

  static Map<String, String> get _registerHeaders => {
    "X-Antm-Company-Context": "25c992b6-080c-11ec-8d7d-34c93d751fac"
  };

//access key for access api
  static String accessKey = "5670";

  //all apis list

  static String signInApi = '$base_url/auth/login';
  static String registerApi = '$base_url/users';
  static String getCitiesApi = '$base_url/cities';
  static String getRouteApi = '$base_url/departures';
  static String getPassengerCategoryApi = '$base_url/passengerCategories/company/';
  static String commandApi = '$base_url/commands';
  static String passengerApi = '/passengers';
  static String placeInfoApi = '/placeInformations';
  static String placeRepresentation = '/representation';
  static String seatsApi = '/seats';
  static String details = '/details';
  static String pay = '/pay';
  static String availablePayment = '/paymentMethods';
  static String startPayment = '/paymentStarted';
  static String tickets = '/tickets';
  static String otp = '/payments';

  static Future<Map<String, dynamic>> post({
    required Map<String, dynamic> body,
    required String url,
  }) async {
    try {
      if (await InternetConnectivity.isNetworkAvailable() == false) {
        throw const SocketException(ErrorMessageKeys.noInternet);
      }
      final Dio dio = Dio();
      debugPrint("Requested APi - $url & params are $body");

      final response = await dio.post(url, data: jsonEncode(body), options: Options(headers: _headers));
      //debugPrint("Response status code: ${response.statusCode}");
      if (response.statusCode == 500) {
        debugPrint("APi exception msg - ${response.data['message']}");
        throw ApiException(response.data['message']);
      }
      //debugPrint("response ======++> $response");
      return Map.from(response.data);
    } on DioException catch (e) {
      debugPrint("Dio Error - ${e.toString()}");
      throw ApiException(e.error is SocketException ? ErrorMessageKeys.noInternet : ErrorMessageKeys.defaultErrorMessage);
    } on SocketException catch (e) {
      debugPrint("Socket exception - ${e.toString()}");
      throw SocketException(e.message);
    } on ApiException catch (e) {
      debugPrint("APi Exception - ${e.toString()}");
      throw ApiException(e.errorMessage);
    } catch (e) {
      debugPrint("catch exception- ${e.toString()}");
      throw ApiException(ErrorMessageKeys.defaultErrorMessage);
    }
  }
  static Future<dynamic> normalPost({
    required Map<String, dynamic> body,
    required String url,
  }) async {
    try {
      if (await InternetConnectivity.isNetworkAvailable() == false) {
        throw const SocketException(ErrorMessageKeys.noInternet);
      }
      final Dio dio = Dio();
      debugPrint("Requested APi - $url & params are $body === headers is $newHeaders");

      final response = await dio.post(url, data: jsonEncode(body), options: Options(headers: newHeaders));
      debugPrint("Response status code: ${response.statusCode}");
      if (response.statusCode == 500) {
        debugPrint("APi exception msg - ${response.data['message']}");
        throw ApiException(response.data['message']);
      }


      if(response.data != ""){
        debugPrint("response ======++> $response");
        return Map.from(response.data);
      }
      else{
        return response;
      }

    } on DioException catch (e) {
      debugPrint("Dio Error - ${e.toString()}");
      throw ApiException(e.error is SocketException ? ErrorMessageKeys.noInternet : ErrorMessageKeys.defaultErrorMessage);
    } on SocketException catch (e) {
      debugPrint("Socket exception - ${e.toString()}");
      throw SocketException(e.message);
    } on ApiException catch (e) {
      debugPrint("APi Exception - ${e.toString()}");
      throw ApiException(e.errorMessage);
    } catch (e) {
      debugPrint("catch exception- ${e.toString()}");
      throw ApiException(ErrorMessageKeys.defaultErrorMessage);
    }
  }

  static Future<dynamic> newPost({
    required Map<String, dynamic> body,
    required String url,
    bool? isAuth
  }) async {
    try {
      if (await InternetConnectivity.isNetworkAvailable() == false) {
        throw const SocketException(ErrorMessageKeys.noInternet);
      }
      final Dio dio = Dio();
      debugPrint("Requested APi - $url & params are $body ");

      final response = await dio.post(url, data: jsonEncode(body), options: Options(headers: (isAuth != null && isAuth) ? _headers : newHeaders, responseType: ResponseType.json, validateStatus: (_) => true) );
      debugPrint("Response   ==============>  ${response.data}");
      if (response.statusCode == 500) {
        debugPrint("APi exception msg - ${response.data['message']}");
        throw ApiException(response.data['message']);
      }
      //debugPrint("response ======++> $response");
      return response.data;
    } on DioException catch (e) {
      debugPrint("Dio Error - ${e.toString()}");
      throw ApiException(e.error is SocketException ? ErrorMessageKeys.noInternet : ErrorMessageKeys.defaultErrorMessage);
    } on SocketException catch (e) {
      debugPrint("Socket exception - ${e.toString()}");
      throw SocketException(e.message);
    } on ApiException catch (e) {
      debugPrint("APi Exception - ${e.toString()}");
      throw ApiException(e.errorMessage);
    } catch (e) {
      debugPrint("catch exception- ${e.toString()}");
      throw ApiException(ErrorMessageKeys.defaultErrorMessage);
    }
  }

  static Future<dynamic> listPost({
    required List<dynamic> body,
    required String url,
  }) async {
    try {
      if (await InternetConnectivity.isNetworkAvailable() == false) {
        throw const SocketException(ErrorMessageKeys.noInternet);
      }
      final Dio dio = Dio();
      debugPrint("Requested APi - $url & params are $body");

      final response = await dio.post(url, data: jsonEncode(body), options: Options(headers: newHeaders) );
      debugPrint("Response status code  ==============>  ${response.statusCode}");
      debugPrint("response ======++> $response");
      if (response.statusCode == 500) {
        debugPrint("APi exception msg - ${response.data['message']}");
        throw ApiException(response.data['message']);
      }

      if(response.statusCode == 200 || response.statusCode == 201){
        return response.data;
      }
      else{
        return null;
      }
    } on DioException catch (e) {
      debugPrint("Dio Error - ${e.toString()}");
      throw ApiException(e.error is SocketException ? ErrorMessageKeys.noInternet : ErrorMessageKeys.defaultErrorMessage);
    } on SocketException catch (e) {
      debugPrint("Socket exception - ${e.toString()}");
      throw SocketException(e.message);
    } on ApiException catch (e) {
      debugPrint("APi Exception - ${e.toString()}");
      throw ApiException(e.errorMessage);
    } catch (e) {
      debugPrint("catch exception- ${e.toString()}");
      throw ApiException(ErrorMessageKeys.defaultErrorMessage);
    }
  }

  static Future registerPost({
    required Map<String, dynamic> body,
    required String url,
  }) async {
    try {
      if (await InternetConnectivity.isNetworkAvailable() == false) {
        throw const SocketException(ErrorMessageKeys.noInternet);
      }
      final Dio dio = Dio();
      debugPrint("Requested APi - $url & params are $body");

      final response = await dio.post(url, data: jsonEncode(body), options: Options(headers: _registerHeaders, validateStatus: (_) => true) );
      debugPrint("Response status code  ==============>  ${response.statusCode}");
      if (response.statusCode == 500) {
        debugPrint("APi exception msg - ${response.data}");
        throw ApiException(response.data);
      }
      debugPrint("Register response ============> ${response.statusCode}");
      debugPrint("response ======++> $response");
      return response.data;
    } on DioException catch (e) {
      debugPrint("Dio Error - ${e.toString()}");
      throw ApiException(e.error is SocketException ? ErrorMessageKeys.noInternet : ErrorMessageKeys.defaultErrorMessage);
    } on SocketException catch (e) {
      debugPrint("Socket exception - ${e.toString()}");
      throw SocketException(e.message);
    } on ApiException catch (e) {
      debugPrint("APi Exception - ${e.toString()}");
      throw ApiException(e.errorMessage);
    } catch (e) {
      debugPrint("catch exception- ${e.toString()}");
      throw ApiException(ErrorMessageKeys.defaultErrorMessage);
    }
  }

  static Future<Map<String, dynamic>> postSettings({
    required Map<String, dynamic> body,
    required String url,
  }) async {
    try {
      if (await InternetConnectivity.isNetworkAvailable() == false) {
        throw const SocketException(ErrorMessageKeys.noInternet);
      }
      final Dio dio = Dio();
      body[ACCESS_KEY] = accessKey;
      final FormData formData = FormData.fromMap(body, ListFormat.multiCompatible);
      debugPrint("Requested APi - $url & params are ${formData.fields}");

      final response = await dio.post(url, data: formData, options: Options(headers: headers));
      if (response.data['error'] == 'true') {
        debugPrint("APi exception msg - ${response.data['message']}");
        throw ApiException(response.data['message']);
      }
      return Map.from(response.data);
    } on DioException catch (e) {
      debugPrint("Dio Error - ${e.toString()}");
      throw ApiException(e.error is SocketException ? ErrorMessageKeys.noInternet : ErrorMessageKeys.defaultErrorMessage);
    } on SocketException catch (e) {
      debugPrint("Socket exception - ${e.toString()}");
      throw SocketException(e.message);
    } on ApiException catch (e) {
      debugPrint("APi Exception - ${e.toString()}");
      throw ApiException(e.errorMessage);
    } catch (e) {
      debugPrint("catch exception- ${e.toString()}");
      throw ApiException(ErrorMessageKeys.defaultErrorMessage);
    }
  }

  static Future<dynamic> get({
    required String url,
  }) async {
    debugPrint("Requested APi - $url & params are: headers ====> $newHeaders ");
    try {
      if (await InternetConnectivity.isNetworkAvailable() == false) {
        throw const SocketException(ErrorMessageKeys.noInternet);
      }
      final Dio dio = Dio();

      final response = await dio.get(url,  options: Options(headers: newHeaders, responseType: ResponseType.json, validateStatus: (_) => true) );
      debugPrint("Response status code  ==============>  ${response.statusCode}");
      if (response.statusCode == 500) {
        debugPrint("APi exception msg - ${response.data['message']}");
        throw ApiException(response.data['message']);
      }
      //debugPrint("response ======++> ${response.data}");
      return response.data;
    } on DioException catch (e) {
      debugPrint("Dio Error - ${e.toString()}");
      throw ApiException(e.error is SocketException ? ErrorMessageKeys.noInternet : ErrorMessageKeys.defaultErrorMessage);
    } on SocketException catch (e) {
      debugPrint("Socket exception - ${e.toString()}");
      throw SocketException(e.message);
    } on ApiException catch (e) {
      debugPrint("APi Exception - ${e.toString()}");
      throw ApiException(e.errorMessage);
    } catch (e) {
      debugPrint("catch exception- ${e.toString()}");
      throw ApiException(ErrorMessageKeys.defaultErrorMessage);
    }
  }

  static Future<dynamic> noReturnPost({
    required Map<String, dynamic> body,
    required String url,
  }) async {
    try {
      if (await InternetConnectivity.isNetworkAvailable() == false) {
        throw const SocketException(ErrorMessageKeys.noInternet);
      }
      final Dio dio = Dio();
      debugPrint("Requested APi - $url & params are $body === headers is $newHeaders");

      final response = await dio.post(url, data: jsonEncode(body), options: Options(headers: newHeaders));
      debugPrint("Response status code: ${response.statusCode}");
      if (response.statusCode == 500) {
        debugPrint("APi exception msg - ${response.data['message']}");
        throw ApiException(response.data['message']);
      }
      if(response.statusCode != 200) {
        return "not success";
      }
      else{
        return "success";
      }
    } on DioException catch (e) {
      debugPrint("Dio Error - ${e.toString()}");
      throw ApiException(e.error is SocketException ? ErrorMessageKeys.noInternet : ErrorMessageKeys.defaultErrorMessage);
    } on SocketException catch (e) {
      debugPrint("Socket exception - ${e.toString()}");
      throw SocketException(e.message);
    } on ApiException catch (e) {
      debugPrint("APi Exception - ${e.toString()}");
      throw ApiException(e.errorMessage);
    } catch (e) {
      debugPrint("catch exception- ${e.toString()}");
      throw ApiException(ErrorMessageKeys.defaultErrorMessage);
    }
  }

}
