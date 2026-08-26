import 'package:inquran/data/aggregate/doa.dart';
import 'package:inquran/data/local/db/app_database.dart';

sealed class DoaListState {}

class DoaListLoading extends DoaListState {}

class DoaListSuccess extends DoaListState {
  final List<DoaCategoryData> categories;
  DoaListSuccess(this.categories);
}

class DoaListEmpty extends DoaListState {}

class DoaListError extends DoaListState {
  final String message;
  DoaListError(this.message);
}

sealed class DoaDetailState {}

class DoaDetailLoading extends DoaDetailState {}

class DoaDetailSuccess extends DoaDetailState {
  final List<CompleteDoaData> doas;
  DoaDetailSuccess(this.doas);
}

class DoaDetailEmpty extends DoaDetailState {}

class DoaDetailError extends DoaDetailState {
  final String message;
  DoaDetailError(this.message);
}