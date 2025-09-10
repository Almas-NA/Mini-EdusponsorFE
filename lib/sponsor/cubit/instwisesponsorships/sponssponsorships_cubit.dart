import 'package:bloc/bloc.dart';
import 'package:edusponsor/Common/enums/response_type_enum.dart';
import 'package:edusponsor/Common/network/dio_fetch_api.dart';
import 'package:meta/meta.dart';
import 'dart:developer' as developer;

part 'sponssponsorships_state.dart';

class SponssponsorshipsCubit extends Cubit<SponssponsorshipsState> {
  SponssponsorshipsCubit() : super(SponssponsorshipsInitial());
  Future<void> getInstitutionSponsorships(Map body) async {
    emit(SponssponsorshipsLoading());
    await Future.delayed(const Duration(seconds: 2));
    try {
      final response = await FetchApi.postData(
        endPoint: 'sponsor/get/institution/sponsorships',
        body: body,
      );
      if ((response?['type'] == ServerResponseType.SUCCESS.name)) {
        emit(SponssponsorshipsLoaded(sponsorships: response['responseData']['data']??[]));
      } else if (response?['type'] == ServerResponseType.ERROR.name) {
        emit(SponssponsorshipsError());
      }
    } on Exception catch (e) {
      emit(SponssponsorshipsError());
      developer.log('', error: 'Unhandled exception: ${e.toString()}');
    }
  }
}
