part of 'register_cubit.dart';

@immutable
sealed class RegisterState {}

final class RegisterInitial extends RegisterState {}

final class RegisterInstLoading extends RegisterState {}

final class RegisterInstSuccess extends RegisterState {}

final class RegisterInstWarning extends RegisterState {}

final class RegisterInstFailed extends RegisterState {}

final class RegisterSponsLoading extends RegisterState {}

final class RegisterSponsSuccess extends RegisterState {}

final class RegisterSponsWarning extends RegisterState {}

final class RegisterSponsFailed extends RegisterState {}
