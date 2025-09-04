part of 'institutionstatus_cubit.dart';

@immutable
sealed class InstitutionstatusState {}

final class InstitutionstatusInitial extends InstitutionstatusState {}

final class InstitutionsStatusChangeLoading extends InstitutionstatusState {
  InstitutionsStatusChangeLoading({required this.index,required this.button});

  final int index;
  final String button;
  List<Object> get props => [index,button];
}

final class InstitutionsStatusChangeSuccess extends InstitutionstatusState {}

final class InstitutionsStatusChangeError extends InstitutionstatusState {}
