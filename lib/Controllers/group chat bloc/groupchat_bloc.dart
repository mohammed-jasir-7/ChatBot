import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'groupchat_event.dart';
part 'groupchat_state.dart';

class GroupchatBloc extends Bloc<GroupchatEvent, GroupchatState> {
  GroupchatBloc() : super(GroupchatInitial()) {
    on<GroupchatEvent>((event, emit) {});
  }
}
