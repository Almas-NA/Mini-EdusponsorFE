part of 'institutions_cubit.dart';

@immutable
sealed class InstitutionsState {}

final class InstitutionsInitial extends InstitutionsState {}

final class InstitutionsLoading extends InstitutionsState {}

final class InstitutionsLoaded extends InstitutionsState {
  InstitutionsLoaded({required this.institutionNotApproved});

  final List institutionNotApproved;
  List<Object> get props => [institutionNotApproved];
}

final class InstitutionsError extends InstitutionsState {}

