import 'package:bloc/bloc.dart';
import 'package:edusponsor/Common/enums/response_type_enum.dart';
import 'package:edusponsor/Common/network/dio_fetch_api.dart';
import 'package:meta/meta.dart';
import 'dart:developer' as developer;

part 'sponsor_state.dart';

class SponsorCubit extends Cubit<SponsorState> {
  SponsorCubit() : super(SponsorInitial());

  Future<void> getSponsorsNotApproved() async {
    emit(SponsorLoading());
    await Future.delayed(const Duration(seconds: 2));
    try {
      final response = await FetchApi.getData(
        endPoint: 'admin/pending/sponsors',
      );
      if ((response?['type'] == ServerResponseType.SUCCESS.name)) {
        emit(
          SponsorLoaded(
            sponsors: response['responseData']['data']??[],
          ),
        );
      } else if (response?['type'] == ServerResponseType.ERROR.name) {
        emit(SponsorError());
      }
    } on Exception catch (e) {
      emit(SponsorError());
      developer.log('', error: 'Unhandled exception: ${e.toString()}');
    }
  }
}
