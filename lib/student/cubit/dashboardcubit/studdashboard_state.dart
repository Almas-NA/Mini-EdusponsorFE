part of 'studdashboard_cubit.dart';

@immutable
sealed class StuddashboardState {}

final class StuddashboardInitial extends StuddashboardState {}
final class SponsorshipStatusLoading extends StuddashboardState {}
final class SponsorshipStatusLoaded extends StuddashboardState {
  SponsorshipStatusLoaded({required this.sponsorshipStatus});

  final Map sponsorshipStatus;
  List<Object> get props => [sponsorshipStatus];
}
final class SponsorshipStatusError extends StuddashboardState {}
