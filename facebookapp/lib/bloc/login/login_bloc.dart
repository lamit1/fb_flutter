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
      final String? id = await Auth().login(event.email, event.password);
      if (id!=null) {
        emit(LoginSuccess(uid: id,));
      }
    } catch (error) {
      emit(LoginFailure(error: "An unexpected error occurred. $error"));
    }
  }
}
