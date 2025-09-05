import 'package:bloc/bloc.dart';
import 'package:edusponsor/Common/enums/response_type_enum.dart';
import 'package:edusponsor/Common/network/dio_fetch_api.dart';
import 'package:meta/meta.dart';
import 'dart:developer' as developer;

part 'sponsorstatus_state.dart';

class SponsorstatusCubit extends Cubit<SponsorstatusState> {
  SponsorstatusCubit() : super(SponsorstatusInitial());

  Future<void> approveSponsor(Map body, int index, String button) async {
    emit(SponsorstatusLoading(index: index, button: button));
    await Future.delayed(const Duration(seconds: 2));
    try {
      final response = await FetchApi.postData(
        endPoint: 'admin/approve/sponsor',
        body: body,
      );
      if ((response?['type'] == ServerResponseType.SUCCESS.name)) {
        emit(SponsorstatusSuccess());
      } else if (response?['type'] == ServerResponseType.ERROR.name) {
        emit(SponsorstatusError());
      }
    } on Exception catch (e) {
      emit(SponsorstatusError());
      developer.log('', error: 'Unhandled exception: ${e.toString()}');
    }
  }

  Future<void> rejectSponsor(Map body, int index, String button) async {
    emit(SponsorstatusLoading(index: index, button: button));
    await Future.delayed(const Duration(seconds: 2));
    try {
      final response = await FetchApi.postData(
        endPoint: 'admin/reject/sponsor',
        body: body,
      );
      if ((response?['type'] == ServerResponseType.SUCCESS.name)) {
        emit(SponsorstatusSuccess());
      } else if (response?['type'] == ServerResponseType.ERROR.name) {
        emit(SponsorstatusError());
      }
    } on Exception catch (e) {
      emit(SponsorstatusError());
      developer.log('', error: 'Unhandled exception: ${e.toString()}');
    }
  }
}
