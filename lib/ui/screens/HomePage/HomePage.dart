// ignore_for_file: file_names
import 'package:bus_ticket_reservation_app/cubits/Auth/authCubit.dart';
import 'package:bus_ticket_reservation_app/ui/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/routes.dart';
import '../../widgets/myAppBar.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
            appBar: const CustomAppBar(title: "Bienvenue",),
            body: SizedBox(
              height: height,
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                            Routes.chooseCategory, arguments: {"from": 0}
                        );
                      },
                      child: Container(
                        height: height / 2.7,
                        color: darkSecondaryColor.withOpacity(0.9),
                        child: const Center(
                          child: Text(
                            "ACHETER UN TICKET",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.white,
                    height: height / 80,
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(Routes.tickets, arguments: {"from": 0});
                      },
                      child: Container(
                        height: height / 2.7,
                        color: darkSecondaryColor.withOpacity(0.9),
                        child: const Center(
                          child: Text(
                            "VOIR MES TICKETS",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
        );
      },
    );
  }
}
