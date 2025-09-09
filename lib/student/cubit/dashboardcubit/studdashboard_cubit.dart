import 'package:bloc/bloc.dart';
import 'package:edusponsor/Common/enums/response_type_enum.dart';
import 'package:edusponsor/Common/network/dio_fetch_api.dart';
import 'package:meta/meta.dart';
import 'dart:developer' as developer;

part 'studdashboard_state.dart';

class StuddashboardCubit extends Cubit<StuddashboardState> {
  StuddashboardCubit() : super(StuddashboardInitial());
  Future<void> getSponsorshipStatus(Map body) async {
    emit(SponsorshipStatusLoading());
    await Future.delayed(const Duration(seconds: 2));
    try {
      final response = await FetchApi.postData(
        endPoint: 'institution/check/sponsorship/exists',
        body: body,
      );
      if ((response?['type'] == ServerResponseType.SUCCESS.name)) {
        emit(SponsorshipStatusLoaded(sponsorshipStatus:response['responseData']['data'][0] ?? {},));
      } else if (response?['type'] == ServerResponseType.ERROR.name) {
        emit(SponsorshipStatusError());
      }
    } on Exception catch (e) {
      emit(SponsorshipStatusError());
      developer.log('', error: 'Unhandled exception: ${e.toString()}');
    }
  }
}
