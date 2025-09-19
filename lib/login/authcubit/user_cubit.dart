import 'package:bloc/bloc.dart';
import 'package:edusponsor/Common/enums/response_type_enum.dart';
import 'package:edusponsor/Common/network/dio_fetch_api.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'dart:developer' as developer;

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  Box box = Hive.box('eduSponsor');

  Future<void> userLogin(String userName, String password) async {
    emit(LoginLoading());
    await Future.delayed(const Duration(seconds: 2));
    try {
      Map<String, String> requestHeaders = {
        'password': password,
        'username': userName,
      };

      final response = await FetchApi.postData(
        endPoint: 'auth/login',
        body: requestHeaders,
        requiresToken: false,
      );
      if (response?['type'] == ServerResponseType.SUCCESS.name) {
        List dataList =
            ((response['responseData'] ?? {})['data'] ?? []) as List;
        String accessToken = dataList[0]['accessToken'];
        Map userDetails = dataList[0]['data'] ?? [];
        box.put('accesstoken', accessToken);
        emit(LoginSuccess(userDetails: userDetails));
      } else if (response?['type'] == ServerResponseType.ERROR.name) {
        List message = response['responseData']['message'];
        emit(LoginFailed(responseData: message));
      }
    } on Exception catch (e) {
      emit(LoginFailed(responseData: []));
      developer.log('', error: 'Unhandled exception: ${e.toString()}');
    }
  }

  Future<void> userLogOut(BuildContext context) async {
    emit(LogOutLoading());
    await Future.delayed(const Duration(seconds: 2));
    try {
      final response = await FetchApi.postData(endPoint: 'user/logout');
      if (response?['type'] == ServerResponseType.SUCCESS.name) {
        box.delete('accesstoken');
        emit(LogOutSuccess());
      }
    } on Exception catch (e) {
      emit(LoginFailed(responseData: []));
      developer.log('', error: 'Unhandled exception: ${e.toString()}');
    }
  }
}
