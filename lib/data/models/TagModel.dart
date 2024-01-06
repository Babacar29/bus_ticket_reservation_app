// ignore_for_file: file_names

import 'package:burkina_transport_app/utils/strings.dart';

class TagModel {
  String? id, tagName;

  TagModel({this.id, this.tagName});

  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(
      id: json[ID],
      tagName: json[TAGNAME],
    );
  }
}
