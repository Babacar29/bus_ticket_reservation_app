import 'package:burkina_transport_app/cubits/Payments/paymentCubit.dart';
import 'package:burkina_transport_app/cubits/ticketsCubit.dart';
import 'package:burkina_transport_app/ui/widgets/circularProgressIndicator.dart';
import 'package:burkina_transport_app/utils/ErrorMessageKeys.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:intl/intl.dart';

import '../../../utils/internetConnectivity.dart';
import '../../../utils/uiUtils.dart';
import '../../styles/colors.dart';
import '../../widgets/customTextLabel.dart';
import '../../widgets/myAppBar.dart';
import '../Profile/ProfileScreen.dart';
import '../Tickets/TicketsScreen.dart';

class PaymentStarted extends StatefulWidget {
  const PaymentStarted({super.key, this.from, required this.commandData});
  final int? from;
  final Map<String, dynamic> commandData;

  @override
  State<PaymentStarted> createState() => _PaymentStartedState();

  static Route route(RouteSettings routeSettings) {
    final arguments = routeSettings.arguments as Map<String, dynamic>;
    return CupertinoPageRoute(
        builder: (_) => PaymentStarted(
          from: arguments['from'],
          commandData: arguments['commandData'],
        )
    );
  }
}

class _PaymentStartedState extends State<PaymentStarted> {
  TextEditingController numController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  int _selectedIndex = 0;
  List<IconData> iconList = [
    Icons.bookmark,
    Icons.bookmark,
    Icons.account_circle,
  ];
  var data = {};
  var paymentsAvailable = [];
  Map<String, dynamic> paymentInfo = {};

  getData(String commandId) async {
    final result = await context.read<PaymentCubit>().getCommandDetails(commandId: commandId);
    final result1 = await context.read<PaymentCubit>().getAvailablePayments();
    if(!mounted) return;
    setState(() {
      data = result;
      paymentsAvailable = result1;
    });
    debugPrint("Payment infos ==========>$paymentsAvailable");
  }

