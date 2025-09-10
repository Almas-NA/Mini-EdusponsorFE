part of 'studinfo_cubit.dart';

@immutable
sealed class StudinfoState {}

final class StudinfoInitial extends StudinfoState {}
final class StudinfoLoading extends StudinfoState {}
final class StudinfoLoaded extends StudinfoState {
  StudinfoLoaded({required this.studentDetails});

  final Map studentDetails;
  List<Object> get props => [studentDetails];}
final class StudinfoError extends StudinfoState {}

final class StudinfoUpdateLoading extends StudinfoState {}
final class StudinfoUpdateloaded extends StudinfoState {}
final class StudinfoUpdateError extends StudinfoState {}
