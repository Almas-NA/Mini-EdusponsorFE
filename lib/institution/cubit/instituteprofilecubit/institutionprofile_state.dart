part of 'institutionprofile_cubit.dart';

@immutable
sealed class InstitutionprofileState {}

final class InstitutionprofileInitial extends InstitutionprofileState {}

final class InstitutionprofileInfoLoading extends InstitutionprofileState {}

final class InstitutionprofileInfoSuccess extends InstitutionprofileState {
  InstitutionprofileInfoSuccess({required this.institutionDetails});

  final Map institutionDetails;
  List<Object> get props => [institutionDetails];
}

final class InstitutionprofileInfoFailed extends InstitutionprofileState {}

final class InstitutionprofileUpdateLoading extends InstitutionprofileState {}

final class InstitutionprofileUpdateSuccess extends InstitutionprofileState {}

final class InstitutionprofileUpdateError extends InstitutionprofileState {}
