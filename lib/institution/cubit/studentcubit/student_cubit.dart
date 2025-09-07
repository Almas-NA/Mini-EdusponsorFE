import 'package:bloc/bloc.dart';
import 'package:edusponsor/Common/enums/response_type_enum.dart';
import 'package:edusponsor/Common/network/dio_fetch_api.dart';
import 'package:meta/meta.dart';
import 'dart:developer' as developer;

part 'student_state.dart';

class StudentCubit extends Cubit<StudentState> {
  StudentCubit() : super(StudentInitial());

  void reset() {
    emit(StudentInitial());
  }

  Future<void> addStudent(Map body) async {
    emit(StudentAddLoading());
    await Future.delayed(const Duration(seconds: 2));
    try {
      final response = await FetchApi.postData(
        endPoint: 'institution/add/student',
        body: body,
      );
      if ((response?['type'] == ServerResponseType.SUCCESS.name)) {
        emit(StudentAddSuccess());
      } else if (response?['type'] == ServerResponseType.ERROR.name) {
        emit(StudentAddError());
      }
    } on Exception catch (e) {
      emit(StudentAddError());
      developer.log('', error: 'Unhandled exception: ${e.toString()}');
    }
  }

  Future<void> getStudents(Map body) async {
    emit(StudentGetLoading());
    await Future.delayed(const Duration(seconds: 2));
    try {
      final response = await FetchApi.postData(
        endPoint: 'institution/get/students',
        body: body,
      );
      if ((response?['type'] == ServerResponseType.SUCCESS.name)) {
        emit(
          StudentGetSuccess(
            institutionStudents: response?['responseData']['data'],
          ),
        );
      } else if (response?['type'] == ServerResponseType.ERROR.name) {
        emit(StudentGetError());
      }
    } on Exception catch (e) {
      emit(StudentGetError());
      developer.log('', error: 'Unhandled exception: ${e.toString()}');
    }
  }

  Future<void> updateStudent(Map body) async {
    emit(StudentUpdateLoading());
    await Future.delayed(const Duration(seconds: 2));
    try {
      final response = await FetchApi.postData(
        endPoint: 'institution/update/student',
        body: body,
      );
      if ((response?['type'] == ServerResponseType.SUCCESS.name)) {
        emit(StudentUpdateSuccess());
      } else if (response?['type'] == ServerResponseType.ERROR.name) {
        emit(StudentUpdateError());
      }
    } on Exception catch (e) {
      emit(StudentUpdateError());
      developer.log('', error: 'Unhandled exception: ${e.toString()}');
    }
  }

  Future<void> deleteStudent(Map body) async {
    emit(StudentDeleteLoading());
    await Future.delayed(const Duration(seconds: 2));
    try {
      final response = await FetchApi.postData(
        endPoint: 'institution/delete/student',
        body: body,
      );
      if ((response?['type'] == ServerResponseType.SUCCESS.name)) {
        emit(StudentDeleteSuccess());
      } else if (response?['type'] == ServerResponseType.ERROR.name) {
        emit(StudentDeleteError());
      }
    } on Exception catch (e) {
      emit(StudentDeleteError());
      developer.log('', error: 'Unhandled exception: ${e.toString()}');
    }
  }

  Future<void> createSponsorship(Map body) async {
    emit(StudentAddYearFeesLoading());
    await Future.delayed(const Duration(seconds: 2));
    try {
      final response = await FetchApi.postData(
        endPoint: 'institution/create/sponsorship',
        body: body,
      );
      if ((response?['type'] == ServerResponseType.SUCCESS.name)) {
        emit(StudentAddYearFeesSuccess());
      } else if (response?['type'] == ServerResponseType.ERROR.name) {
        emit(StudentAddYearFeesError());
      }
    } on Exception catch (e) {
      emit(StudentAddYearFeesError());
      developer.log('', error: 'Unhandled exception: ${e.toString()}');
    }
  }
}
