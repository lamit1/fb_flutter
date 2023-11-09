import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fb_app/firebase_service.dart';
import 'package:meta/meta.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpInitial()) {
    on<SignUpButtonPressed>(_onSignUpButtonPressed);
  }

  void _onSignUpButtonPressed(SignUpButtonPressed event, Emitter<SignUpState> emit) async {
    print("Loading!");
    emit(SignUpLoading());
    try {
      final user = await signUpUser(event.email, event.password);
      if (user!=null) {
        emit(SignUpSuccess()); // If login is successful
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
