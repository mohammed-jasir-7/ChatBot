// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:chatbot/Controllers/gchat%20bloc/gchat_bloc.dart' as _i3;
import 'package:chatbot/Controllers/group%20functionality/group_functionality_bloc.dart'
    as _i10;
import 'package:chatbot/Controllers/profile/profile_bloc_bloc.dart' as _i12;
import 'package:chatbot/Models/group_model.dart' as _i6;
import 'package:chatbot/Service/group%20chat/group_chat_service.dart' as _i5;
import 'package:chatbot/Service/group%20service/group_repository.dart' as _i8;
import 'package:chatbot/Service/group%20service/group_service.dart' as _i7;
import 'package:chatbot/Service/profile%20service/profile_service.dart' as _i9;
import 'package:cloud_firestore/cloud_firestore.dart' as _i4;
import 'package:firebase_auth/firebase_auth.dart' as _i11;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart'
    as _i2; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
extension GetItInjectableX on _i1.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i3.GchatBloc>(
        () => _i3.GchatBloc(firestore: gh<_i4.FirebaseFirestore>()));
    gh.lazySingleton<_i5.GroupChatService>(() => _i5.GroupChatService());
    gh.lazySingleton<_i6.GroupModel>(() => _i6.GroupModel(
          name: gh<String>(),
          groupId: gh<String>(),
          adminOnlyMessage: gh<bool>(),
          photo: gh<String>(),
          lastMsg: gh<String>(),
          sendby: gh<String>(),
        ));
    gh.lazySingleton<_i7.GroupServices>(() => _i8.GroupRepository());
    gh.lazySingleton<_i9.ProfileService>(() => _i9.ProfileService());
    gh.factory<_i10.GroupFunctionalityBloc>(() => _i10.GroupFunctionalityBloc(
          groupServices: gh<_i7.GroupServices>(),
          firestore: gh<_i4.FirebaseFirestore>(),
          firebaseAuth: gh<_i11.FirebaseAuth>(),
        ));
    gh.factory<_i12.ProfileBlocBloc>(
        () => _i12.ProfileBlocBloc(profileService: gh<_i9.ProfileService>()));
    return this;
  }
}
