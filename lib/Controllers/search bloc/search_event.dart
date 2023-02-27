part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchingEvent extends SearchEvent {
  String query;
  SearchingEvent({required this.query});
}
