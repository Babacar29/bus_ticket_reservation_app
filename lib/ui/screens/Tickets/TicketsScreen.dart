// ignore_for_file: file_names

import 'package:bus_ticket_reservation_app/cubits/ticketsCubit.dart';
import 'package:bus_ticket_reservation_app/ui/screens/HomePage/HomePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../app/routes.dart';
import '../../../cubits/Auth/authCubit.dart';
import '../../../data/models/Ticket.dart';
import '../../../utils/uiUtils.dart';
import '../../styles/colors.dart';
import '../../widgets/customTextBtn.dart';
import '../../widgets/myAppBar.dart';
import '../Profile/ProfileScreen.dart';

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({super.key, this.from});
  final int? from;

  @override
  TicketsScreenState createState() => TicketsScreenState();

  static Route route(RouteSettings routeSettings) {
    final arguments = routeSettings.arguments as Map<String, dynamic>;
    return CupertinoPageRoute(
      builder: (_) => TicketsScreen(
        from: arguments["from"]
      ),
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
  List<Ticket> myTicketList = [];
  late TabController controller;
  int _currentIndex = 0;
  late final Future getPassedTicketsData;
  late final Future getUpcomingTicketsData;

  void _handleTabSelection() {
    setState(() {
      _currentIndex = controller.index;
    });
  }

  getPassedTickets() async{
    List<Ticket> tickets = [];
    var result = await context.read<TicketsCubit>().getTickets(context: context);
    //
    if(result["passedTicketList"] != null){
      for(var ticket in result["passedTicketList"].toList()){
        //widget.tickets?.add(Ticket.fromMap(ticket));
        tickets.add(Ticket.fromMap(ticket));
      }
    }
    return tickets;
  }

  getUpComingTickets() async{
    List<Ticket> tickets = [];
    var result = await context.read<TicketsCubit>().getTickets(context: context);
    //
    debugPrint("get tickets result ==========>$result");
    if(result["upcomingTicketList"] != null){
      for(var ticket in result["upcomingTicketList"].toList()){
        //widget.tickets?.add(Ticket.fromMap(ticket));
        tickets.add(Ticket.fromMap(ticket));
      }
    }
    return tickets;
  }

  @override
  void initState() {
    controller = TabController(vsync: this, length: 2);
    getPassedTicketsData = getPassedTickets();
    getUpcomingTicketsData = getUpComingTickets();
    super.initState();
  }

   Widget buildNavBarItem(IconData icon, int index) {
    return Material(
      color: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        child: SizedBox(
          height: MediaQuery.of(context).size.height/12,
          width: MediaQuery.of(context).size.width / iconList.length,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: index == _selectedIndex ? darkBackgroundColor : darkBackgroundColor.withOpacity(0.5),
                ),
                index == 0 ? Text(
                  "Réservations",
                  style: TextStyle(
                      color: index == _selectedIndex ? darkBackgroundColor : darkBackgroundColor.withOpacity(0.5),
                      fontWeight: FontWeight.w700
                  ),
                ) : const SizedBox(),
                index == 1 ? Text(
                  "Mes billets",
                  style: TextStyle(
                      color: index == _selectedIndex ? darkBackgroundColor : darkBackgroundColor.withOpacity(0.5),
                      fontWeight: FontWeight.w700
                  ),
                ) : const SizedBox(),
                index == 2 ? Text(
                  "Mon Compte",
                  style: TextStyle(
                      color: index == _selectedIndex ? darkBackgroundColor : darkBackgroundColor.withOpacity(0.5),
                      fontWeight: FontWeight.w700
                  ),
                ) : const SizedBox(),
              ],
            ),
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
  
  Widget showPassedTickets(BuildContext context){
    return FutureBuilder(
      future: getPassedTicketsData,
      builder: (context, AsyncSnapshot snap){
        List<Widget> children;
        if(snap.hasData){
          children = <Widget>[
            snap.data.toList() == [] ? const SizedBox() : ListView.builder(
              //itemCount: widget.tickets?.length,
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: snap.data.length,
                itemBuilder: (context, int i){
                  Ticket ticket = snap.data[i];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(Routes.ticketDetails, arguments: {"ticket": ticket});
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
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      "${ticket.departureCity} > ${ticket.arrivalCity}",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            paddingText(title: "Date: ", subtitle: DateFormat("d MMMM yyyy").format(DateTime.parse("${ticket.departureDate}"))),
                            paddingText(title: "Heure: ", subtitle: ticket.departureTime),
                            ticket.paymentStatus == "CREATED" ? paddingText(title: "Statut: ", subtitle: "Créée") : const SizedBox(),
                            ticket.paymentStatus == "PAYMENT_STARTED" ? paddingText(title: "Statut: ", subtitle: "Paiement en cours") : const SizedBox(),
                            ticket.paymentStatus == "PAYED" ? paddingText(title: "Statut: ", subtitle: "Payée") : const SizedBox(),
                            ticket.paymentStatus == "CANCELLED" ? paddingText(title: "Statut: ", subtitle: "Annulée") : const SizedBox(),
                            ticket.paymentStatus == "SCANNED" ? paddingText(title: "Statut: ", subtitle: "Scannée") : const SizedBox(),
                            paddingText(title: "Numéro de place: ", subtitle: "${ticket.seatNumber}"),
                            const SizedBox(height: 5,),
                          ],
                        ),
                      ),
                    ),
                  );
                }
            )
          ];
        }
        else if (snap.hasError) {
          children = <Widget>[
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text('Erreur: ${snap.error}'),
            ),
          ];
        } else {
          children = <Widget>[
            SizedBox(
              height: 300,
            ),
            Center(
              child: CircularProgressIndicator( color: darkBackgroundColor,),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Chargement...'),
              ),
            ),
          ];
        }
        return ListView(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          children: children,
        );

      }
    );
  }

  Widget showUpComingTickets(BuildContext context){
    return FutureBuilder(
      future: getUpcomingTicketsData,
      builder: (context, AsyncSnapshot snap){
        List<Widget> children;
        if(snap.hasData){
          children = <Widget>[
            snap.data.toList() == [] ? const SizedBox() : ListView.builder(
              //itemCount: widget.tickets?.length,
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: snap.data.length,
                itemBuilder: (context, int i){
                  Ticket ticket = snap.data[i];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(Routes.ticketDetails, arguments: {"ticket": ticket});
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
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      "${ticket.departureCity} > ${ticket.arrivalCity}",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            paddingText(title: "Date: ", subtitle: DateFormat("d MMMM yyyy").format(DateTime.parse("${ticket.departureDate}"))),
                            paddingText(title: "Heure: ", subtitle: ticket.departureTime),
                            ticket.paymentStatus == "CREATED" ? paddingText(title: "Statut: ", subtitle: "Créée") : const SizedBox(),
                            ticket.paymentStatus == "PAYMENT_STARTED" ? paddingText(title: "Statut: ", subtitle: "Paiement en cours") : const SizedBox(),
                            ticket.paymentStatus == "PAYED" ? paddingText(title: "Statut: ", subtitle: "Payée") : const SizedBox(),
                            ticket.paymentStatus == "CANCELLED" ? paddingText(title: "Statut: ", subtitle: "Annulée") : const SizedBox(),
                            ticket.paymentStatus == "SCANNED" ? paddingText(title: "Statut: ", subtitle: "Scannée") : const SizedBox(),
                            paddingText(title: "Numéro de place: ", subtitle: "${ticket.seatNumber}"),
                            const SizedBox(height: 5,),
                          ],
                        ),
                      ),
                    ),
                  );
                }
            )
          ];
        }
        else if (snap.hasError) {
          children = <Widget>[
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text('Erreur: ${snap.error}'),
            ),
          ];
        } else {
          children = <Widget>[
            SizedBox(
              height: 300,
            ),
            Center(
              child: CircularProgressIndicator( color: darkBackgroundColor,),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Chargement...'),
              ),
            ),
          ];
        }
        return ListView(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          children: children,
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
      color: backgroundColor,
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 9,
            child: SizedBox(
              height: height - 30,
              width: width/1.1,
              //child: (widget.tickets != null && widget.tickets != []) ? showTickets(context) : const SizedBox(),
              //child: myTicketList.isEmpty ? showTickets(context) : const SizedBox(),
              child: TabBarView(
                controller: controller,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    showUpComingTickets(context),
                    showPassedTickets(context),
                  ]
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: SizedBox(
              width: width,
              child: DefaultTabController(
                initialIndex: 0,
                length: 2,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: TabBar(
                    unselectedLabelColor: darkBackgroundColor,
                    controller: controller,
                    indicatorColor: Colors.transparent,
                    onTap: (int index){
                      controller.addListener(() {
                        return _handleTabSelection();
                      });
                    },
                    tabs: [
                      CustomTextButton(
                        onTap: (){
                          setState(() {
                            controller.animateTo(controller.index - 1);
                          });
                        },
                        color: controller.index == 0 ? darkBackgroundColor : darkBackgroundColor.withOpacity(0.6),
                        text: "A VENIR",
                        width: width,
                      ),
                      CustomTextButton(
                        onTap: (){
                          setState(() {
                            controller.animateTo(controller.index + 1);
                          });
                        },
                        color: controller.index == 1 ? darkBackgroundColor : darkBackgroundColor.withOpacity(0.6),
                        text: "PASSÉS",
                        width: width,
                      ),
                    ],
                  ),
                ),
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
          bottomNavigationBar: widget.from == 0 ? bottomBar() : const SizedBox(),
        );
      },
    );
  }
}
