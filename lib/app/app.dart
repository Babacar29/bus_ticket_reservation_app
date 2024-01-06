import 'dart:io';
import 'dart:ui';

import 'package:burkina_transport_app/app/routes.dart';
import 'package:burkina_transport_app/ui/screens/PushNotificationService.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart' as intl;
import 'package:burkina_transport_app/cubits/AddNewsCubit.dart';
import 'package:burkina_transport_app/cubits/Auth/deleteUserCubit.dart';
import 'package:burkina_transport_app/cubits/Auth/registerTokenCubit.dart';
import 'package:burkina_transport_app/cubits/Auth/updateFCMCubit.dart';
import 'package:burkina_transport_app/cubits/Auth/updateUserCubit.dart';
import 'package:burkina_transport_app/cubits/Bookmark/UpdateBookmarkCubit.dart';
import 'package:burkina_transport_app/cubits/Bookmark/bookmarkCubit.dart';
import 'package:burkina_transport_app/cubits/LikeAndDislikeNews/LikeAndDislikeCubit.dart';
import 'package:burkina_transport_app/cubits/LikeAndDislikeNews/updateLikeAndDislikeCubit.dart';
import 'package:burkina_transport_app/cubits/NewsComment/deleteCommentCubit.dart';
import 'package:burkina_transport_app/cubits/NewsComment/flagCommentCubit.dart';
import 'package:burkina_transport_app/cubits/NewsComment/likeAndDislikeCommCubit.dart';
import 'package:burkina_transport_app/cubits/NewsComment/setCommentCubit.dart';
import 'package:burkina_transport_app/cubits/UserNotification/deleteUserNotification.dart';
import 'package:burkina_transport_app/cubits/UserPreferences/setUserPreferenceCatCubit.dart';
import 'package:burkina_transport_app/cubits/adSpacesNewsDetailsCubit.dart';
import 'package:burkina_transport_app/cubits/appLocalizationCubit.dart';
import 'package:burkina_transport_app/cubits/Auth/authCubit.dart';
import 'package:burkina_transport_app/cubits/breakingNewsCubit.dart';
import 'package:burkina_transport_app/cubits/commentNewsCubit.dart';
import 'package:burkina_transport_app/cubits/deleteImageId.dart';
import 'package:burkina_transport_app/cubits/deleteUserNewsCubit.dart';
import 'package:burkina_transport_app/cubits/getSurveyAnswerCubit.dart';
import 'package:burkina_transport_app/cubits/getUserDataByIdCubit.dart';
import 'package:burkina_transport_app/cubits/getUserNewsCubit.dart';
import 'package:burkina_transport_app/cubits/languageCubit.dart';
import 'package:burkina_transport_app/cubits/privacyTermsCubit.dart';
import 'package:burkina_transport_app/cubits/relatedNewsCubit.dart';
import 'package:burkina_transport_app/cubits/sectionByIdCubit.dart';
import 'package:burkina_transport_app/cubits/setNewsViewsCubit.dart';
import 'package:burkina_transport_app/cubits/setSurveyAnswerCubit.dart';
import 'package:burkina_transport_app/cubits/settingCubit.dart';
import 'package:burkina_transport_app/cubits/Auth/socialSignUpCubit.dart';
import 'package:burkina_transport_app/cubits/UserPreferences/userByCategoryCubit.dart';
import 'package:burkina_transport_app/cubits/tagCubit.dart';
import 'package:burkina_transport_app/cubits/tagNewsCubit.dart';
import 'package:burkina_transport_app/cubits/NewsByIdCubit.dart';
import 'package:burkina_transport_app/cubits/notificationCubit.dart';
import 'package:burkina_transport_app/cubits/appSystemSettingCubit.dart';
import 'package:burkina_transport_app/cubits/categoryCubit.dart';
import 'package:burkina_transport_app/cubits/featureSectionCubit.dart';
import 'package:burkina_transport_app/cubits/languageJsonCubit.dart';
import 'package:burkina_transport_app/cubits/liveStreamCubit.dart';
import 'package:burkina_transport_app/cubits/otherPagesCubit.dart';
import 'package:burkina_transport_app/cubits/subCategoryCubit.dart';
import 'package:burkina_transport_app/cubits/surveyQuestionCubit.dart';
import 'package:burkina_transport_app/cubits/themeCubit.dart';
import 'package:burkina_transport_app/cubits/UserNotification/userNotificationCubit.dart';
import 'package:burkina_transport_app/cubits/videosCubit.dart';
import 'package:burkina_transport_app/data/repositories/AddNews/addNewsRepository.dart';
import 'package:burkina_transport_app/data/repositories/Auth/authRepository.dart';
import 'package:burkina_transport_app/data/repositories/Bookmark/bookmarkRepository.dart';
import 'package:burkina_transport_app/data/repositories/BreakingNews/breakNewsRepository.dart';
import 'package:burkina_transport_app/data/repositories/CommentNews/commNewsRepository.dart';
import 'package:burkina_transport_app/data/repositories/DeleteImageId/deleteImageRepository.dart';
import 'package:burkina_transport_app/data/repositories/DeleteUserNews/deleteUserNewsRepository.dart';
import 'package:burkina_transport_app/data/repositories/DeleteUserNotification/deleteUserNotiRepository.dart';
import 'package:burkina_transport_app/data/repositories/GetSurveyAnswer/getSurveyAnsRepository.dart';
import 'package:burkina_transport_app/data/repositories/GetUserById/getUserByIdRepository.dart';
import 'package:burkina_transport_app/data/repositories/GetUserNews/getUserNewsRepository.dart';
import 'package:burkina_transport_app/data/repositories/LikeAndDisLikeNews/LikeAndDisLikeNewsRepository.dart';
import 'package:burkina_transport_app/data/repositories/NewsComment/DeleteComment/deleteCommRepository.dart';
import 'package:burkina_transport_app/data/repositories/NewsComment/FlagComment/flagCommRepository.dart';
import 'package:burkina_transport_app/data/repositories/NewsComment/LikeAndDislikeComment/likeAndDislikeCommRepository.dart';
import 'package:burkina_transport_app/data/repositories/NewsComment/SetComment/setComRepository.dart';
import 'package:burkina_transport_app/data/repositories/RelatedNews/relatedNewsRepository.dart';
import 'package:burkina_transport_app/data/repositories/SectionById/sectionByIdRepository.dart';
import 'package:burkina_transport_app/data/repositories/SetNewsViews/setNewsViewsRepository.dart';
import 'package:burkina_transport_app/data/repositories/SetSurveyAnswer/setSurveyAnsRepository.dart';
import 'package:burkina_transport_app/data/repositories/SetUserPreferenceCat/setUserPrefCatRepository.dart';
import 'package:burkina_transport_app/data/repositories/SurveyQuestion/surveyQueRepository.dart';
import 'package:burkina_transport_app/data/repositories/Tag/tagRepository.dart';
import 'package:burkina_transport_app/data/repositories/TagNews/tagNewsRepository.dart';
import 'package:burkina_transport_app/data/repositories/UserByCategory/userByCatRepository.dart';
import 'package:burkina_transport_app/data/repositories/language/languageRepository.dart';
import 'package:burkina_transport_app/data/repositories/Settings/settingRepository.dart';
import 'package:burkina_transport_app/data/repositories/Settings/settingsLocalDataRepository.dart';
import 'package:burkina_transport_app/data/repositories/AppSystemSetting/systemRepository.dart';
import 'package:burkina_transport_app/data/repositories/Category/categoryRepository.dart';
import 'package:burkina_transport_app/data/repositories/FeatureSection/sectionRepository.dart';
import 'package:burkina_transport_app/data/repositories/LanguageJson/languageJsonRepository.dart';
import 'package:burkina_transport_app/data/repositories/LiveStream/liveStreamRepository.dart';
import 'package:burkina_transport_app/data/repositories/NewsById/NewsByIdRepository.dart';
import 'package:burkina_transport_app/data/repositories/Notification/notificationRepository.dart';
import 'package:burkina_transport_app/data/repositories/OtherPages/otherPagesRepository.dart';
import 'package:burkina_transport_app/data/repositories/SubCategory/subCatRepository.dart';
import 'package:burkina_transport_app/data/repositories/UserNotification/userNotiRepository.dart';
import 'package:burkina_transport_app/data/repositories/Videos/videosRepository.dart';
import 'package:burkina_transport_app/ui/styles/appTheme.dart';
import 'package:burkina_transport_app/utils/hiveBoxKeys.dart';
import 'package:burkina_transport_app/utils/uiUtils.dart';

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  MobileAds.instance.initialize();

  await Firebase.initializeApp();

  //await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);

  await Hive.initFlutter();

  await Hive.openBox(authBoxKey);

  await Hive.openBox(settingsBoxKey);

  runApp(MultiBlocProvider(providers: [
    BlocProvider<AppConfigurationCubit>(create: (context) => AppConfigurationCubit(SystemRepository())),
    BlocProvider<SettingsCubit>(create: (_) => SettingsCubit(SettingsRepository())),
    BlocProvider<AppLocalizationCubit>(create: (_) => AppLocalizationCubit(SettingsLocalDataRepository())),
    BlocProvider<ThemeCubit>(create: (_) => ThemeCubit(SettingsLocalDataRepository())),
    BlocProvider<LanguageJsonCubit>(create: (_) => LanguageJsonCubit(LanguageJsonRepository())),
    BlocProvider<LanguageCubit>(create: (context) => LanguageCubit(LanguageRepository())),
    BlocProvider<SectionCubit>(create: (_) => SectionCubit(SectionRepository())),
    BlocProvider<PrivacyTermsCubit>(create: (_) => PrivacyTermsCubit(OtherPageRepository())),
    BlocProvider<VideoCubit>(create: (_) => VideoCubit(VideoRepository())),
    BlocProvider<NotificationCubit>(create: (_) => NotificationCubit(NotificationRepository())),
    BlocProvider<UserNotificationCubit>(create: (_) => UserNotificationCubit(UserNotificationRepository())),
    BlocProvider<NewsByIdCubit>(create: (_) => NewsByIdCubit(NewsByIdRepository())),
    BlocProvider<OtherPageCubit>(create: (_) => OtherPageCubit(OtherPageRepository())),
    BlocProvider<LiveStreamCubit>(create: (_) => LiveStreamCubit(LiveStreamRepository())),
    BlocProvider<CategoryCubit>(create: (_) => CategoryCubit(CategoryRepository())),
    BlocProvider<SubCategoryCubit>(create: (_) => SubCategoryCubit(SubCategoryRepository())),
    BlocProvider<SurveyQuestionCubit>(create: (_) => SurveyQuestionCubit(SurveyQuestionRepository())),
    BlocProvider<SetSurveyAnsCubit>(create: (_) => SetSurveyAnsCubit(SetSurveyAnsRepository())),
    BlocProvider<GetSurveyAnsCubit>(create: (_) => GetSurveyAnsCubit(GetSurveyAnsRepository())),
    BlocProvider<CommentNewsCubit>(create: (_) => CommentNewsCubit(CommentNewsRepository())),
    BlocProvider<RelatedNewsCubit>(create: (_) => RelatedNewsCubit(RelatedNewsRepository())),
    BlocProvider<SocialSignUpCubit>(create: (_) => SocialSignUpCubit(AuthRepository())),
    BlocProvider<AuthCubit>(create: (_) => AuthCubit(AuthRepository())),
    BlocProvider<RegisterTokenCubit>(create: (_) => RegisterTokenCubit(AuthRepository())),
    BlocProvider<UpdateFcmIdCubit>(create: (_) => UpdateFcmIdCubit(AuthRepository())),
    BlocProvider<UserByCatCubit>(create: (_) => UserByCatCubit(UserByCatRepository())),
    BlocProvider<SetUserPrefCatCubit>(create: (_) => SetUserPrefCatCubit(SetUserPrefCatRepository())),
    BlocProvider<UpdateUserCubit>(create: (_) => UpdateUserCubit(AuthRepository())),
    BlocProvider<DeleteUserCubit>(create: (_) => DeleteUserCubit(AuthRepository())),
    BlocProvider<BookmarkCubit>(create: (_) => BookmarkCubit(BookmarkRepository())),
    BlocProvider<UpdateBookmarkStatusCubit>(create: (_) => UpdateBookmarkStatusCubit(BookmarkRepository())),
    BlocProvider<LikeAndDisLikeCubit>(create: (_) => LikeAndDisLikeCubit(LikeAndDisLikeRepository())),
    BlocProvider<UpdateLikeAndDisLikeStatusCubit>(create: (_) => UpdateLikeAndDisLikeStatusCubit(LikeAndDisLikeRepository())),
    BlocProvider<BreakingNewsCubit>(create: (_) => BreakingNewsCubit(BreakingNewsRepository())),
    BlocProvider<TagNewsCubit>(create: (_) => TagNewsCubit(TagNewsRepository())),
    BlocProvider<SetCommentCubit>(create: (_) => SetCommentCubit(SetCommentRepository())),
    BlocProvider<LikeAndDislikeCommCubit>(create: (_) => LikeAndDislikeCommCubit(LikeAndDislikeCommRepository())),
    BlocProvider<DeleteCommCubit>(create: (_) => DeleteCommCubit(DeleteCommRepository())),
    BlocProvider<SetFlagCubit>(create: (_) => SetFlagCubit(SetFlagRepository())),
    BlocProvider<AddNewsCubit>(create: (_) => AddNewsCubit(AddNewsRepository())),
    BlocProvider<TagCubit>(create: (_) => TagCubit(TagRepository())),
    BlocProvider<GetUserNewsCubit>(create: (_) => GetUserNewsCubit(GetUserNewsRepository())),
    BlocProvider<DeleteUserNewsCubit>(create: (_) => DeleteUserNewsCubit(DeleteUserNewsRepository())),
    BlocProvider<DeleteImageCubit>(create: (_) => DeleteImageCubit(DeleteImageRepository())),
    BlocProvider<DeleteUserNotiCubit>(create: (_) => DeleteUserNotiCubit(DeleteUserNotiRepository())),
    BlocProvider<GetUserByIdCubit>(create: (_) => GetUserByIdCubit(GetUserByIdRepository())),
    BlocProvider<SectionByIdCubit>(create: (_) => SectionByIdCubit(SectionByIdRepository())),
    BlocProvider<SetNewsViewsCubit>(create: (_) => SetNewsViewsCubit(SetNewsViewsRepository())),
    BlocProvider<AdSpacesNewsDetailsCubit>(create: (_) => AdSpacesNewsDetailsCubit())
  ], child: const MyApp()));
}

