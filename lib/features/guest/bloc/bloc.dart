library;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moh_eam/config/logging/logger.dart';
import 'package:moh_eam/core/data/model/api_error.dart';
import 'package:moh_eam/features/guest/data/model/profile_model.dart';
import 'package:moh_eam/features/guest/data/repository/profile_repo_imp.dart';
import 'package:moh_eam/features/guest/domain/entity/profile.dart';
import 'package:moh_eam/features/guest/domain/repository/profile_repo.dart';
import 'package:moh_eam/features/guest/domain/services/profile_gather.dart';

part 'state.dart';
part 'event.dart';

final class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepo _repo = ProfileRepoImp();

  ProfileBloc() : super(ProfileState()) {
    _gather();
  }

  String handleError(dynamic e) {
    Logger.e('key: ', tag: 'Bloc Handler', error: e);
    if (e is ApiException) return e.key;
    if (e is String) return e;
    return 'general_error_message';
  }

  void _gather() {
    ProfileModel? then(ProfileModel res) {
      if (res.code != 200) throw res.messageKey;
      return res;
    }

    on<GatherUserProfile>((event, emit) async {
      emit(state.copyWith(event: ProfileLoadingEvent()));
      Logger.d('Gathering user profile', tag: 'ProfileBloc');

      String key = '';

      ProfileGatherService service = ProfileGatherService(_repo);

      ProfileModel? res = await service(token: event.token)
          .then(then)
          .catchError((e) {
            key = handleError(e);
            return null;
          });

      Logger.i('Profile gather response received', tag: 'ProfileBloc');

      if (key.isNotEmpty || res == null) {
        emit(state.copyWith(event: ProfaileGatheringFailed(reason: key)));
        Logger.e('Profile gather failed with key: $key', tag: 'ProfileBloc');
        return;
      }

      Logger.d('Profaile gathered', tag: 'ProfileBloc');
      emit(
        state.copyWith(
          profile: res.toDomain(),
          event: ProfileGatheredSuccessfully(),
        ),
      );
    });
  }
}
