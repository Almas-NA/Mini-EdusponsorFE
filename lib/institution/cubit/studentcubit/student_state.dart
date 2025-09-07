part of 'student_cubit.dart';

@immutable
sealed class StudentState {}

final class StudentInitial extends StudentState {}

final class StudentAddLoading extends StudentState {}

final class StudentAddSuccess extends StudentState {}

final class StudentAddError extends StudentState {}

final class StudentGetLoading extends StudentState {}

final class StudentGetSuccess extends StudentState {
  StudentGetSuccess({required this.institutionStudents});

  final List institutionStudents;
  List<Object> get props => [institutionStudents];
}

final class StudentGetError extends StudentState {}

final class StudentUpdateLoading extends StudentState {}

final class StudentUpdateSuccess extends StudentState {}

final class StudentUpdateError extends StudentState {}

final class StudentDeleteLoading extends StudentState {}

final class StudentDeleteSuccess extends StudentState {}

final class StudentDeleteError extends StudentState {}

final class StudentAddYearFeesLoading extends StudentState {}

final class StudentAddYearFeesSuccess extends StudentState {}

final class StudentAddYearFeesError extends StudentState {}