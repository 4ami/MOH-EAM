part of 'bloc.dart';

sealed class ProfileEvent {
  final String description;
  const ProfileEvent({this.description = ''});
}

sealed class ProfileSuccessEvent extends ProfileEvent {
  final String title;
  const ProfileSuccessEvent({
    this.title = 'profile_success_title_general',
    super.description = 'profile_success_message_general',
  });
}

sealed class ProfileFailedEvent extends ProfileEvent {
  final String title, reason;
  const ProfileFailedEvent({
    this.title = 'profile_failed_title_general',
    super.description = 'profile_failed_message_general',
    required this.reason,
  });
}

final class ProfileInitEvent extends ProfileEvent {
  const ProfileInitEvent();
}

final class ProfileLoadingEvent extends ProfileEvent {
  const ProfileLoadingEvent();
}

final class GatherUserProfile extends ProfileEvent {
  final String token;
  const GatherUserProfile({required this.token});
}

final class ProfileGatheredSuccessfully extends ProfileSuccessEvent {
  const ProfileGatheredSuccessfully({
    super.title = 'profile_success_title_fetch',
    super.description = 'profile_success_message_fetch',
  });
}

final class ProfaileGatheringFailed extends ProfileFailedEvent {
  const ProfaileGatheringFailed({
    super.title = 'profile_failed_title_fetch',
    super.description = 'profile_failed_message_fetch',
    required super.reason,
  });
}
