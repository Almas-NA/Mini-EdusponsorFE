import 'package:bloc/bloc.dart';
import 'package:edusponsor/Common/enums/response_type_enum.dart';
import 'package:edusponsor/Common/network/dio_fetch_api.dart';
import 'package:meta/meta.dart';
import 'dart:developer' as developer;

part 'allsponsorcubit_state.dart';

class AllsponsorcubitCubit extends Cubit<AllsponsorcubitState> {
  AllsponsorcubitCubit() : super(AllsponsorcubitInitial());

  Future<void> getAllSponsors() async {
    emit(AllsponsorcubitLoading());
    await Future.delayed(const Duration(seconds: 2));
    try {
      final response = await FetchApi.getData(endPoint: 'admin/sponsors');
      if ((response?['type'] == ServerResponseType.SUCCESS.name)) {
        emit(
          AllsponsorcubitLoaded(
            sponsors: response['responseData']['data'] ?? [],
          ),
        );
      } else if (response?['type'] == ServerResponseType.ERROR.name) {
        emit(AllsponsorcubitError());
      }
    } on Exception catch (e) {
      emit(AllsponsorcubitError());
      developer.log('', error: 'Unhandled exception: ${e.toString()}');
    }
  }
}
