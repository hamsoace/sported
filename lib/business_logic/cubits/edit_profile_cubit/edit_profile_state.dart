part of 'edit_profile_cubit.dart';

abstract class EditProfileState extends Equatable {
  const EditProfileState();
}

class EditProfileInitial extends EditProfileState {
  @override
  List<Object> get props => [];
}

class EditProfileLoadInProgress extends EditProfileState {
  @override
  List<Object> get props => [];
}

class EditProfileLoadSuccess extends EditProfileState {
  final UserProfile userProfile;
  EditProfileLoadSuccess({this.userProfile});
  @override
  List<Object> get props => [userProfile];
}

class EditProfileLoadFailure extends EditProfileState {
  @override
  List<Object> get props => [];
}
//
// class EditProfileUpdateSuccess extends EditProfileState {
//   final UserProfile userProfile;
//   EditProfileUpdateSuccess({this.userProfile});
//   @override
//   List<Object> get props => [userProfile];
// }
//
// class ProfilePageLoadSuccess extends EditProfileState {
//   final UserProfile userProfile;
//   ProfilePageLoadSuccess({this.userProfile});
//   @override
//   List<Object> get props => [userProfile];
// }
