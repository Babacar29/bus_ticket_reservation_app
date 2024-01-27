// ignore_for_file: file_names

import 'package:burkina_transport_app/ui/screens/HomePage/HomePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cubits/Auth/authCubit.dart';
import '../../../utils/uiUtils.dart';
import '../../styles/colors.dart';
import '../../widgets/customTextBtn.dart';
import '../../widgets/myAppBar.dart';
import '../Profile/ProfileScreen.dart';

class TicketDetailsScreen extends StatefulWidget {
  const TicketDetailsScreen({super.key});

  @override
  TicketDetailsScreenState createState() => TicketDetailsScreenState();

  static Route route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
      builder: (_) => const TicketDetailsScreen(),
    );
  }
}

class TicketDetailsScreenState extends State<TicketDetailsScreen> with TickerProviderStateMixin {
  int _selectedIndex = 1;
  List<IconData> iconList = [
    Icons.bookmark,
    Icons.bookmark,
    Icons.account_circle,
  ];

  @override
  void initState() {
    super.initState();
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

  Widget content() {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return  Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Container(
                width: width/1.1,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10)
                    )
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          color: darkBackgroundColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)
                          )
                      ),
                      child: const Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              "Ouagadougou > Bobo Dioulasso\nKalgonde          Cikasso-cira",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            paddingText(title: "Date: ", subtitle: "26/01/2024"),
                            paddingText(title: "Heure: ", subtitle: "07:30"),
                            paddingText(title: "Numéro de place: ", subtitle: "23"),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            paddingText(title: "Statut: ", subtitle: "Validé"),
                            paddingText(title: "Prénom: ", subtitle: "Babacar"),
                            paddingText(title: "Nom: ", subtitle: "Diouf"),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: height/10,),
                    Image.asset("assets/code_qr.png")
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Padding paddingText({required String title, required String subtitle}) {
    return Padding(
        padding: const EdgeInsets.only(top: 5.0, bottom: 5, left: 10, right: 10),
        child: RichText(
            text:  TextSpan(
                text: title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: darkBackgroundColor
                ),
                children: [
                  TextSpan(
                      text: subtitle,
                      style: const TextStyle(
                          color: darkBackgroundColor,
                          fontWeight: FontWeight.normal
                      )
                  )
                ]
            )
        )
    );
  }

  Widget showContent(){
    return Scaffold(
      backgroundColor: darkBackgroundColor.withOpacity(0.1),
      appBar: const CustomAppBar(title: "Mon billet",),
      body: content(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Scaffold(
          body: IndexedStack(
            index: _selectedIndex,
            children: [
              const HomeScreen(),
              showContent(),
              //Add only if Category Mode is enabled From Admin panel.
              const ProfileScreen(),
            ],
          ),
          bottomNavigationBar: bottomBar()
        );
      },
    );
  }
}
