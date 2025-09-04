import 'package:bloc/bloc.dart';
import 'package:edusponsor/Common/enums/response_type_enum.dart';
import 'package:edusponsor/Common/network/dio_fetch_api.dart';
import 'package:meta/meta.dart';
import 'dart:developer' as developer;

part 'institutionstatus_state.dart';

class InstitutionstatusCubit extends Cubit<InstitutionstatusState> {
  InstitutionstatusCubit() : super(InstitutionstatusInitial());

  Future<void> approveInstitution(Map body,int index,String button) async {
    emit(InstitutionsStatusChangeLoading(index: index,button: button));
    await Future.delayed(const Duration(seconds: 2));
    try {
      final response = await FetchApi.postData(
        endPoint: 'admin/approve/institution',
        body: body
      );
      if ((response?['type'] == ServerResponseType.SUCCESS.name)) {
        emit(
          InstitutionsStatusChangeSuccess(),
        );
      } else if (response?['type'] == ServerResponseType.ERROR.name) {
        emit(InstitutionsStatusChangeError());
      }
    } on Exception catch (e) {
      emit(InstitutionsStatusChangeError());
      developer.log('', error: 'Unhandled exception: ${e.toString()}');
    }
  }

  Future<void> rejectInstitution(Map body,int index,String button) async {
    emit(InstitutionsStatusChangeLoading(index: index,button: button));
    await Future.delayed(const Duration(seconds: 2));
    try {
      final response = await FetchApi.postData(
        endPoint: 'admin/reject/institution',
        body: body
      );
      if ((response?['type'] == ServerResponseType.SUCCESS.name)) {
        emit(
          InstitutionsStatusChangeSuccess(),
        );
      } else if (response?['type'] == ServerResponseType.ERROR.name) {
        emit(InstitutionsStatusChangeError());
      }
    } on Exception catch (e) {
      emit(InstitutionsStatusChangeError());
      developer.log('', error: 'Unhandled exception: ${e.toString()}');
    }
  }
}
