part of 'sponsor_cubit.dart';

@immutable
sealed class SponsorState {}

final class SponsorInitial extends SponsorState {}
final class SponsorLoading extends SponsorState {}
final class SponsorLoaded extends SponsorState {
  SponsorLoaded({required this.sponsors});
  final List sponsors;
  List<Object> get props => [sponsors];
}
final class SponsorError extends SponsorState {}
