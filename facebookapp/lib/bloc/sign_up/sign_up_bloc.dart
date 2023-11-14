import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fb_app/firebase_service.dart';
import 'package:fb_app/services/api_services.dart';
import 'package:meta/meta.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpInitial()) {
    on<SignUpButtonPressed>(_onSignUpButtonPressed);
  }

  void _onSignUpButtonPressed(SignUpButtonPressed event, Emitter<SignUpState> emit) async {
    emit(SignUpLoading());
    try {
      final message = await APIService().signUp(event.email, event.password);
      if (message=="1000") {
        emit(SignUpSuccess());
      } else if (message == "9996") {
        emit(SignUpFailure(error: "User existed!"));
      } else  {
        emit(SignUpFailure(error: "Invalid password!"));
      }
    } catch (error) {
      if (error is Exception) {
        emit(SignUpFailure(error: error.toString()));
      } else {
        emit(SignUpFailure(error: "An unexpected error occurred."));
      }
    }
  }
}
