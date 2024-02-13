// ignore_for_file: file_names

import 'dart:convert';


import 'package:burkina_transport_app/ui/screens/HomePage/HomePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../cubits/Auth/authCubit.dart';
import '../../../data/models/Ticket.dart';
import '../../../utils/uiUtils.dart';
import '../../styles/colors.dart';
import '../../widgets/myAppBar.dart';
import '../Profile/ProfileScreen.dart';

class TicketDetailsScreen extends StatefulWidget {
  const TicketDetailsScreen({super.key, required this.ticket});
  final Ticket ticket;

  @override
  TicketDetailsScreenState createState() => TicketDetailsScreenState();

  static Route route(RouteSettings routeSettings) {
    final arguments = routeSettings.arguments as Map<String, dynamic>;
    return CupertinoPageRoute(
      builder: (_) => TicketDetailsScreen(
        ticket: arguments["ticket"],
      ),
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
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              "${widget.ticket.departureCity} > ${widget.ticket.arrivalCity}\n${widget.ticket.departureBusStation}          ${widget.ticket.arrivalBusStation}",
                              style: const TextStyle(
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
                            paddingText(title: "Date: ", subtitle: DateFormat("d MMMM yyyy").format(DateTime.parse("${widget.ticket.departureDate}"))),
                            paddingText(title: "Heure: ", subtitle: widget.ticket.departureTime),
                            paddingText(title: "Numéro de place: ", subtitle: widget.ticket.departureTime),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            paddingText(title: "Statut: ", subtitle: widget.ticket.paymentStatus),
                            paddingText(title: "Prénom: ", subtitle: widget.ticket.passenger.firstName),
                            paddingText(title: "Nom: ", subtitle: widget.ticket.passenger.lastName),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: height/10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: QrImageView(
                            data: widget.ticket.hash,
                            version: QrVersions.auto,
                            size: height/3,
                          ),
                        ),
                      ],
                    ),
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
