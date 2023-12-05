import 'package:bloc/bloc.dart';
import 'package:fb_app/services/api/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed); // Register the event handler
  }
  void _onLoginButtonPressed(LoginButtonPressed event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      // For example, you can call the AuthenticationRepository to log in the user.
      //User with non-firebase login api call
      final user = await Auth().login(event.email, event.password);
      //Use with firebase login api call
      // final user = await login(event.email, event.password);
      if (user!=null) {
        emit(LoginSuccess()); // If login is successful
      }
    } catch (error) {
      if (error is Exception) {
        emit(LoginFailure(error: error.toString()));
      } else {
        emit(LoginFailure(error: "An unexpected error occurred."));
      }
    }
  }
}
