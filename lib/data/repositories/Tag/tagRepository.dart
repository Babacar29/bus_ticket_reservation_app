// ignore_for_file: file_names

import 'package:burkina_transport_app/data/models/TagModel.dart';
import 'package:burkina_transport_app/data/repositories/Tag/tagRemoteDataSource.dart';

class TagRepository {
  static final TagRepository _tagRepository = TagRepository._internal();

  late TagRemoteDataSource _tagRemoteDataSource;

  factory TagRepository() {
    _tagRepository._tagRemoteDataSource = TagRemoteDataSource();
    return _tagRepository;
  }

  TagRepository._internal();

  Future<Map<String, dynamic>> getTag({required String langId}) async {
    final result = await _tagRemoteDataSource.getTag(langId: langId);

    return {
      "Tag": (result['data'] as List).map((e) => TagModel.fromJson(e)).toList(),
    };
  }
}
