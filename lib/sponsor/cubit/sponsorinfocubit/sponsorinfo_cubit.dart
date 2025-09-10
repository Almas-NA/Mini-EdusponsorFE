import 'package:bloc/bloc.dart';
import 'package:edusponsor/Common/enums/response_type_enum.dart';
import 'package:edusponsor/Common/network/dio_fetch_api.dart';
import 'package:meta/meta.dart';
import 'dart:developer' as developer;

part 'sponsorinfo_state.dart';

class SponsorinfoCubit extends Cubit<SponsorinfoState> {
  SponsorinfoCubit() : super(SponsorinfoInitial());


  Future<void> getSponsorInfo(Map body) async {
    emit(SponsorinfoLoading());
    await Future.delayed(const Duration(seconds: 2));
    try {
      final response = await FetchApi.postData(
        endPoint: 'sponsor/get/info',
        body: body,
      );
      if ((response?['type'] == ServerResponseType.SUCCESS.name)) {
        emit(SponsorinfoLoaded(sponsordetails: response['responseData']['data'][0]));
      } else if (response?['type'] == ServerResponseType.ERROR.name) {
        emit(SponsorinfoError());
      }
    } on Exception catch (e) {
      emit(SponsorinfoError());
      developer.log('', error: 'Unhandled exception: ${e.toString()}');
    }
  }

  Future<void> updateSponsorInfo(Map body) async {
    emit(SponsorinfoUpdateLoading());
    await Future.delayed(const Duration(seconds: 2));
    try {
      final response = await FetchApi.postData(
        endPoint: 'sponsor/update/info',
        body: body,
      );
      if ((response?['type'] == ServerResponseType.SUCCESS.name)) {
        emit(SponsorinfoUpdateLoaded());
      } else if (response?['type'] == ServerResponseType.ERROR.name) {
        emit(SponsorinfoupdateError());
      }
    } on Exception catch (e) {
      emit(SponsorinfoupdateError());
      developer.log('', error: 'Unhandled exception: ${e.toString()}');
    }
  }
}
