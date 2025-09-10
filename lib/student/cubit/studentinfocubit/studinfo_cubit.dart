import 'package:bloc/bloc.dart';
import 'package:edusponsor/Common/enums/response_type_enum.dart';
import 'package:edusponsor/Common/network/dio_fetch_api.dart';
import 'package:meta/meta.dart';
import 'dart:developer' as developer;

part 'studinfo_state.dart';

class StudinfoCubit extends Cubit<StudinfoState> {
  StudinfoCubit() : super(StudinfoInitial());


  Future<void> getStudentInfo(Map body) async {
    emit(StudinfoLoading());
    await Future.delayed(const Duration(seconds: 2));
    try {
      final response = await FetchApi.postData(
        endPoint: 'student/get/info',
        body: body,
      );
      if ((response?['type'] == ServerResponseType.SUCCESS.name)) {
        emit(StudinfoLoaded(studentDetails: response['responseData']['data'][0]));
      } else if (response?['type'] == ServerResponseType.ERROR.name) {
        emit(StudinfoError());
      }
    } on Exception catch (e) {
      emit(StudinfoError());
      developer.log('', error: 'Unhandled exception: ${e.toString()}');
    }
  }


  Future<void> updateStudentInfo(Map body) async {
    emit(StudinfoUpdateLoading());
    await Future.delayed(const Duration(seconds: 2));
    try {
      final response = await FetchApi.postData(
        endPoint: 'student/update/info',
        body: body,
      );
      if ((response?['type'] == ServerResponseType.SUCCESS.name)) {
        emit(StudinfoUpdateloaded());
      } else if (response?['type'] == ServerResponseType.ERROR.name) {
        emit(StudinfoUpdateError());
      }
    } on Exception catch (e) {
      emit(StudinfoUpdateError());
      developer.log('', error: 'Unhandled exception: ${e.toString()}');
    }
  }
}
