import 'package:bloc/bloc.dart';
import 'package:fb_app/models/login_model.dart';
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
      final LoginResponse? loginResponse = await Auth().login(event.email, event.password);
      if (loginResponse!.id != null) {
        if(loginResponse.active == "1") {
          emit(LoginSuccess(uid: loginResponse.id!,));
        } else if (loginResponse.active == "-1") {
          emit(LoginChangeInfo(uid: loginResponse.id!));
        }  else if (loginResponse.active == "0") {
          emit(LoginOTP(uid: loginResponse.id!));
        } else {
          LoginFailure(error: "An unexpected error occurred.");
        }
      }
    } catch (error) {
      emit(LoginFailure(error: "An unexpected error occurred. $error"));
    }
  }
}