  @override
  void initState() {
    getData(widget.commandData["id"]);
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
        width: MediaQuery.sizeOf(context).width / iconList.length,
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

  Widget showBody (BuildContext context){
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return BlocConsumer<PaymentCubit, PaymentState>(
      listener: (context, state) {
        if(state is PaymentFailure){
          showCustomSnackBar(context: context, message: state.errorMessage);
        }
      },
      builder: (context, state) {
        return BlocConsumer<PaymentCubit, PaymentState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            return Stack(
              children: [
                SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Padding(
                      padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            color: Colors.white,
                            width: width,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0, top: 10, bottom: 10),
                              child: Text(
                                data["departureDate"] != null ? "Le ${DateFormat('d MMMM yyyy').format(DateTime.tryParse(data["departureDate"])!)}, ${data["departureTime"] ?? ""}" : "" ,
                                style: const TextStyle(
                                    color: darkBackgroundColor
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10,),
                          Container(
                            color: darkBackgroundColor,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "${data["departureCity"] ?? ""}",
                                    style: const TextStyle(
                                        color: Colors.white
                                    ),
                                  ),
                                  const Spacer(),
                                  const Text(
                                    "Ville de départ",
                                    style: TextStyle(
                                        color: Colors.white
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10,),
                          Container(
                            color: darkBackgroundColor,
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "${data["arrivalCity"]  ?? ""}",
                                    style: const TextStyle(
                                        color: Colors.white
                                    ),
                                  ),
                                  const Spacer(),
                                  const Text(
                                    "Ville d'arrivée",
                                    style: TextStyle(
                                        color: Colors.white
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10,),
                          Container(
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  const Text(
                                    "Cout total du billet:",
                                    style: TextStyle(
                                        color: darkBackgroundColor
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    "${data["price"]  ?? ""} FCFA",
                                    style: const TextStyle(
                                        color: darkBackgroundColor
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 30,),
                          const Text(
                            "Choisissez votre mode de paiement",
                            style: TextStyle(
                                color: darkBackgroundColor
                            ),
                          ),
                          const SizedBox(height: 5,),
                          Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: textFormField(controller: numController, hintText: "Numéro de téléphone"),
                            ),
                          ),
                          const SizedBox(height: 10,),
                          paymentsAvailable.isEmpty ? const  SizedBox() : SizedBox(
                            height: MediaQuery.sizeOf(context).height/4,
                            child: ListView.builder(
                                itemCount: paymentsAvailable.length,
                                shrinkWrap: true,
                                physics: const ClampingScrollPhysics(),
                                itemBuilder: (context, int i){
                                  var item = paymentsAvailable[i];
                                  return GestureDetector(
                                    onTap: () async{
                                      simHintDialog(item["id"]);
                                    },
                                    child: Container(
                                      color: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          children: [
                                            Image.asset("assets/orange_money.jpeg", height: height/25,),
                                            SizedBox(width: width/20,),
                                            Text(
                                              item["name"] ?? "",
                                              textScaler: const TextScaler.linear(1.5),
                                              style: const TextStyle(
                                                  color: darkBackgroundColor,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }
                            ),
                          ),
                        ],
                      )
                  ),
                ),
                if(state is PaymentProgress) showCircularProgress(true, darkBackgroundColor)
              ],
            );
          },
        );
      },
    );
  }

  TextFormField textFormField({required TextEditingController controller, required String hintText}) {
    return TextFormField(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.2))
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: darkBackgroundColor, width: 3),
        ),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.4))
        ),
        labelStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 15,
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 16,
        ),
      ),
      validator: (val){
        /*if(expirationDateController.text.isEmpty){
          return Validators.notEmptyValidation(val!, context);
        }*/
      },
      keyboardType: TextInputType.phone,
      cursorHeight: 18,
      controller: controller,
      cursorColor: Colors.black,
      style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 16
      ),
      onChanged: (String value) {
      },
      textAlignVertical: TextAlignVertical.center,
      textInputAction: TextInputAction.done,
    );
  }

  simHintDialog(String methodPayment) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (BuildContext context, StateSetter setStater) {
            return AlertDialog(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
              content: CustomTextLabel(text: 'SimHintLbl', textStyle: Theme.of(this.context).textTheme.titleMedium?.copyWith(color: UiUtils.getColorScheme(context).primaryContainer, fontSize: 18), textAlign: TextAlign.center),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        child: CustomTextLabel(
                            text: 'noLbl', textStyle: Theme.of(this.context).textTheme.titleSmall?.copyWith(color: UiUtils.getColorScheme(context).primaryContainer, fontWeight: FontWeight.bold)
                        ),
                        onPressed: () async{
                          if (await InternetConnectivity.isNetworkAvailable()) {
                            context.read<PaymentCubit>().sendOtp(
                            canCall: false,
                            command: widget.commandData,
                            paymentMethod: methodPayment,
                            phoneNumber: numController.text,
                            context: context
                            );
                          }
                          else {
                          showCustomSnackBar(context: context, message: ErrorMessageKeys.noInternet);
                          }
                        }
                    ),
                    TextButton(
                        child: CustomTextLabel(
                            text: 'yesLbl', textStyle: Theme.of(this.context).textTheme.titleSmall?.copyWith(color: UiUtils.getColorScheme(context).primaryContainer, fontWeight: FontWeight.bold)),
                        onPressed: () {
                          Navigator.of(context).pop();
                          generateOtpHintDialog(methodPayment);
                        }
                    )
                  ],
                ),
              ],
            );
          });
        });
  }

  _callNumber(String code) async{
   bool? res = await FlutterPhoneDirectCaller.callNumber(code);
   return res;
  }

  generateOtpHintDialog(String methodPayment) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (BuildContext context, StateSetter setStater) {
            return AlertDialog(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
              content: CustomTextLabel(text: 'otpHintLbl', textStyle: Theme.of(this.context).textTheme.titleMedium?.copyWith(color: UiUtils.getColorScheme(context).primaryContainer, fontSize: 18), textAlign: TextAlign.center,),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        child: CustomTextLabel(
                            text: 'noLbl', textStyle: Theme.of(this.context).textTheme.titleSmall?.copyWith(color: UiUtils.getColorScheme(context).primaryContainer, fontWeight: FontWeight.bold)
                        ),
                        onPressed: () async{
                          if (await InternetConnectivity.isNetworkAvailable()) {
                            context.read<PaymentCubit>().sendOtp(
                            canCall: false,
                            command: widget.commandData,
                            paymentMethod: methodPayment,
                            phoneNumber: numController.text,
                            context: context
                            );
                          }
                          else {
                          showCustomSnackBar(context: context, message: ErrorMessageKeys.noInternet);
                          }
                        }
                    ),
                    TextButton(
                        child: CustomTextLabel(
                            text: 'yesLbl', textStyle: Theme.of(this.context).textTheme.titleSmall?.copyWith(color: UiUtils.getColorScheme(context).primaryContainer, fontWeight: FontWeight.bold)),
                        onPressed: () async {
                          if (await InternetConnectivity.isNetworkAvailable()) {
                           final data = await context.read<PaymentCubit>().sendOtp(
                                canCall: true,
                                command: widget.commandData,
                                paymentMethod: methodPayment,
                                phoneNumber: numController.text,
                                context: context
                            );
                           debugPrint("otp result ========> $data");
                           Navigator.of(context).pop();
                           bool otpGenerated = await _callNumber(data["transactionCode"]);
                           if(otpGenerated){
                             paidDialog(data);
                           }
                          }
                          else {
                            showCustomSnackBar(context: context, message: ErrorMessageKeys.noInternet);
                          }
                        })
                  ],
                ),
              ],
            );
          });
        });
  }

  paidDialog(Map<String, dynamic> paymentInfo) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (BuildContext context, StateSetter setStater) {
            return AlertDialog(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
              title: CustomTextLabel(text: 'payOrderTitle', textStyle: Theme.of(this.context).textTheme.titleMedium?.copyWith(color: Colors.grey, fontSize: 18), textAlign: TextAlign.center,),
              content: SizedBox(
                height: MediaQuery.sizeOf(context).height/5,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Téléphone",
                          textScaler: TextScaler.linear(1.1),
                          style: TextStyle(
                            color: Colors.grey
                          ),
                        ),
                        Text(
                          "${paymentInfo["phoneNumber"]}",
                          textScaler: const TextScaler.linear(1.1),
                          style: const TextStyle(
                            color: Colors.grey
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Nombre de ticket(s)",
                          textScaler: TextScaler.linear(1.1),
                          style: TextStyle(
                            color: Colors.grey
                          ),
                        ),
                        Text(
                          "${paymentInfo["ticketNumber"]}",
                          textScaler: const TextScaler.linear(1.1),
                          style: const TextStyle(
                            color: Colors.grey
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Prix",
                          textScaler: TextScaler.linear(1.1),
                          style: TextStyle(
                            color: Colors.grey
                          ),
                        ),
                        Text(
                          "${paymentInfo["initPrice"]} FCFA",
                          textScaler: const TextScaler.linear(1.1),
                          style: const TextStyle(
                            color: Colors.grey
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          "Code de paiement",
                          textScaler: TextScaler.linear(1.1),
                          style: TextStyle(
                            color: Colors.grey
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width/4,
                          child: textFormField(controller: codeController, hintText: "code")
                        )
                      ],
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async{
                        if (await InternetConnectivity.isNetworkAvailable()) {
                          await context.read<PaymentCubit>().payCommand(
                              commandId: widget.commandData["id"],
                              value: codeController.text,
                              context: context
                          );
                          //Navigator.of(context).pop();
                          //Navigator.of(context).pop();
                        }
                        else {
                          showCustomSnackBar(context: context, message: ErrorMessageKeys.noInternet);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: darkBackgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)
                        )
                      ),
                      child: Text(
                        "Acheter",
                        style: TextStyle(
                          color: Colors.white
                        ),
                      )
                    )
                  ],
                ),
              ],
            );
          });
        });
  }

  Widget showContent(){
    return Scaffold(
      appBar: const CustomAppBar(title: "Récapulatif et paiement"),
      backgroundColor: darkBackgroundColor.withOpacity(0.15),
      body: showBody(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          showContent(),
          //Add only if Category Mode is enabled From Admin panel.
          const TicketsScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: bottomBar(),
    );
  }

  @override
  void dispose() {
    numController.dispose();
    codeController.dispose();
    super.dispose();
  }
}
