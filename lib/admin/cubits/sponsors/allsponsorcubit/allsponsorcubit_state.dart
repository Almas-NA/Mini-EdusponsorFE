part of 'allsponsorcubit_cubit.dart';

@immutable
sealed class AllsponsorcubitState {}

final class AllsponsorcubitInitial extends AllsponsorcubitState {}
final class AllsponsorcubitLoading extends AllsponsorcubitState {}
final class AllsponsorcubitLoaded extends AllsponsorcubitState {
  AllsponsorcubitLoaded({required this.sponsors});
  final List sponsors;
  List<Object> get props => [sponsors];
}
final class AllsponsorcubitError extends AllsponsorcubitState {}
