part of 'sponsorshipstatus_cubit.dart';

@immutable
sealed class SponsorshipstatusState {}

final class SponsorshipstatusInitial extends SponsorshipstatusState {}
final class SponsorshipstatusChanging extends SponsorshipstatusState {}
final class SponsorshipstatusChanged extends SponsorshipstatusState {}
final class SponsorshipstatusChangeError extends SponsorshipstatusState {}
