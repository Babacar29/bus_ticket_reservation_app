// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:burkina_transport_app/ui/styles/colors.dart';
import 'package:burkina_transport_app/ui/widgets/customAppBar.dart';
import 'package:burkina_transport_app/ui/widgets/customTextLabel.dart';
import 'package:burkina_transport_app/ui/widgets/errorContainerWidget.dart';
import 'package:burkina_transport_app/ui/widgets/networkImage.dart';
import 'package:burkina_transport_app/utils/ErrorMessageKeys.dart';
import 'package:burkina_transport_app/utils/internetConnectivity.dart';
import 'package:burkina_transport_app/utils/uiUtils.dart';
import 'package:burkina_transport_app/cubits/Auth/authCubit.dart';
import 'package:burkina_transport_app/cubits/languageCubit.dart';
import 'package:burkina_transport_app/cubits/appLocalizationCubit.dart';
import 'package:burkina_transport_app/cubits/languageJsonCubit.dart';

class LanguageList extends StatefulWidget {
  const LanguageList({super.key});

  @override
  LanguageListState createState() => LanguageListState();

  static Route route(RouteSettings routeSettings) {
    return CupertinoPageRoute(builder: (_) => const LanguageList());
  }
}

class LanguageListState extends State<LanguageList> {
  String? selLanCode;
  String? selLanId;
  String? selLanRTL;
  bool isNetworkAvail = true;

  @override
  void initState() {
    isNetworkAvailable();
    getLanguageData();
    super.initState();
  }

  Future getLanguageData() async {
    Future.delayed(Duration.zero, () {
      context.read<LanguageCubit>().getLanguage(context: context);
    });
  }

  Widget setTitle() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 20.0, start: 20.0),
      child: CustomTextLabel(
        text: 'chooseLanLbl',
        textStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(color: UiUtils.getColorScheme(context).primaryContainer, fontWeight: FontWeight.w600, letterSpacing: 0.5),
      ),
    );
  }

  Widget getLangList() {
    return BlocBuilder<AppLocalizationCubit, AppLocalizationState>(builder: (context, stateLocale) {
      return BlocBuilder<LanguageCubit, LanguageState>(builder: (context, state) {
        if (state is LanguageFetchSuccess) {
          return ListView.separated(
              padding: const EdgeInsets.only(bottom: 20, top: 10),
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: ((context, index) {
                return Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                    child: Container(
                      height: MediaQuery.sizeOf(context).height * 0.08,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: (selLanCode ?? stateLocale.languageCode) == state.language[index].code! ? UiUtils.getColorScheme(context).primaryContainer : null),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            Intl.defaultLocale = state.language[index].code;
                            selLanCode = state.language[index].code!;
                            selLanId = state.language[index].id!;
                            selLanRTL = state.language[index].isRtl!;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 15, right: 15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CustomNetworkImage(
                                networkImageUrl: state.language[index].image!,
                                isVideo: false,
                                height: 40,
                                fit: BoxFit.fill,
                                width: 40,
                              ),
                              SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                              Text(state.language[index].languageDisplayName ?? state.language[index].language!,
                                  style: Theme.of(this.context).textTheme.titleLarge?.copyWith(
                                        color: ((selLanCode ?? (stateLocale).languageCode) == state.language[index].code!)
                                            ? UiUtils.getColorScheme(context).secondary
                                            : UiUtils.getColorScheme(context).primaryContainer,
                                      )),
                            ],
                          ),
                        ),
                      ),
                    ));
              }),
              separatorBuilder: (context, index) {
                return const SizedBox(height: 1.0);
              },
              itemCount: state.language.length);
        }
        if (state is LanguageFetchFailure) {
          return Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30.0),
            child: ErrorContainerWidget(
                errorMsg: (state.errorMessage.contains(ErrorMessageKeys.noInternet)) ? UiUtils.getTranslatedLabel(context, 'internetmsg') : state.errorMessage, onRetry: getLanguageData),
          );
        }
        return const Padding(padding: EdgeInsets.only(bottom: 10.0, left: 30.0, right: 30.0), child: SizedBox.shrink());
      });
    });
  }

  saveBtn() {
    return BlocConsumer<LanguageJsonCubit, LanguageJsonState>(
        bloc: context.read<LanguageJsonCubit>(),
        listener: (context, state) {
          if (state is LanguageJsonFetchSuccess) {
            //UiUtils.setDynamicStringValue(context.read<AppLocalizationCubit>().state.languageCode, jsonEncode(state.languageJson));

            //context.read<CategoryCubit>().getCategory(context: context, langId: context.read<AppLocalizationCubit>().state.id);
            if (context.read<AuthCubit>().getUserId() != "0") {
              //context.read<BookmarkCubit>().getBookmark(context: context, langId: context.read<AppLocalizationCubit>().state.id, userId: context.read<AuthCubit>().getUserId());
            }
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return InkWell(
              highlightColor: Colors.transparent,
              child: Container(
                height: 55.0,
                margin: const EdgeInsetsDirectional.all(20),
                width: MediaQuery.of(context).size.width * 0.9,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(15.0)),
                child: CustomTextLabel(
                  text: 'saveLbl',
                  textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(color: backgroundColor, fontWeight: FontWeight.bold),
                ),
              ),
              onTap: () {
                setState(() {
                  if (selLanCode != null && context.read<AppLocalizationCubit>().state.languageCode != selLanCode) {
                    context.read<AppLocalizationCubit>().changeLanguage(selLanCode!, selLanId!, selLanRTL!);
                    context.read<LanguageJsonCubit>().getLanguageJson(context: context, lanCode: selLanCode!);
                  } else {
                    Navigator.pop(context);
                  }
                });
              });
        });
  }

  isNetworkAvailable() async {
    if (await InternetConnectivity.isNetworkAvailable()) {
      setState(() {
        isNetworkAvail = true;
      });
    } else {
      setState(() {
        isNetworkAvail = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: setCustomAppBar(height: 45, isBackBtn: true, label: 'chooseLanLbl', horizontalPad: 15, context: context, isConvertText: true),
        bottomNavigationBar: (isNetworkAvail) ? saveBtn() : const SizedBox.shrink(),
        body: getLangList());
  }
}
