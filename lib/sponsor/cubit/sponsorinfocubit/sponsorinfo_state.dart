part of 'sponsorinfo_cubit.dart';

@immutable
sealed class SponsorinfoState {}

final class SponsorinfoInitial extends SponsorinfoState {}
final class SponsorinfoLoading extends SponsorinfoState {}
final class SponsorinfoLoaded extends SponsorinfoState {
  SponsorinfoLoaded({required this.sponsordetails});

  final Map sponsordetails;
  List<Object> get props => [sponsordetails];}
final class SponsorinfoError extends SponsorinfoState {}
final class SponsorinfoUpdateLoading extends SponsorinfoState {}
final class SponsorinfoUpdateLoaded extends SponsorinfoState {}
final class SponsorinfoupdateError extends SponsorinfoState {}
