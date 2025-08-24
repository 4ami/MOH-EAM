part of 'bloc.dart';

final class ProfileState {
  final ProfileEvent event;
  final ProfileEntity? profile;
  const ProfileState({this.event = const ProfileInitEvent(), this.profile});

  ProfileState copyWith({ProfileEvent? event, ProfileEntity? profile}) {
    return ProfileState(
      event: event ?? this.event,
      profile: profile ?? this.profile,
    );
  }
}
