// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:bus_ticket_reservation_app/ui/widgets/customTextLabel.dart';
import 'package:bus_ticket_reservation_app/utils/uiUtils.dart';

import 'package:bus_ticket_reservation_app/app/routes.dart';

setForgotPass(BuildContext context) {
  return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Align(
        alignment: Alignment.topRight,
        child: TextButton(
          onPressed: () {
            Navigator.of(context).pushNamed(Routes.forgotPass);
          },
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            foregroundColor: MaterialStateProperty.all(UiUtils.getColorScheme(context).primaryContainer.withOpacity(0.7)),
          ),
          child: const CustomTextLabel(
            text: 'forgotPassLbl',
          ),
        ),
      ));
}
