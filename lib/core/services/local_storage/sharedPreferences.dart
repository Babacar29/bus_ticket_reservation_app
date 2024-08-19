import 'package:bus_ticket_reservation_app/utils/hiveBoxKeys.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';



class SharedPreferencesServices {
  final storage = const FlutterSecureStorage();
  static final SharedPreferencesServices _instance = SharedPreferencesServices._ctor();

  factory SharedPreferencesServices() {
    return _instance;
  }

  SharedPreferencesServices._ctor();

  static late SharedPreferences _prefs;

  static init() async {
    _prefs = await SharedPreferences.getInstance();
  }


  String getTokenKeyFromSharedPref()  {
    if (!_prefs.containsKey(tokenKey)) {
      return '';
    }
    return _prefs.get(tokenKey).toString();
  }

  setTokenKeyInSharedPref(String str) {
    //_prefs.remove("countryCode");
    _prefs.setString(tokenKey, str);
  }

  storeTokenInSecureStorage(String apiKey) async {
    await storage.write(
        key: tokenKey,
        value: apiKey
    );
  }

   getTokenKeyInSecureStorage() async {
    if (!await storage.containsKey(key: tokenKey)) {
      return "";
    }
    return await storage.read(key: tokenKey);
  }
  //////////////////////////////////////////////////////////////////
  String getApiKeyFromSharedPref()  {
    if (!_prefs.containsKey(apiKey)) {
      return '';
    }
    return _prefs.get(apiKey).toString();
  }

  setApiKeyInSharedPref(String str) {
    //_prefs.remove("countryCode");
    _prefs.setString(apiKey, str);
  }

  storeApiInSecureStorage(String apiKey) async {
    await storage.write(
        key: apiKey,
        value: apiKey
    );
  }

   getApiKeyInSecureStorage() async {
    if (!await storage.containsKey(key: apiKey)) {
      return "";
    }
    return await storage.read(key: apiKey);
  }
}
