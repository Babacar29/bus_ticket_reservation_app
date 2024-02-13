// ignore_for_file: file_names, use_build_context_synchronously

import 'TicketsRemoteDataSource.dart';



class TicketsRepository {
  static final TicketsRepository _trajetsRepository = TicketsRepository._internal();
  late TicketsRemoteDataSource _trajetsRemoteDataSource;

  factory TicketsRepository() {
    _trajetsRepository._trajetsRemoteDataSource = TicketsRemoteDataSource();
    return _trajetsRepository;
  }

  TicketsRepository._internal();



  //to update fcmId user's data to database. This will be in use when authenticating using fcmId
  Future<dynamic> getTickets() async {
    final result = await _trajetsRemoteDataSource.getTickets();
    return result;
  }

}