class GlobalScrollBehavior extends ScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    final pushNotificationService = PushNotificationService(context: context);
    pushNotificationService.initialise();
    var brightness = PlatformDispatcher.instance.platformBrightness;
    if (SettingsLocalDataRepository().getCurrentTheme().isEmpty) {
      (brightness == Brightness.dark) ? context.read<ThemeCubit>().changeTheme(AppTheme.Dark) : context.read<ThemeCubit>().changeTheme(AppTheme.Light);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (Hive.box(settingsBoxKey).get(currentLanguageCodeKey) != null || Hive.box(settingsBoxKey).get(currentLanguageCodeKey) != "") {
        initializeDateFormatting();
        intl.Intl.defaultLocale = Hive.box(settingsBoxKey).get(currentLanguageCodeKey); //set default Locale @Start
      }
      final currentTheme = context.watch<ThemeCubit>().state.appTheme;
      return BlocBuilder<AppLocalizationCubit, AppLocalizationState>(
        builder: (context, state) {
          return MaterialApp(
              navigatorKey: UiUtils.rootNavigatorKey,
              theme: appThemeData[currentTheme],
              debugShowCheckedModeBanner: false,
              initialRoute: Routes.splash,
              onGenerateRoute: Routes.onGenerateRouted,
              builder: (context, widget) {
                return ScrollConfiguration(
                    behavior: GlobalScrollBehavior(), child: Directionality(textDirection: state.isRTL == '' || state.isRTL == "0" ? TextDirection.ltr : TextDirection.rtl, child: widget!));
              });
        },
      );
    });
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
