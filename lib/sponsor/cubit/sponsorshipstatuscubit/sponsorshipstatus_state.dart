part of 'sponsorshipstatus_cubit.dart';

@immutable
sealed class SponsorshipstatusState {}

final class SponsorshipstatusInitial extends SponsorshipstatusState {}
final class SponsorshipstatusChanging extends SponsorshipstatusState {
  SponsorshipstatusChanging({required this.index});

  final int index;
  List<Object> get props => [index];}
final class SponsorshipstatusChanged extends SponsorshipstatusState {}
final class SponsorshipstatusChangeError extends SponsorshipstatusState {}
