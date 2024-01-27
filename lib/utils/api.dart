import 'dart:convert';
import 'dart:io';
import 'package:burkina_transport_app/utils/hiveBoxKeys.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:burkina_transport_app/utils/ErrorMessageKeys.dart';
import 'package:burkina_transport_app/utils/internetConnectivity.dart';
import 'package:burkina_transport_app/utils/strings.dart';

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
    //debugPrint("token $token");
    return token;
  }

  static String getNewToken() {
    var box = Hive.box(authBoxKey);
    String token = box.get(tokenKey);
    //debugPrint("token $token");
    return token;
  }



  static Map<String, String> get headers => {
        "Authorization": 'Bearer ${getToken()}',
      };

  static Map<String, String> get newHeaders => {
        "Authorization": 'Bearer ${getNewToken()}',
        "X-Device": Platform.isAndroid ? "Android" : "iOS"
      };

  static Map<String, String> get _headers => {
    "Accept": "application/json",
    "Content-Type": "application/json; charset=UTF-8"
  };

//access key for access api
  static String accessKey = "5670";

  //all apis list
  static String getUserSignUpApi = '${databaseUrl}user_signup';
  static String getNewsApi = '${databaseUrl}get_news';
  static String getNewsByCatApi = '${databaseUrl}get_news_by_category';
  static String getSettingApi = '${databaseUrl}get_settings';
  static String getCatApi = '${databaseUrl}get_category';
  static String getNewsByIdApi = '${databaseUrl}get_news_by_id';
  static String setBookmarkApi = '${databaseUrl}set_bookmark';
  static String getBookmarkApi = '${databaseUrl}get_bookmark';
  static String setCommentApi = '${databaseUrl}set_comment';
  static String getCommentByNewsApi = '${databaseUrl}get_comment_by_news';
  static String getBreakingNewsApi = '${databaseUrl}get_breaking_news';
  static String setProfileApi = '${databaseUrl}set_profile_image';
  static String setUpdateProfileApi = '${databaseUrl}update_profile';
  static String setRegisterToken = '${databaseUrl}register_token';
  static String getNotificationApi = '${databaseUrl}get_notification';
  static String setUserCatApi = '${databaseUrl}set_user_category';
  static String getUserByIdApi = '${databaseUrl}get_user_by_id';
  static String getNewsByUserCatApi = '${databaseUrl}get_news_by_user_category';
  static String setCommentDeleteApi = '${databaseUrl}delete_comment';
  static String setLikesDislikesApi = '${databaseUrl}set_like_dislike';
  static String setFlagApi = '${databaseUrl}set_flag';
  static String getLiveStreamingApi = '${databaseUrl}get_live_streaming';
  static String getSubCategoryApi = '${databaseUrl}get_subcategory_by_category';
  static String setLikeDislikeComApi = '${databaseUrl}set_comment_like_dislike';
  static String getNewsByTagApi = '${databaseUrl}get_news_by_tag';
  static String getUserNotificationApi = '${databaseUrl}get_user_notification';
  static String updateFCMIdApi = '${databaseUrl}update_fcm_id';
  static String deleteUserNotiApi = '${databaseUrl}delete_user_notification';
  static String getQueApi = '${databaseUrl}get_question';
  static String getQueResultApi = '${databaseUrl}get_question_result';
  static String setQueResultApi = '${databaseUrl}set_question_result';
  static String userDeleteApi = '${databaseUrl}delete_user';
  static String getTagsApi = '${databaseUrl}get_tag';
  static String setNewsApi = '${databaseUrl}set_news';
  static String updateNewsApi = '${databaseUrl}update_news';
  static String setDeleteNewsApi = '${databaseUrl}delete_news';
  static String setDeleteImageApi = '${databaseUrl}delete_news_images';
  static String getVideosApi = '${databaseUrl}get_videos';
  static String getLanguagesApi = '${databaseUrl}get_languages_list';
  static String getLangJsonDataApi = '${databaseUrl}get_language_json_data';
  static String getPagesApi = '${databaseUrl}get_pages';
  static String getPolicyPagesApi = '${databaseUrl}get_policy_pages';
  static String getFeatureSectionApi = '${databaseUrl}get_featured_sections';
  static String getLikeNewsApi = '${databaseUrl}get_like';
  static String getFeatureSectionByIdApi = '${databaseUrl}get_featured_section_by_id';
  static String setNewsViewApi = '${databaseUrl}set_news_view';
  static String setBreakingNewsViewApi = '${databaseUrl}set_breaking_news_view';
  static String getAdsNewsDetailsApi = '${databaseUrl}get_ad_space_news_details';
  static String signInApi = '$authUrl/auth/login';
  static String registerApi = '$authUrl/customers';
  static String getCitiesApi = '$catalogUrl/v2/cities/available';
  static String getRouteApi = '$catalogUrl/v1/departures';
  static String getPassengerCategoryApi = '$catalogUrl/passengerCategories/company/';
  static String commandApi = '$catalogUrl/commands';
  static String passengerApi = '/passengers';
  static String placeInfoApi = '/placeInformations';
  static String placeRepresentation = '/representation';
  static String seatsApi = '/seats';

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
      debugPrint("response ======++> $response");

      if(response.data != ""){
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
      debugPrint("Response   ==============>  $response");
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

  static Future<void> registerPost({
    required Map<String, dynamic> body,
    required String url,
  }) async {
    try {
      if (await InternetConnectivity.isNetworkAvailable() == false) {
        throw const SocketException(ErrorMessageKeys.noInternet);
      }
      final Dio dio = Dio();
      debugPrint("Requested APi - $url & params are $body");

      final response = await dio.post(url, data: jsonEncode(body), options: Options(headers: _headers, validateStatus: (_) => true) );
      //debugPrint("Response status code  ==============>  ${response.statusCode}");
      if (response.statusCode == 500) {
        debugPrint("APi exception msg - ${response.data}");
        throw ApiException(response.data);
      }
      //debugPrint("response ======++> $response");
      //return response.data;
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

}
