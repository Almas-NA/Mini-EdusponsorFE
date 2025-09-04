import 'package:bloc/bloc.dart';
import 'package:edusponsor/Common/enums/response_type_enum.dart';
import 'package:edusponsor/Common/network/dio_fetch_api.dart';
import 'package:meta/meta.dart';
import 'dart:developer' as developer;

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());


  Future<void> getAdminInfo(Map body) async {
    emit(ProfileInfoLoading());
    await Future.delayed(const Duration(seconds: 2));
    try {
      final response = await FetchApi.postData(
        endPoint: 'admin/get/info',
        body: body,
      );
      if ((response?['type'] == ServerResponseType.SUCCESS.name)) {
        emit(ProfileInfoSuccess(adminDetails: response['responseData']['data'][0]));
      } else if (response?['type'] == ServerResponseType.ERROR.name) {
        emit(ProfileInfoFailed());
      }
    } on Exception catch (e) {
      emit(ProfileInfoFailed());
      developer.log('', error: 'Unhandled exception: ${e.toString()}');
    }
  }


  Future<void> updateAdminInfo(Map body) async {
    emit(ProfileUpdateLoading());
    await Future.delayed(const Duration(seconds: 2));
    try {
      final response = await FetchApi.postData(
        endPoint: 'admin/update/info',
        body: body,
      );
      if ((response?['type'] == ServerResponseType.SUCCESS.name)) {
        emit(ProfileUpdateSuccess());
      } else if (response?['type'] == ServerResponseType.ERROR.name) {
        emit(ProfileUpdateError());
      }
    } on Exception catch (e) {
      emit(ProfileUpdateError());
      developer.log('', error: 'Unhandled exception: ${e.toString()}');
    }
  }
}
