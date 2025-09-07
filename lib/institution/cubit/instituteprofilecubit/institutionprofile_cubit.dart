import 'package:bloc/bloc.dart';
import 'package:edusponsor/Common/enums/response_type_enum.dart';
import 'package:edusponsor/Common/network/dio_fetch_api.dart';
import 'package:meta/meta.dart';
import 'dart:developer' as developer;

part 'institutionprofile_state.dart';

class InstitutionprofileCubit extends Cubit<InstitutionprofileState> {
  InstitutionprofileCubit() : super(InstitutionprofileInitial());


  Future<void> getInstitutionInfo(Map body) async {
    emit(InstitutionprofileInfoLoading());
    await Future.delayed(const Duration(seconds: 2));
    try {
      final response = await FetchApi.postData(
        endPoint: 'institution/get/info',
        body: body,
      );
      if ((response?['type'] == ServerResponseType.SUCCESS.name)) {
        emit(InstitutionprofileInfoSuccess(institutionDetails: response['responseData']['data'][0]));
      } else if (response?['type'] == ServerResponseType.ERROR.name) {
        emit(InstitutionprofileInfoFailed());
      }
    } on Exception catch (e) {
      emit(InstitutionprofileInfoFailed());
      developer.log('', error: 'Unhandled exception: ${e.toString()}');
    }
  }

  Future<void> updateInstitutionInfo(Map body) async {
    emit(InstitutionprofileUpdateLoading());
    await Future.delayed(const Duration(seconds: 2));
    try {
      final response = await FetchApi.postData(
        endPoint: 'institution/update/info',
        body: body,
      );
      if ((response?['type'] == ServerResponseType.SUCCESS.name)) {
        emit(InstitutionprofileUpdateSuccess());
      } else if (response?['type'] == ServerResponseType.ERROR.name) {
        emit(InstitutionprofileUpdateError());
      }
    } on Exception catch (e) {
      emit(InstitutionprofileUpdateError());
      developer.log('', error: 'Unhandled exception: ${e.toString()}');
    }
  }
}
