part of 'sponsorstatus_cubit.dart';

@immutable
sealed class SponsorstatusState {}

final class SponsorstatusInitial extends SponsorstatusState {}
final class SponsorstatusLoading extends SponsorstatusState {
  SponsorstatusLoading({required this.index,required this.button});

  final int index;
  final String button;
  List<Object> get props => [index,button];
}
final class SponsorstatusSuccess extends SponsorstatusState {}
final class SponsorstatusError extends SponsorstatusState {}
