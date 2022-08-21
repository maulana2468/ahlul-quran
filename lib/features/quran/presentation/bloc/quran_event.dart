part of 'quran_bloc.dart';

abstract class QuranEvent extends Equatable {
  const QuranEvent();

  @override
  List<Object> get props => [];
}

class OnGetData extends QuranEvent {
  const OnGetData();
}

class OnSearch extends QuranEvent {
  const OnSearch(this.valueSearch);

  final String valueSearch;
}