// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/routes.dart';
import '../data/repositories/Tickets/TicketsRepositories.dart';



@immutable
abstract class TicketsState {}

class TicketsInitial extends TicketsState {}

class TicketsProgress extends TicketsState {}

class TicketsSuccess extends TicketsState {
  TicketsSuccess();
}

class TicketsFailure extends TicketsState {
  final String errorMessage;

  TicketsFailure(this.errorMessage);
}

class TicketsCubit extends Cubit<TicketsState> {
  final TicketsRepository _ticketsRepository;

  TicketsCubit(this._ticketsRepository) : super(TicketsInitial());

  //to socialLogin user
  Future<dynamic> getTickets({required BuildContext context}) {
    late Future result;

    try {
      emit(TicketsProgress());
      result =  _ticketsRepository.getTickets();
      /*if(result != null){
        Navigator.of(context).pushNamed(Routes.tickets, arguments: {"from": 1});
      }*/
      emit(TicketsSuccess());
    }
    catch(e){
      emit(TicketsFailure(e.toString()));
    }
    return result;
  }
}
