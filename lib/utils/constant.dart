//Please add your admin panel url here and make sure you do not add '/' at the end of the url

//const String authUrl = "https://gateway.recette.ankata.tech/authentication-api";//"https://gateway.rahimo.ankata.net/authentication-api";
//const String catalogUrl = "https://gateway.recette.ankata.tech/catalog-api";//"https://gateway.rahimo.ankata.net/catalog-api";
//const String paymentUrl = "https://gateway.recette.ankata.tech/payment-api";//"https://gateway.rahimo.ankata.net/catalog-api";
const String base_url = "https://business.ankata.tech";
const String baseUrl = "https://admin.reewmi.fr/";
const String databaseUrl = "${baseUrl}api/";

//Please add your jwt key here that you have added in admin panel system configuration setting
const String jwtKey = "replace_your_jwt_secret_key";

//Please add here your default country code
const String yourCountryCode = 'BF';

//access key for access api
const String accessKey = "5670";

const int limitOfAPIData = 10;

//weather data enable
const bool isWeatherDataShow = true;

//Facebook Login enable/disable
const bool fblogInEnabled = true;

//set value for survey show after news data
const int surveyShow = 4;

//set value for native ads show after news data
const int nativeAdsIndex = 3;

//set value for interstitial ads show after news data
const int interstitialAdsIndex = 3;

//set value for reward ads show after news data
const int rewardAdsIndex = 4;

const String appName = 'burkina_transport_app';
const String packageName = 'com.example.burkina_transport_app'; //Your Package name
const String androidLink = 'https://play.google.com/store/apps/details?id=';

const String iosPackage = 'com.example.burkina_transport_app'; //Your Package name
const String iosLink = 'your ios link here'; //Your Appstore App link
const String androidLbl = 'Android:';
const String iosLbl = 'iOS:';
const String appStoreId = '9876543120'; //Your Appstore app Id //used for Rating & sharing

const String deepLinkUrlPrefix = 'your_link'; //example - https://xxx.page.link - Your dynamic link from Firebase
const String deepLinkName = 'your_deeplink_name';//example - xxx.com - Your domain name
