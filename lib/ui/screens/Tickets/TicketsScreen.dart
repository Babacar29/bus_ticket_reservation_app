// ignore_for_file: file_names

import 'package:burkina_transport_app/ui/screens/HomePage/HomePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app/routes.dart';
import '../../../cubits/Auth/authCubit.dart';
import '../../../utils/uiUtils.dart';
import '../../styles/colors.dart';
import '../../widgets/customTextBtn.dart';
import '../../widgets/myAppBar.dart';
import '../Profile/ProfileScreen.dart';

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({super.key});

  @override
  TicketsScreenState createState() => TicketsScreenState();

  static Route route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
      builder: (_) => const TicketsScreen(),
    );
  }
}

class TicketsScreenState extends State<TicketsScreen> with TickerProviderStateMixin {
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
  
  Widget showTickets(BuildContext context){
    return ListView.builder(
        itemCount: 3,
        itemBuilder: (context, int i){
          return GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(Routes.ticketDetails);
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
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
                            padding: EdgeInsets.all(5.0),
                            child: Text(
                              "Ouagadougou > Bobo Dioulasso",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    paddingText(title: "Date: ", subtitle: "26/01/2024"),
                    paddingText(title: "Heure: ", subtitle: "07:30"),
                    paddingText(title: "Statut: ", subtitle: "Validé"),
                    paddingText(title: "Numéro de place: ", subtitle: "23"),
                    const SizedBox(height: 5,),
                  ],
                ),
              ),
            ),
          );
        }
    );
  }

  Padding paddingText({required String title, required String subtitle}) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
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

  Widget content() {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return  Container(
      color: darkBackgroundColor.withOpacity(0.1),
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 9,
            child: SizedBox(
              height: height - 30,
              width: width/1.1,
              child: showTickets(context)
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: width/2 - 1,
                    child: CustomTextButton(
                      onTap: (){
                      },
                      color: darkBackgroundColor,
                      text: "A VENIR",
                    ),
                  ),
                  const VerticalDivider(
                    width: 2,
                  ),
                  SizedBox(
                    width: width/2 - 1,
                    child: CustomTextButton(
                      onTap: (){
                      },
                      color: darkBackgroundColor,
                      text: "PASSÉS",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget showContent(){
    return Scaffold(
      appBar: const CustomAppBar(title: "Mes billets",),
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
          //bottomNavigationBar: bottomBar()
        );
      },
    );
  }
}
