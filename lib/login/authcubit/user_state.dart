part of 'user_cubit.dart';

@immutable
sealed class UserState {}

final class UserInitial extends UserState {}

final class LoginLoading extends UserState {}

final class LoginSuccess extends UserState {

  LoginSuccess({required this.userDetails});

  final Map userDetails;
  List<Object> get props => [userDetails];
}

final class LoginFailed extends UserState {

  LoginFailed({required this.responseData});

  final List responseData;
  List<Object> get props => [responseData];
}

final class LogOutLoading extends UserState {}
final class LogOutSuccess extends UserState {}