part of 'profile_cubit.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileInfoLoading extends ProfileState {}

final class ProfileInfoSuccess extends ProfileState {
  ProfileInfoSuccess({required this.adminDetails});

  final Map adminDetails;
  List<Object> get props => [adminDetails];
}

final class ProfileInfoFailed extends ProfileState {}

final class ProfileUpdateLoading extends ProfileState {}

final class ProfileUpdateSuccess extends ProfileState {}

final class ProfileUpdateError extends ProfileState {}
