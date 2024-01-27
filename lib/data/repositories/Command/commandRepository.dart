// ignore_for_file: file_names, use_build_context_synchronously

import 'commandRemoteDataSource.dart';


class CommandRepository {
  static final CommandRepository _commandRepository = CommandRepository._internal();
  late CommandRemoteDataSource _commandRemoteDataSource;

  factory CommandRepository() {
    _commandRepository._commandRemoteDataSource = CommandRemoteDataSource();
    return _commandRepository;
  }

  CommandRepository._internal();

  Future<dynamic> command({ required Map<String, dynamic> body}) async {
    final result = await _commandRemoteDataSource.command(body: body);
    return result;
  }

  Future<dynamic> postPassengersData({ required List<dynamic> body, required String commandId}) async {
    final result = await _commandRemoteDataSource.postPassengersData(body: body, commandId: commandId);
    return result;
  }

  Future<dynamic> getPlaceRepresentationData({required String departureId}) async {
    final result = await _commandRemoteDataSource.getPlacesRepresentation(departureId: departureId);
    return result;
  }


  Future<dynamic> sendSeatsData({required String commandId, required Map<String, dynamic> body}) async {
    final result = await _commandRemoteDataSource.sendSeatsData(commandId: commandId, body: body);
    return result;
  }

}
