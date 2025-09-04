import 'package:bloc/bloc.dart';
import 'package:edusponsor/Common/enums/response_type_enum.dart';
import 'package:edusponsor/Common/network/dio_fetch_api.dart';
import 'package:meta/meta.dart';
import 'dart:developer' as developer;

part 'allinstitution_state.dart';

class AllinstitutionCubit extends Cubit<AllinstitutionState> {
  AllinstitutionCubit() : super(AllinstitutionInitial());

  Future<void> getAllInstitutions() async {
    emit(AllinstitutionLoading());
    await Future.delayed(const Duration(seconds: 2));
    try {
      final response = await FetchApi.getData(endPoint: 'admin/institutions');
      if ((response?['type'] == ServerResponseType.SUCCESS.name)) {
        emit(
          AllinstitutionLoaded(
            institutions: response['responseData']['data'] ?? [],
          ),
        );
      } else if (response?['type'] == ServerResponseType.ERROR.name) {
        emit(AllinstitutionError());
      }
    } on Exception catch (e) {
      emit(AllinstitutionError());
      developer.log('', error: 'Unhandled exception: ${e.toString()}');
    }
  }
}
