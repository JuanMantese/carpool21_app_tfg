import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'error_event.dart';
part 'error_state.dart';

class ErrorBloc extends Bloc<ErrorEvent, ErrorState> {
  ErrorBloc() : super(InitialErrorState()) {

    @override
    Stream<ErrorState> mapEventToState(ErrorEvent event) async* {
    if (event is RetryEvent) {
      // Maneja la lógica de reintento aquí
      yield InitialErrorState();
    }
  }
  }
}
