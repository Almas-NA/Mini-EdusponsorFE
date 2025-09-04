import 'package:bloc/bloc.dart';
import 'package:edusponsor/Common/enums/response_type_enum.dart';
import 'package:edusponsor/Common/network/dio_fetch_api.dart';
import 'dart:developer' as developer;
import 'package:meta/meta.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  Future<void> registerInstitution(Map body) async {
    emit(RegisterInstLoading());
    await Future.delayed(const Duration(seconds: 2));
    try {
      final response = await FetchApi.postData(
        endPoint: 'auth/register/institution',
        body: body,
        requiresToken: false,
      );
      if ((response?['type'] == ServerResponseType.SUCCESS.name)) {
        emit(RegisterInstSuccess());
      } else if (response?['type'] == ServerResponseType.ERROR.name ||
          response?['type'] == ServerResponseType.WARNING.name) {
        emit(RegisterInstFailed());
      } else {
        emit(RegisterInstWarning());
      }
    } on Exception catch (e) {
      emit(RegisterInstFailed());
      developer.log('', error: 'Unhandled exception: ${e.toString()}');
    }
  }

  Future<void> registerSponsor(Map body) async {
    emit(RegisterSponsLoading());
    await Future.delayed(const Duration(seconds: 2));
    try {
      final response = await FetchApi.postData(
        endPoint: 'auth/register/sponsor',
        body: body,
        requiresToken: false,
      );
      if ((response?['type'] == ServerResponseType.SUCCESS.name)) {
        emit(RegisterInstSuccess());
      } else if (response?['type'] == ServerResponseType.ERROR.name) {
        emit(RegisterSponsFailed());
      } else {
        emit(RegisterSponsWarning());
      }
    } on Exception catch (e) {
      emit(RegisterSponsFailed());
      developer.log('', error: 'Unhandled exception: ${e.toString()}');
    }
  }
}
