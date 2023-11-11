import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:injectable/injectable.dart';
part 'status_state.dart';

@Injectable()
class StatusCubit extends Cubit<StatusState> {
  final FirebaseFirestore firestore;
  final String userId;
  late final StreamSubscription subsription;
  StatusCubit({required this.firestore, required this.userId})
      : super(StatusInitial()) {
    subsription =
        firestore.collection("users").doc(userId).snapshots().listen((event) {
      if (event.data()!["isOnline"]) {
        emit(OnlineState());
      } else {
        emit(OfflineState());
      }
    });
  }
  @override
  Future<void> close() {
    subsription.cancel();
    return super.close();
  }
}
