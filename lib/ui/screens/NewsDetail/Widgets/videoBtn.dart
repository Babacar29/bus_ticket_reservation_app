// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:burkina_transport_app/data/models/BreakingNewsModel.dart';
import 'package:burkina_transport_app/data/models/NewsModel.dart';
import 'package:burkina_transport_app/ui/styles/colors.dart';
import 'package:burkina_transport_app/app/routes.dart';

Widget videoBtn({required BuildContext context, required bool isFromBreak, NewsModel? model, BreakingNewsModel? breakModel}) {
  if ((breakModel != null && breakModel.contentValue != "") || model != null && model.contentValue != "") {
    return Positioned.directional(
        textDirection: Directionality.of(context),
        top: 35,
        end: 20.0,
        child: InkWell(
          child: Container(
            height: 39,
            width: 39,
            decoration: const BoxDecoration(color: secondaryColor, shape: BoxShape.circle),
            child: const Icon(
              Icons.play_arrow_rounded,
              color: darkSecondaryColor,
            ),
          ),
          onTap: () {
            Navigator.of(context).pushNamed(Routes.newsVideo, arguments: (!isFromBreak) ? {"from": 1, "model": model} : {"from": 3, "breakModel": breakModel});
          },
        ));
  } else {
    return const SizedBox.shrink();
  }
}
