part of 'allinstitution_cubit.dart';

@immutable
sealed class AllinstitutionState {}

final class AllinstitutionInitial extends AllinstitutionState {}

final class AllinstitutionLoading extends AllinstitutionState {}

final class AllinstitutionLoaded extends AllinstitutionState {
  AllinstitutionLoaded({required this.institutions});

  final List institutions;
  List<Object> get props => [institutions];
}

final class AllinstitutionError extends AllinstitutionState {}
