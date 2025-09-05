import 'package:bloc/bloc.dart';
import 'package:edusponsor/Common/enums/response_type_enum.dart';
import 'package:edusponsor/Common/network/dio_fetch_api.dart';
import 'package:meta/meta.dart';
import 'dart:developer' as developer;

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(DashboardInitial());

  Future<void> getDashboardData() async {
    emit(DashboardLoading());
    await Future.delayed(const Duration(seconds: 2));
    try {
      final response = await FetchApi.getData(endPoint: 'admin/dashboard/data');
      if ((response?['type'] == ServerResponseType.SUCCESS.name)) {
        emit(
          DashboardLoaded(
            dashboardInfo: response['responseData']['data'] ?? [],
          ),
        );
      } else if (response?['type'] == ServerResponseType.ERROR.name) {
        emit(DashboardError());
      }
    } on Exception catch (e) {
      emit(DashboardError());
      developer.log('', error: 'Unhandled exception: ${e.toString()}');
    }
  }
}
