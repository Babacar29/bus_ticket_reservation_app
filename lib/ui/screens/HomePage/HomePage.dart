// ignore_for_file: file_names
import 'package:burkina_transport_app/cubits/Auth/authCubit.dart';
import 'package:burkina_transport_app/ui/styles/colors.dart';
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
            appBar: const CustomAppBar(title: "Que voulez-vous faire ?",),
            body: SingleChildScrollView(
              child: Column(
                children: [
                   SizedBox(
                    height: height/250,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                          Routes.showAvailablePLace, arguments: {"from": 0});
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
                  Divider(
                    color: Colors.white,
                    height: height / 80,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(Routes.tickets);
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
                ],
              ),
            )
        );
      },
    );
  }
}
