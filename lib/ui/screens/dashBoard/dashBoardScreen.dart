// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:burkina_transport_app/cubits/Auth/authCubit.dart';
import 'package:burkina_transport_app/cubits/themeCubit.dart';
import 'package:burkina_transport_app/ui/screens/HomePage/HomePage.dart';
import 'package:burkina_transport_app/ui/screens/Profile/ProfileScreen.dart';
import 'package:burkina_transport_app/ui/widgets/SnackBarWidget.dart';
import 'package:burkina_transport_app/utils/uiUtils.dart';

import '../../styles/colors.dart';
import '../Tickets/TicketsScreen.dart';

GlobalKey<HomeScreenState>? homeScreenKey;
bool? isNotificationReceivedInbg;
String? notificationNewsId;

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  DashBoardState createState() => DashBoardState();

  static Route route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
      builder: (_) => const DashBoard(),
    );
  }
}

class DashBoardState extends State<DashBoard> {
  List<Widget> fragments = [];
  DateTime? currentBackPressTime;
  int _selectedIndex = 0;
  List<IconData> iconList = [];

  @override
  void initState() {
    homeScreenKey = GlobalKey<HomeScreenState>();
    iconList = [
      Icons.bookmark,
      Icons.bookmark,
      Icons.account_circle,
    ];
    fragments = [
      HomeScreen(key: homeScreenKey),
      //Add only if Category Mode is enabled From Admin panel.
      const TicketsScreen(),
      const ProfileScreen(),
    ];
    super.initState();
  }


  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (_selectedIndex != 0) {
      setState(() {
        _selectedIndex = 0;
      });

      return Future.value(false);
    } else if (currentBackPressTime == null || now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      showSnackBar(UiUtils.getTranslatedLabel(context, 'exitWR'), context);
      return Future.value(false);
    }
    return Future.value(true);
  }

  Widget buildNavBarItem(IconData icon, int index) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width / iconList.length,
        decoration: index == _selectedIndex
            ? const BoxDecoration(
                border: Border(
                  top: BorderSide(width: 3, color: darkBackgroundColor),
                ),
              )
            : null,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
            children: [
              Icon(
                icon,
                color: index == _selectedIndex ? darkBackgroundColor : UiUtils.getColorScheme(context).outline,
              ),
              index == 0 ? Text(
                "Réservations",
                style: TextStyle(
                  color: index == _selectedIndex ? darkBackgroundColor : null
                ),
              ) : const SizedBox(),
              index == 1 ? Text(
                "Mes billets",
                style: TextStyle(
                    color: index == _selectedIndex ? darkBackgroundColor : null
                ),
              ) : const SizedBox(),
              index == 2 ? Text(
                "Mon Compte",
                style: TextStyle(
                    color: index == _selectedIndex ? darkBackgroundColor : null
                ),
              ) : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  bottomBar() {
    List<Widget> navBarItemList = [];
    for (var i = 0; i < iconList.length; i++) {
      navBarItemList.add(buildNavBarItem(iconList[i], i));
    }

    return Container(
        decoration: BoxDecoration(
          color: UiUtils.getColorScheme(context).secondary,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
          boxShadow: [
            BoxShadow(blurRadius: 6, offset: const Offset(5.0, 5.0), color: darkBackgroundColor.withOpacity(0.4), spreadRadius: 0),
          ],
        ),
        child: ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
            child: Row(
              children: navBarItemList,
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    UiUtils.setUIOverlayStyle(appTheme: context.read<ThemeCubit>().state.appTheme); //set UiOverlayStyle according to selected theme
    return WillPopScope(
      onWillPop: onWillPop,
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Future.delayed(Duration.zero, () {
              //context.read<BookmarkCubit>().getBookmark(context: context, langId: context.read<AppLocalizationCubit>().state.id, userId: context.read<AuthCubit>().getUserId());
            });
          }
        },
        builder: (context, state) {
          return Scaffold(
            bottomNavigationBar: bottomBar(),
            body: IndexedStack(
              index: _selectedIndex,
              children: fragments,
            ),
          );
        },
      ),
    );
  }
}

