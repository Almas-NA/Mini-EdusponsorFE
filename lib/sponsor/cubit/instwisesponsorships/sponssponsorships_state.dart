part of 'sponssponsorships_cubit.dart';

@immutable
sealed class SponssponsorshipsState {}

final class SponssponsorshipsInitial extends SponssponsorshipsState {}
final class SponssponsorshipsLoading extends SponssponsorshipsState {}
final class SponssponsorshipsLoaded extends SponssponsorshipsState {
  SponssponsorshipsLoaded({required this.sponsorships});

  final List sponsorships;
  List<Object> get props => [sponsorships];}
final class SponssponsorshipsError extends SponssponsorshipsState {}
