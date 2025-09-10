import 'package:bloc/bloc.dart';
import 'package:edusponsor/Common/enums/response_type_enum.dart';
import 'package:edusponsor/Common/network/dio_fetch_api.dart';
import 'package:meta/meta.dart';
import 'dart:developer' as developer;

part 'sponsorshipstatus_state.dart';

class SponsorshipstatusCubit extends Cubit<SponsorshipstatusState> {
  SponsorshipstatusCubit() : super(SponsorshipstatusInitial());


  Future<void> getSponsorInfo(Map body) async {
    emit(SponsorshipstatusChanging());
    await Future.delayed(const Duration(seconds: 2));
    try {
      final response = await FetchApi.postData(
        endPoint: 'sponsorship/change/status',
        body: body,
      );
      if ((response?['type'] == ServerResponseType.SUCCESS.name)) {
        emit(SponsorshipstatusChanged());
      } else if (response?['type'] == ServerResponseType.ERROR.name) {
        emit(SponsorshipstatusChangeError());
      }
    } on Exception catch (e) {
      emit(SponsorshipstatusChangeError());
      developer.log('', error: 'Unhandled exception: ${e.toString()}');
    }
  }
}
