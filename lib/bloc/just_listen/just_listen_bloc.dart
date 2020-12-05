import 'dart:async';

import 'package:panda/bloc/just_listen/just_listen_event.dart';
import 'package:panda/bloc/just_listen/just_listen_state.dart';
import 'package:panda/models/just_listen_model.dart';
import 'package:panda/provider/response_data.dart';
import 'package:panda/repository/just_listen_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

class JustListenBloc extends Bloc<JustListenEvent, JustListenState> {
  JustListenRepository justListenRepository = JustListenRepository();

  JustListenBloc() : super(JustListenInitial());

  @override
  JustListenState get initialState =>JustListenInitial();

  @override
  Stream<JustListenState> mapEventToState(JustListenEvent event) async* {
    if (event is Fetch) { 
      print("Test");
      yield JustListenLoading();
      try {
        final ResponseData<dynamic> response = await justListenRepository.getJustListens();
        if (response.status == Status.ConnectivityError) {
          yield const JustListenFailure(error: "");
        }
        if (response.status == Status.Success) {
          print(response.data);
          yield JustListenSuccess(justListen: response.data);
        } else {
          yield JustListenFailure(error: response.message);
        }
      } catch (error) {
        yield JustListenFailure(error: error.toString());
      }
    }
  }
}