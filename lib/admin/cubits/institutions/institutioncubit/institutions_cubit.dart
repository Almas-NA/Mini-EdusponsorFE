import 'package:bloc/bloc.dart';
import 'package:edusponsor/Common/enums/response_type_enum.dart';
import 'package:edusponsor/Common/network/dio_fetch_api.dart';
import 'package:meta/meta.dart';
import 'dart:developer' as developer;

part 'institutions_state.dart';

class InstitutionsCubit extends Cubit<InstitutionsState> {
  InstitutionsCubit() : super(InstitutionsInitial());

  Future<void> getInstitutionsNotApproved() async {
    emit(InstitutionsLoading());
    await Future.delayed(const Duration(seconds: 2));
    try {
      final response = await FetchApi.getData(
        endPoint: 'admin/pending/institutions',
      );
      if ((response?['type'] == ServerResponseType.SUCCESS.name)) {
        emit(
          InstitutionsLoaded(
            institutionNotApproved: response['responseData']['data']??[],
          ),
        );
      } else if (response?['type'] == ServerResponseType.ERROR.name) {
        emit(InstitutionsError());
      }
    } on Exception catch (e) {
      emit(InstitutionsError());
      developer.log('', error: 'Unhandled exception: ${e.toString()}');
    }
  }
}
