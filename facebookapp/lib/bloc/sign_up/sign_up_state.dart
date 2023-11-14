part of 'sign_up_bloc.dart';

@immutable
abstract class SignUpState {}

class SignUpInitial extends SignUpState {}


class SignUpLoading extends SignUpState {
  @override
  List<Object> get props => [];
}

class SignUpSuccess extends SignUpState {
  @override
  List<Object> get props => [];
}


class SignUpFailure extends SignUpState {
  final String error;

  SignUpFailure({required this.error});

  @override
  List<Object> get props => [error];

}