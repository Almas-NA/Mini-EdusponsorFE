part of 'dashboard_cubit.dart';

@immutable
sealed class DashboardState {}

final class DashboardInitial extends DashboardState {}

final class DashboardLoading extends DashboardState {}

final class DashboardLoaded extends DashboardState {
  DashboardLoaded({required this.dashboardInfo});
  final List dashboardInfo;
  List<Object> get props => [dashboardInfo];
}

final class DashboardError extends DashboardState {}